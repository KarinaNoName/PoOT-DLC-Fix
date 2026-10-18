#!/usr/bin/env bash
# Story of Seasons: Pioneers of Olive Town — DLC compatibility workaround
# Experimental, version-locked, local-only; contains no copyrighted game binaries.
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  echo 'Python 3 is required (included in standard SteamOS desktop installations).' >&2
  exit 2
fi
exec python3 - "$@" <<'PY'
from __future__ import annotations

import argparse
import hashlib
import os
import re
import stat
import sys
import tempfile
from pathlib import Path

# These hashes apply ONLY to the single, personally tested GameAssembly.dll version.
ORIGINAL_SHA256 = 'e5ae3bee96823ef8d770e9c9f2fd946042fc6193f5c797b6d17239e7a0cf3f34'
PATCHED_SHA256 = 'aef3c1ed4631cfe432301348a27f0d9fcaea15f4016529ed8ca4004bcaca6b1c'
PATCH_OFFSET = 0x90C321
ORIGINAL_BYTES = bytes.fromhex('0f b6 56 40')
PATCH_BYTES = bytes.fromhex('31 d2 fe c2')
GAME_DIR = 'STORY OF SEASONS Pioneers of Olive Town'
DLL = 'GameAssembly.dll'


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def abort(message: str) -> None:
    raise SystemExit('STOP: ' + message)


def steam_library_roots() -> list[Path]:
    home = Path.home()
    roots = {
        home / '.local/share/Steam',
        home / '.steam/steam',
    }
    candidates = list(roots)
    for steam in candidates:
        for config in (steam / 'steamapps/libraryfolders.vdf', steam / 'config/libraryfolders.vdf'):
            try:
                txt = config.read_text(encoding='utf-8', errors='replace')
            except (OSError, UnicodeError):
                continue
            # New Steam VDF format; no network requests or recursive drive scans.
            for value in re.findall(r'^\s*"path"\s+"([^"\n]+)"', txt, flags=re.MULTILINE):
                roots.add(Path(value.replace('\\\\', '\\')))
            # Old Steam VDF format.
            for value in re.findall(r'^\s*"\d+"\s+"(/[^"\n]+)"', txt, flags=re.MULTILINE):
                roots.add(Path(value.replace('\\\\', '\\')))
    return sorted(roots, key=str)


def find_game(explicit: str | None) -> Path:
    explicit = explicit or os.environ.get('POOT_GAMEASSEMBLY_PATH')
    if explicit:
        game = Path(explicit).expanduser().absolute()
        if game.is_dir():
            game = game / DLL
        return game
    found: dict[str, Path] = {}
    for root in steam_library_roots():
        candidate = root / 'steamapps/common' / GAME_DIR / DLL
        if candidate.is_file():
            found[str(candidate.resolve())] = candidate
    if not found:
        abort('GameAssembly.dll not found automatically. Use --game "/full/path/to/GameAssembly.dll".')
    if len(found) != 1:
        options = '\n'.join('  ' + str(x) for x in found.values())
        abort('Several game installs found. Select one with --game:\n' + options)
    return next(iter(found.values()))


def is_game_running() -> bool:
    # Only inspect local process names; no signals, kills or process modifications.
    proc = Path('/proc')
    try:
        paths = list(proc.iterdir())
    except OSError:
        return False
    for process in paths:
        if not process.name.isdecimal():
            continue
        try:
            command = (process / 'cmdline').read_bytes().lower()
        except (OSError, PermissionError):
            continue
        if b'story of seasons pioneers of olive town.exe' in command:
            return True
    return False


def atomic_write(target: Path, payload: bytes) -> None:
    fd, tmp_name = tempfile.mkstemp(prefix='.poot_fix_', dir=str(target.parent))
    try:
        with os.fdopen(fd, 'wb') as output:
            output.write(payload)
            output.flush()
            os.fsync(output.fileno())
        os.chmod(tmp_name, stat.S_IMODE(target.stat().st_mode))
        os.replace(tmp_name, target)
        try:
            directory_fd = os.open(str(target.parent), os.O_RDONLY)
            try:
                os.fsync(directory_fd)
            finally:
                os.close(directory_fd)
        except OSError:
            pass
    finally:
        if os.path.exists(tmp_name):
            os.unlink(tmp_name)


def trusted_backup_bytes(backup: Path, legacy_backup: Path) -> tuple[bytes | None, str]:
    for file in (backup, legacy_backup):
        if file.is_symlink():
            abort(f'Backup path is a symlink; inspect it manually: {file}')
        if file.exists():
            data = file.read_bytes()
            if sha256(data) != ORIGINAL_SHA256:
                abort(f'Backup exists but has an unexpected SHA-256. No changes made: {file}')
            return data, str(file)
    return None, 'none'


