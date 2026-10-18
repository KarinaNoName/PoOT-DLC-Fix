# Changelog

## v0.2.0-rc2 — player-facing documentation and package cleanup (2026-10-18)
- Simplified the player download to eight files: installer, GUI, launcher, German and English READMEs, license, changelog and integrity manifest.
- Clearly separated GE-Proton10-21 (a third-party prerequisite, not bundled or installed by this fix) from the DLC fix. Added an optional ProtonUp-Qt setup guide for users who still need it.
- Aligned the German and English instructions and clarified limitations, verified tests and recovery after Steam file verification.
- Kept `TEST_RESULTS.md` for the planned GitHub repository only. Kept internal release checklist and Valve issue draft out of the public package.
- **No changes to the previously tested patch backend, graphical wrapper or desktop launcher.**

## v0.2.0-rc1 — validated GUI release candidate (2026-10-18)
- Confirmed the double-click KDE GUI on a real Steam Deck: status, install, uninstall, re-install and a successful in-game DLC area test afterward.
- Updated documentation and release checklist to distinguish single-device tests from untested versions/environments.
- Backend and graphical scripts are byte-identical to those used for testing in v0.2.0.

## v0.2.0 — GUI prerelease candidate (2026-10-18)
- Added optional KDE GUI launcher (`PoOT_DLC_Fix.desktop` and `PoOT_DLC_Fix_GUI.sh`).
- Uses the unchanged v0.1.0 version-locked backend; no new patch logic.
- Documents successful test of recovery after Steam's file-integrity verification.
- Explicitly labels the GUI and other-machine compatibility as unverified at that release stage.

## v0.1.0 — initial experimental workaround
- Version-locked four-byte patch, original-file verification and backup, `status`, `install`, `uninstall`.
- Confirmed on one Steam Deck with legitimately installed DLCs, GE-Proton10-21.
