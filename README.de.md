# PoOT DLC Fix — Steam Deck (v0.2.0-rc2, experimentell)

**Inoffizieller Workaround** für *STORY OF SEASONS: Pioneers of Olive Town* (Steam AppID 1392960): Unter Proton startet das Hauptspiel, aber gekaufte und installierte DLCs werden bei manchen Nutzern nicht erkannt. Dieser Fix verändert bei **einer exakt geprüften Spielversion** vier Bytes der `GameAssembly.dll`, damit die DLC-Dateiprüfung nicht länger den Zugriff blockiert. Die **Steam-DLC-Besitzprüfung wird nicht verändert**. Die genaue Ursache im Proton-Code ist noch nicht abschließend bewiesen.

## Wichtig: GE-Proton ist eine separate Voraussetzung

**GE-Proton10-21 gehört NICHT zu diesem Download.** Auch **ProtonUp-Qt** ist **nicht enthalten**. Unser DLC-Fix installiert, aktualisiert oder konfiguriert weder Proton noch ProtonUp-Qt. Beide sind unabhängige Programme beziehungsweise Kompatibilitätswerkzeuge anderer Projekte.

Für die **hier getestete Steam-Deck-Einrichtung** musst du **GE-Proton10-21 vorher separat installieren und in Steam für das Spiel auswählen**. Wenn du diese Version bereits eingerichtet hast und das Hauptspiel damit startet, **überspringe die zusätzliche Proton-Anleitung am Ende** und beginne direkt mit „DLC-Fix per Doppelklick“.

Du brauchst außerdem das über Steam installierte Hauptspiel und die DLCs, die du verwenden möchtest, auf deinem eigenen Steam-Konto. Der Fix enthält **weder Proton noch das Spiel noch DLCs**.

## DLC-Fix per Doppelklick installieren

**Vorher:** GE-Proton10-21 ist wie oben beschrieben eingerichtet; das Spiel ist vollständig geschlossen.

1. Lade das **PoOT-DLC-Fix-ZIP** herunter und **entpacke es vollständig** in einen eigenen Ordner. Lass die Dateien zusammen.
2. Wechsle am Steam Deck in den **Desktop-Modus**. Öffne den entpackten Ordner im Dateimanager **Dolphin**.
3. Doppelklicke auf `PoOT_DLC_Fix.desktop` und wähle **Ausführen**, falls Dolphin fragt.
4. Wähle **„Status prüfen“**. Diese Option ändert keine Dateien. Wenn `UNKNOWN / unsupported game version` erscheint, **brich ab**; deine Spielversion wird nicht unterstützt.
5. Wähle **„Fix installieren“**, lies den Hinweis und bestätige. Der Installer prüft die Version und legt vor einer Änderung eine geprüfte Original-Sicherung an.
6. Starte das Spiel **normal über Steam** mit **GE-Proton10-21**. Kontrolliere im Titelmenü die gekauften DLCs und teste einen DLC-Inhalt im Spiel.

Das grafische Menü verwendet `kdialog` aus dem KDE-Desktop von SteamOS und ruft dasselbe geprüfte Installationsskript auf. Falls sich der Starter nicht ausführen lässt, überprüfe die Ausführungsberechtigung oder verwende die Konsolen-Alternative unten; ändere dafür keine Systemdateien.

## Original wiederherstellen / Fix entfernen

Beende das Spiel. Öffne `PoOT_DLC_Fix.desktop` und wähle **„Originaldatei wiederherstellen“**. Der Installer stellt `GameAssembly.dll` nur aus einer **SHA-256-geprüften Sicherung** wieder her. Die DLCs können dann unter Proton wieder verschwinden. Eine fehlende Sicherung kann nicht erfunden werden: In dem Fall lassen sich Original-Spieldateien über Steams **„Dateien auf Fehler überprüfen“** wiederherstellen.

## Alternative über Konsole

Öffne im entpackten Ordner ein Terminal (in Dolphin: **Terminal hier öffnen**). Dann jeweils den gewünschten Befehl verwenden:

- Nur Zustand anzeigen: `bash ./PoOT_DLC_Fix.sh status`
- Fix installieren: `bash ./PoOT_DLC_Fix.sh install`
- Original wiederherstellen: `bash ./PoOT_DLC_Fix.sh uninstall`

Wenn das Spiel in einer anderen Steam-Bibliothek liegt und nicht automatisch gefunden wird, ist für die Konsolenvariante die zusätzliche Option `--game "/vollständiger/pfad/zu/GameAssembly.dll"` vorgesehen. Diese Konfiguration wurde auf einem zweiten Installationsort noch nicht praktisch getestet.

