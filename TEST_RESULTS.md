# Observed tests — one Steam Deck (2026-10-18)

This is a record of **one user-reported device test series**, not a broad compatibility guarantee. Original game and purchased DLCs came through Steam. The working setup was SteamOS with GE-Proton10-21 and a specific GameAssembly.dll identified by its SHA-256.

## Without patch

- Main game booted and a save loaded successfully under GE-Proton10-21.
- All five DLC entries were listed and checked in Steam. Relevant on-disk DLC data were present.
- In the game's title DLC menu, purchased DLCs were absent; this happened again after restoring the original DLL.

## With known four-byte workaround

- DLC entries became visible in the title menu.
- All three expansion destinations became accessible; NPC conversations worked.
- DLC clothing could be ordered and worn (panda costume observed).
- Save/load and Steam Deck reboot worked while patched.
- At least one Steam achievement (the clothing-collection achievement) unlocked while patched.
- Uninstall restored the original DLL; re-install restored DLC access.
- Steam file integrity check replaced the modified DLL with the original, and the installer then re-applied the workaround successfully.

## GUI validation

- Double-click launcher opened the KDE menu on the Deck.
- GUI read-only status output correctly showed the patch as installed.
- GUI installation on an already-patched build made no game-file changes.
- GUI restore successfully reinstalled the original DLL from a verified backup.
- GUI install then applied the known patch to an unmodified original DLL.
- User confirmed purchased DLCs reappeared in the game menu and an expansion area loaded after GUI installation.

## Not established

- The actual upstream root cause in Proton remains a **hypothesis**; callback 1023 warning correlation is not proof.
- Only one Steam Deck/game build has undergone these tests; other DLL checksums are refused intentionally.
- No independent second-device validation, all-achievement guarantee, SD-card install check, long-term/new-game playthrough, or native Windows test of this patch.
- The patch bypasses a DLC file-hash verification result; it does **not** repair the underlying callback marshaling and may mask a genuinely damaged DLC file. Users should verify their game files if corruption is suspected.

No full user logs, save data, game DLLs, or account identifiers are included in the distributable package.