def create_backup(backup: Path, original: bytes) -> None:
    if sha256(original) != ORIGINAL_SHA256:
        abort('Refusing to back up an unknown game build.')
    backup.parent.mkdir(parents=True, exist_ok=True)
    # O_EXCL prevents silently overwriting an existing backup.
    descriptor = os.open(str(backup), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    try:
        with os.fdopen(descriptor, 'wb') as dest:
            dest.write(original)
            dest.flush()
            os.fsync(dest.fileno())
    except BaseException:
        try:
            backup.unlink()
        except OSError:
            pass
        raise
    if sha256(backup.read_bytes()) != ORIGINAL_SHA256:
        abort('Backup failed validation; DO NOT modify the game.')


def main() -> None:
    parser = argparse.ArgumentParser(
        description='Experimental version-locked PoOT DLC workaround (no game binaries included).'
    )
    parser.add_argument('action', nargs='?', choices=('status', 'install', 'uninstall'), default='status')
    parser.add_argument('--game', metavar='PATH', help='Path to GameAssembly.dll or game directory')
    parser.add_argument('--backup-dir', metavar='DIRECTORY', help=argparse.SUPPRESS)
    args = parser.parse_args()
    game = find_game(args.game)
    if game.is_symlink():
        abort(f'GameAssembly.dll is a symbolic link; no changes allowed: {game}')
    if not game.is_file():
        abort(f'File missing: {game}')
    source = game.read_bytes()
    current = sha256(source)
    if current == ORIGINAL_SHA256:
        state = 'ORIGINAL / unpatched'
    elif current == PATCHED_SHA256:
        state = 'PATCHED / workaround installed'
    else:
        state = 'UNKNOWN / unsupported game version'

    identity = hashlib.sha256(str(game.resolve()).encode('utf-8')).hexdigest()[:12]
    backups_root = Path(args.backup_dir).expanduser() if args.backup_dir else Path.home() / 'Documents/PoOT_DLC_Fix_Backups' / identity
    backup = backups_root / 'GameAssembly.original.dll'
    legacy = Path.home() / 'Documents/PoOT_DLC_Testpatch_Backup/GameAssembly.original.dll'
    print('Pioneers of Olive Town — DLC compatibility workaround (experimental)')
    print('Game:    ', game)
    print('State:   ', state)
    print('SHA-256: ', current)
    print('Backup:  ', backup)
    if args.action == 'status':
        # status is strictly read-only, even if a backup is missing.
        print('STATUS ONLY — no files changed.')
        return
    if current not in (ORIGINAL_SHA256, PATCHED_SHA256):
        abort('File hash is not on the supported list; update/other mod detected. Nothing changed.')
    if is_game_running():
        abort('The game appears to be running. Close it completely before modifying files.')

    saved, saved_from = trusted_backup_bytes(backup, legacy)

    if args.action == 'install':
        if current == PATCHED_SHA256:
            if saved is None:
                abort('Already patched, but no verified original backup found. Restore through Steam or your previous script first.')
            if not backup.exists():
                create_backup(backup, saved)
                print('Migrated verified original backup from:', saved_from)
            print('Already patched: no changes to the game file.')
            return
        if source[PATCH_OFFSET:PATCH_OFFSET + len(ORIGINAL_BYTES)] != ORIGINAL_BYTES:
            abort('Expected machine-code bytes not found at the known offset.')
        if saved is None:
            create_backup(backup, source)
            print('Original backed up safely.')
        elif not backup.exists():
            create_backup(backup, saved)
            print('Copied verified original backup from:', saved_from)
        changed = source[:PATCH_OFFSET] + PATCH_BYTES + source[PATCH_OFFSET + len(ORIGINAL_BYTES):]
        if sha256(changed) != PATCHED_SHA256:
            abort('Expected patched hash did not match. Game file not changed.')
        atomic_write(game, changed)
        if sha256(game.read_bytes()) != PATCHED_SHA256:
            try:
                atomic_write(game, source)
            except OSError:
                abort('Post-write validation failed; automatic rollback failed. Restore via verified backup or Steam file verification.')
            abort('Post-write validation failed; original restored automatically.')
        print('SUCCESS: workaround installed. Only the known 4 machine-code bytes were changed.')
        print('Steam DLC ownership checks are not modified. The file-hash verification is bypassed.')
        return

    if args.action == 'uninstall':
        if current == ORIGINAL_SHA256:
            print('Already original: no changes needed.')
            return
        if saved is None:
            abort('No SHA-256-verified original backup found. Use Steam > Installed Files > Verify integrity to restore.')
        atomic_write(game, saved)
        if sha256(game.read_bytes()) != ORIGINAL_SHA256:
            abort('Post-restore SHA-256 check failed. Stop; verify game files through Steam.')
        print('SUCCESS: original GameAssembly.dll restored from:', saved_from)
        return


if __name__ == '__main__':
    try:
        main()
    except (OSError, PermissionError, ValueError) as error:
        abort(f'{type(error).__name__}: {error}')
PY
