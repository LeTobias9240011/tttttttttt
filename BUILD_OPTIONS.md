# 🔨 FairPoint - Build-Optionen Übersicht

Schnelle Übersicht über alle verfügbaren Build-Methoden für Android und iOS.

---

## 📱 Android Builds

### ✅ Direkt auf Windows möglich

| Methode | Befehl | Output | Verwendung |
|---------|--------|--------|------------|
| **APK** | `flutter build apk --release` | `app-release.apk` | Direktes Teilen/Testen |
| **AAB** | `flutter build appbundle --release` | `app-release.aab` | Google Play Store |
| **Split APK** | `flutter build apk --split-per-abi` | Mehrere APKs | Kleinere Größe |

### 🚀 Mit Build-Script

```bash
.\build.bat

[1] Android APK bauen (Release)
[2] Android AAB bauen (Play Store)
[3] Beide Android Versionen bauen
[5] Alles cleanen und neu bauen
```

**Output-Pfade:**
```
build/app/outputs/
├── flutter-apk/
│   └── app-release.apk           (ca. 40-60 MB)
└── bundle/release/
    └── app-release.aab           (ca. 30-40 MB)
```

---

## 🍎 iOS Builds

### ❌ NICHT direkt auf Windows möglich!

Apple erlaubt iOS-Kompilierung nur auf macOS. Aber es gibt Alternativen:

---

## 🌐 Cloud-Build-Optionen (Windows)

### Option 1: GitHub Actions ⭐ EMPFOHLEN

**Vorteile:**
- ✅ Komplett kostenlos (2000 Min/Monat private, unbegrenzt public)
- ✅ Keine Konfiguration nötig
- ✅ Automatisch bei jedem Push
- ✅ IPA Download als Artifact

**Nachteile:**
- ⚠️ Keine Code-Signierung (nur zum Testen)
- ⚠️ Kein direkter App Store Upload

**Schnellstart:**
```bash
# Mit Build-Script
.\build.bat
# Wähle [4] iOS zu GitHub pushen

# Oder manuell
git add .
git commit -m "iOS Build"
git push

# Dann:
# https://github.com/DEIN_USERNAME/DEIN_REPO/actions
# Warte 10-15 Minuten
# Lade "FairPoint-iOS" Artifact herunter
```

**Workflow-Datei:** `.github/workflows/build-ios.yml`

---

### Option 2: Codemagic 🎯 FÜR PRODUCTION

**Vorteile:**
- ✅ 500 Build-Minuten kostenlos
- ✅ Code-Signierung möglich
- ✅ Direkter Upload zu TestFlight/App Store
- ✅ Einfache UI

**Nachteile:**
- ⚠️ Registrierung erforderlich
- ⚠️ Limitiert auf 500 Min/Monat (kostenlos)

**Schnellstart:**
```bash
# 1. Registriere dich
https://codemagic.io

# 2. Verbinde GitHub Repository

# 3. Build wird automatisch gestartet
# Konfigurationsdatei ist bereits vorhanden
```

**Config-Datei:** `codemagic.yaml`

**Kosten:**
- 0€ - 500 Minuten/Monat
- 29€ - 1000 Minuten/Monat
- 99€ - 5000 Minuten/Monat

---

### Option 3: Remote Mac Service 💰

Miete einen Mac in der Cloud.

| Anbieter | Preis | Besonderheit |
|----------|-------|--------------|
| **MacinCloud** | Ab $30/Monat | Einfacher Zugang |
| **MacStadium** | Ab $99/Monat | Professionell |
| **AWS EC2 Mac** | Ab $1.08/Stunde | Pay-per-use |

**Vorteile:**
- ✅ Volle Kontrolle
- ✅ Xcode verfügbar
- ✅ Mehrere Projekte

**Nachteile:**
- ❌ Kostenpflichtig
- ❌ Komplexe Einrichtung

---

### Option 4: Lokaler Mac 🏆 IDEAL

Falls du Zugang zu einem Mac hast:

```bash
# Terminal auf dem Mac
cd /path/to/BONUSSYSTEMAPP

# Dependencies
flutter pub get
cd ios
pod install
cd ..

# Build
flutter build ios --release
# oder
flutter build ipa
```

**Output:** `build/ios/ipa/fairpoint.ipa`

---

## 📊 Vergleich: Welche Option ist die Richtige?

### Für Entwicklung/Testing:
```
Windows → GitHub Actions → IPA Download → Diawi/TestFlight
```

### Für Production (App Store):
```
Windows → Codemagic (mit Code-Signing) → TestFlight → App Store
```

### Mit Mac-Zugang:
```
Mac → flutter build ipa → Xcode → TestFlight → App Store
```

---

