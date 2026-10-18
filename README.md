# PoOT DLC Fix — Steam Deck (v0.2.0-rc2, experimental)

**Unofficial workaround** for *STORY OF SEASONS: Pioneers of Olive Town* (Steam AppID 1392960): On Proton, the base game can run while some purchased, installed DLCs are not detected. On **one precisely verified game build**, this fix changes four bytes in `GameAssembly.dll` so the DLC file-hash verification does not block access. **Steam DLC ownership checks are not changed.** The underlying Proton cause has not been conclusively proven.

## Important: GE-Proton is a separate prerequisite

**GE-Proton10-21 is NOT included in this download.** **ProtonUp-Qt** is **not bundled** either. Our DLC fix does not install, update, or configure Proton or ProtonUp-Qt. Both are separate third-party compatibility tools or projects.

For the **tested Steam Deck setup**, you must **install GE-Proton10-21 separately and select it for the game in Steam before using this setup**. If GE-Proton10-21 is already selected and the base game runs, **skip the optional Proton guide at the end** and go straight to "Install the DLC fix by double-clicking".

You also need the base game and any DLCs you want to use legitimately installed through Steam on your own account. The fix includes **neither Proton nor the game nor any DLCs**.

## Install the DLC fix by double-clicking

**Before you begin:** GE-Proton10-21 has been configured separately as explained above, and the game is fully closed.

1. Download the **PoOT DLC Fix ZIP** and **extract the entire archive** to one folder. Keep all included files together.
2. On Steam Deck, enter **Desktop Mode** and open the extracted folder in **Dolphin**.
3. Double-click `PoOT_DLC_Fix.desktop` and choose **Execute/Run** if Dolphin asks.
4. Select **"Check status"**. This is read-only. If you see `UNKNOWN / unsupported game version`, **stop**: your game build is not supported.
5. Choose **"Install fix"**, read the warning, and confirm. The installer verifies the build and makes a verified original backup before changing anything.
6. Start the game **normally through Steam** with **GE-Proton10-21**. Check the purchased DLC menu and try a DLC feature in the game.

The graphical menu uses KDE's `kdialog` in SteamOS Desktop Mode and calls the same tested backend installer. If Dolphin cannot execute the launcher, check its executable permission or use the terminal alternative below; there is no need to modify system files.

## Restore the original / remove the fix

Close the game. Open `PoOT_DLC_Fix.desktop` and choose **"Restore original game file"**. The installer restores `GameAssembly.dll` only from a **SHA-256-verified backup**. DLCs may disappear under Proton afterward. If the verified backup is missing, Steam's **Verify integrity of game files** can restore the original game files.

## Command-line alternative

Open a terminal in the extracted folder (Dolphin: **Open Terminal Here**) and run the command you need:

- Read-only status: `bash ./PoOT_DLC_Fix.sh status`
- Install fix: `bash ./PoOT_DLC_Fix.sh install`
- Restore original: `bash ./PoOT_DLC_Fix.sh uninstall`

For a game in another Steam library that is not automatically detected, the command-line tool supports `--game "/full/path/to/GameAssembly.dll"`. A second install location has not yet been tested on a physical device.

## Separate optional guide: Set up GE-Proton10-21 (only if needed)

**This is NOT a feature of our DLC fix or part of the ZIP download.** These instructions only help people who still need to set up the **separate prerequisite before playing**. **If you already installed and selected GE-Proton10-21 for the game, skip this entire section.**

1. Enter **Desktop Mode** on the Steam Deck and open the **Discover** software center (shopping-bag icon).
2. Search for **ProtonUp-Qt** and install it. ProtonUp-Qt is an independent compatibility-tool manager, **not** our DLC patch.
3. Launch **ProtonUp-Qt**. Choose Steam under **"Install for"**, then **"Add version"**.
4. Choose **GE-Proton** and specifically **GE-Proton10-21** (not automatically the latest release). Install it.
5. **Fully exit Steam** using **Steam → Exit**, then reopen Steam so it discovers the new tool.
6. In Steam Library, open **Pioneers of Olive Town → Properties → Compatibility**. Show all compatibility tools if needed and select **GE-Proton10-21** for this game.
7. Confirm that the **base game** launches. Exit it, then continue with **"Install the DLC fix by double-clicking"** above.

Button names may vary after SteamOS updates. Official projects: [ProtonUp-Qt](https://github.com/DavidoTek/ProtonUp-Qt) and [GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom). **We do not bundle either project or its files.**

## Tested and not tested

**Confirmed on one Steam Deck with one exact `GameAssembly.dll` build and GE-Proton10-21:** all three DLC regions, DLC NPC conversations, DLC clothing, save/load, reboot, at least one Steam achievement, GUI install/restore, and reinstalling after Steam Verify Integrity.

**Not confirmed:** other game builds, a second device, SD-card-only installs, all achievements, or a full long-term playthrough. The Steamworks callback 1023 hypothesis is **not** proven as the root cause.

- Supported original DLL SHA-256: `e5ae3bee96823ef8d770e9c9f2fd946042fc6193f5c797b6d17239e7a0cf3f34`
- Expected patched DLL SHA-256: `aef3c1ed4631cfe432301348a27f0d9fcaea15f4016529ed8ca4004bcaca6b1c`
- Original backup folder: `~/Documents/PoOT_DLC_Fix_Backups/`

## Safety and limitations

- The installer rejects unknown builds or changed game DLLs. **Do not force the patch.**
- The workaround **bypasses a DLC file-hash verification step**; it does not repair the Proton bug. This may mask a genuinely damaged DLC file.
- Steam updates or **Verify integrity of game files** may remove the patch. Recheck `status` and reinstall only if the supported original build is detected.
- Steam DLC ownership checks remain unchanged. **You must own the DLCs concerned.**
- The script requires no `sudo`, downloads nothing, and redistributes no game or DLC files.
- If you encounter errors, avoid blindly stacking patches. See the existing [Proton issue #7130](https://github.com/ValveSoftware/Proton/issues/7130) for technical discussion.

**Experimental release candidate, not a stable release validated on all devices.** Independent project, not affiliated with Valve, Marvelous, XSEED, or OpenAI. Our own code and documentation are licensed under `LICENSE` (MIT).