## Separate Zusatzanleitung: GE-Proton10-21 einrichten (nur falls nötig)

**Dies ist keine Funktion unseres DLC-Fixes und kein Bestandteil des ZIP-Downloads.** Diese Schritte sind ausschließlich eine Hilfe, damit auch Nutzer ohne vorhandene GE-Proton-Installation die **separate Voraussetzung vor dem Spielstart** erfüllen können. **Wenn GE-Proton10-21 bereits installiert und für das Spiel ausgewählt ist, überspringe diesen ganzen Abschnitt.**

1. Wechsle am Steam Deck in den **Desktop-Modus** und öffne das Software-Center **Discover** (Einkaufstaschen-Symbol).
2. Suche nach **ProtonUp-Qt** und installiere es. Dies ist ein eigenständiges Programm für die Verwaltung von Kompatibilitätswerkzeugen, **nicht** unser DLC-Patch.
3. Öffne **ProtonUp-Qt**. Wähle bei **„Install for“** Steam und anschließend **„Neues hinzufügen“ / „Add version“**.
4. Wähle **GE-Proton** und ausdrücklich **GE-Proton10-21** (nicht automatisch die neueste Version). Installiere die Version.
5. Beende Steam **vollständig** über **Steam → Beenden** und öffne Steam erneut, damit es die neue Version erkennt.
6. Öffne in deiner Steam-Bibliothek **Pioneers of Olive Town → Eigenschaften → Kompatibilität**. Falls erforderlich, lass dir alle Kompatibilitätswerkzeuge anzeigen und wähle **GE-Proton10-21** für dieses Spiel aus.
7. Prüfe, ob das **Hauptspiel** startet. Beende es wieder und fahre dann mit **„DLC-Fix per Doppelklick installieren“** fort.

Die Bezeichnungen einzelner Schaltflächen können sich mit SteamOS-Updates ändern. Offizielle Projekte: [ProtonUp-Qt](https://github.com/DavidoTek/ProtonUp-Qt) und [GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom). **Weder diese Tools noch deren Dateien werden von uns mitgeliefert.**

## Getestet und noch offen

**Bestätigt auf einem Steam Deck mit genau einer `GameAssembly.dll`-Version und GE-Proton10-21:** alle drei DLC-Gebiete, NPC-Gespräche, DLC-Kleidung, Speichern/Laden, Neustart, mindestens ein Steam-Achievement, Installation und Wiederherstellung über das grafische Menü sowie erneute Installation nach einer Steam-Dateiprüfung.

**Nicht bestätigt:** andere Spielversionen, ein zweites Gerät, Installation ausschließlich auf SD-Karte, alle Achievements, vollständiger Langzeit-Spielverlauf. Die Vermutung zu Steamworks-Callback 1023 ist **nicht** als Ursache bewiesen.

- Unterstützte Original-DLL (SHA-256): `e5ae3bee96823ef8d770e9c9f2fd946042fc6193f5c797b6d17239e7a0cf3f34`
- Gepatchte DLL (SHA-256): `aef3c1ed4631cfe432301348a27f0d9fcaea15f4016529ed8ca4004bcaca6b1c`
- Sicherungsordner: `~/Documents/PoOT_DLC_Fix_Backups/`

## Sicherheit und Hinweise

- Bei unbekannten Spielversionen oder veränderter DLL verweigert der Installer den Eingriff. **Nicht erzwingen.**
- Der Workaround **überspringt eine DLC-Datei-Hash-Prüfung** und repariert den zugrunde liegenden Proton-Fehler nicht. Das kann theoretisch einen echten Schaden an einer DLC-Datei verdecken.
- Nach Steam-Updates oder **„Dateien auf Fehler überprüfen“** kann der Patch verschwinden. Danach `status` prüfen und nur bei unterstützter Originalversion erneut installieren.
- Die Steam-Besitzprüfung bleibt unverändert. **Du benötigst die jeweiligen gekauften DLCs.**
- Das Skript benötigt kein `sudo`, lädt nichts aus dem Internet herunter und verteilt keine Spiel- oder DLC-Dateien.
- Bei Fehlermeldungen nicht blind weitere Patches anwenden. Für die Fehlerdiagnose siehe den bestehenden [Proton-Bericht #7130](https://github.com/ValveSoftware/Proton/issues/7130).

**Experimenteller Release Candidate; kein für alle Geräte bestätigtes Stable-Release.** Unabhängiges Projekt, nicht mit Valve, Marvelous, XSEED oder OpenAI verbunden. Lizenz für unseren eigenen Code und die Dokumentation: `LICENSE` (MIT).