## 🎯 Empfehlungen nach Szenario

### Szenario 1: Hobby-Projekt
**Empfehlung:** GitHub Actions
- Kostenlos
- Ausreichend für Tests
- Einfach einzurichten

### Szenario 2: Professionelle App
**Empfehlung:** Codemagic
- Code-Signierung
- TestFlight Integration
- Professioneller Support

### Szenario 3: Großes Team
**Empfehlung:** Remote Mac + Codemagic
- Dedizierte Build-Umgebung
- CI/CD Pipeline
- Volle Kontrolle

### Szenario 4: Budget vorhanden
**Empfehlung:** Lokaler Mac
- Beste Performance
- Keine Cloud-Abhängigkeit
- Volle Flexibilität

---

## ⚡ Schnellreferenz: Build-Befehle

### Android (lokal)
```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# Release AAB (Play Store)
flutter build appbundle --release

# Mit Obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

### iOS (auf Mac)
```bash
# Debug
flutter run -d ios

# Release
flutter build ios --release

# IPA erstellen
flutter build ipa

# Ohne Code-Signing
flutter build ios --release --no-codesign
```

### iOS (auf Windows)
```bash
# Build-Script nutzen
.\build.bat
# Wähle [4] iOS zu GitHub pushen

# Oder manuell pushen
git add .
git commit -m "iOS Build"
git push

# Dann GitHub Actions abwarten
```

---

## 📁 Build-Output-Struktur

```
BONUSSYSTEMAPP/
├── build/
│   ├── app/
│   │   └── outputs/
│   │       ├── flutter-apk/
│   │       │   └── app-release.apk        ← Android APK
│   │       └── bundle/release/
│   │           └── app-release.aab        ← Android AAB
│   └── ios/
│       ├── ipa/
│       │   └── fairpoint.ipa              ← iOS IPA (nur Mac)
│       └── iphoneos/
│           └── Runner.app                 ← iOS App
└── [GitHub Actions]
    └── Artifacts/
        └── FairPoint-iOS.zip              ← iOS IPA (Windows)
```

---

## 🔄 CI/CD Workflow-Überblick

### GitHub Actions Workflow
```yaml
Push zu GitHub
    ↓
GitHub Actions startet
    ↓
macOS Runner wird bereitgestellt
    ↓
Flutter wird installiert
    ↓
Dependencies werden geholt
    ↓
iOS App wird gebaut (no-codesign)
    ↓
IPA wird erstellt
    ↓
Upload als Artifact
    ↓
Download bereit (30 Tage)
```

### Codemagic Workflow
```yaml
Push zu GitHub/Commit in Codemagic
    ↓
Codemagic startet Build
    ↓
Code-Signing wird angewendet
    ↓
iOS App wird gebaut
    ↓
IPA wird erstellt
    ↓
Upload zu TestFlight (optional)
    ↓
Download/Distribution
```

---

## 🐛 Troubleshooting

### Problem: Build dauert zu lange
**Lösung:**
```bash
# Gradle (Android)
# In android/gradle.properties:
org.gradle.parallel=true
org.gradle.caching=true

# Flutter
flutter pub cache repair
```

### Problem: GitHub Actions schlägt fehl
**Lösung:**
```bash
# 1. Prüfe Logs im Actions Tab
# 2. Häufige Ursachen:
#    - Firebase-Config fehlt
#    - Podfile Fehler
#    - Flutter Version

# 3. Teste lokal (wenn möglich)
flutter doctor
flutter analyze
```

### Problem: APK zu groß
**Lösung:**
```bash
# Split APKs erstellen
flutter build apk --release --split-per-abi

# Mit Obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# Ergebnis: 3 APKs statt 1, jeweils ~50% kleiner
```

---

## 📚 Weiterführende Links

- **Detaillierte Android-Anleitung**: [BUILD_GUIDE.md](BUILD_GUIDE.md)
- **Detaillierte iOS-Anleitung**: [IOS_BUILD_GUIDE.md](IOS_BUILD_GUIDE.md)
- **iOS Schnellstart**: [IOS_QUICKSTART.md](IOS_QUICKSTART.md)
- **Haupt-Dokumentation**: [README.md](README.md)
- **Firebase Setup**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

---

## ✅ Pre-Build Checkliste

Vor jedem Build:

- [ ] Version erhöht (`pubspec.yaml`)
- [ ] `flutter doctor` ohne Fehler
- [ ] `flutter analyze` ohne Warnings
- [ ] Firebase korrekt konfiguriert
- [ ] Alle Änderungen committed
- [ ] README/CHANGELOG aktualisiert
- [ ] Test auf mindestens einem Gerät

---

**Viel Erfolg beim Bauen!** 🚀
