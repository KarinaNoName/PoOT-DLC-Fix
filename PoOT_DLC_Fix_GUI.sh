#!/usr/bin/env bash
# Optional graphical frontend for PoOT_DLC_Fix.sh.
# This wrapper does not modify files; the original version-locked script
# carries out all checks and filesystem operations.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CLI="$SCRIPT_DIR/PoOT_DLC_Fix.sh"
if [[ "${LANG:-}" == de* || "${LC_MESSAGES:-}" == de* ]]; then
  TITLE='PoOT DLC-Fix — experimentell'
  MISSING='PoOT_DLC_Fix.sh fehlt. Bitte das gesamte ZIP in einen gemeinsamen Ordner entpacken.'
  CHOOSE='Inoffizieller, versionsgebundener DLC-Workaround. Nur für gekaufte Steam-DLCs. Das Spiel vor Änderungen vollständig schließen.'
  OPTION_STATUS='Status prüfen (ändert nichts)'
  OPTION_INSTALL='Fix installieren / nach Steam-Update erneut installieren'
  OPTION_UNINSTALL='Originaldatei wiederherstellen'
  WARNING_INSTALL='Der Installer prüft die volle SHA-256-Prüfsumme, sichert das Original und verändert bei unterstützter Version 4 Bytes in GameAssembly.dll. Er überspringt eine DLC-Datei-Hash-Prüfung. Die Steam-Besitzprüfung bleibt unangetastet. Fortfahren?'
  WARNING_UNINSTALL='Die Originaldatei wird ausschließlich aus einer SHA-256-geprüften Sicherung wiederhergestellt. Die DLCs könnten danach wieder fehlen. Fortfahren?'
  SUCCESS='Ergebnis: BEFEHL ERFOLGREICH ABGESCHLOSSEN'
  FAILURE='Ergebnis: ABGEBROCHEN / FEHLER'
  FAILURE_TIP='Keine weiteren Befehle ausführen, bevor du die Meldung geprüft hast.'
else
  TITLE='PoOT DLC Fix — experimental'
  MISSING='PoOT_DLC_Fix.sh is missing. Please extract the entire ZIP into a single directory.'
  CHOOSE='Unofficial, version-locked DLC workaround. Only for purchased Steam DLCs. Close the game completely before modifying files.'
  OPTION_STATUS='Check status (read-only)'
  OPTION_INSTALL='Install fix / re-install after Steam update'
  OPTION_UNINSTALL='Restore original game file'
  WARNING_INSTALL='Installer verifies the full SHA-256, backs up the original and changes 4 bytes only on the supported game build. It bypasses one DLC file-hash check, NOT the Steam DLC ownership check. Continue?'
  WARNING_UNINSTALL='The original is only restored from a SHA-256-verified backup. DLCs might disappear again. Continue?'
  SUCCESS='Result: COMMAND COMPLETED SUCCESSFULLY'
  FAILURE='Result: STOPPED / ERROR'
  FAILURE_TIP='Review the error message before trying any additional commands.'
fi

if [[ ! -f "$CLI" ]]; then
  if command -v kdialog >/dev/null 2>&1; then
    kdialog --title "$TITLE" --error "$MISSING"
  else
    printf 'FEHLER: PoOT_DLC_Fix.sh fehlt. ZIP vollständig entpacken.\n' >&2
  fi
  exit 2
fi

if ! command -v kdialog >/dev/null 2>&1; then
  printf 'KDE kdialog ist nicht verfügbar. Bitte Konsole nutzen:\n' >&2
  printf '  bash "%s" status\n' "$CLI" >&2
  printf '  bash "%s" install\n' "$CLI" >&2
  printf '  bash "%s" uninstall\n' "$CLI" >&2
  exit 2
fi

CHOICE="$(kdialog --title "$TITLE" --menu \
  "$CHOOSE" \
  status "$OPTION_STATUS" \
  install "$OPTION_INSTALL" \
  uninstall "$OPTION_UNINSTALL")" || exit 0
case "$CHOICE" in
  status) ;;
  install)
    kdialog --title "$TITLE" --warningyesno \
      "$WARNING_INSTALL" || exit 0
    ;;
  uninstall)
    kdialog --title "$TITLE" --warningyesno \
      "$WARNING_UNINSTALL" || exit 0
    ;;
  *) exit 2 ;;
esac

REPORT="$(mktemp "${TMPDIR:-/tmp}/poot_gui_result.XXXXXXXX")"
trap 'rm -f -- "$REPORT"' EXIT
if bash "$CLI" "$CHOICE" >"$REPORT" 2>&1; then
  {
    printf '%s\n\n' "$SUCCESS"
    cat "$REPORT"
  } >"${REPORT}.display"
  mv -- "${REPORT}.display" "$REPORT"
  kdialog --title "$TITLE" --textbox "$REPORT" 850 500
else
  STATUS=$?
  {
    printf '%s (Exit-Code %s)\n' "$FAILURE" "$STATUS"
    printf '%s\n\n' "$FAILURE_TIP"
    cat "$REPORT"
  } >"${REPORT}.display"
  mv -- "${REPORT}.display" "$REPORT"
  kdialog --title "$TITLE" --textbox "$REPORT" 850 500
  exit "$STATUS"
fi
