# 🔨 Build-Anleitung für FairPoint

Komplette Anleitung zum Bauen und Deployen der FairPoint App.

## 📋 Voraussetzungen

### 1. Flutter SDK installieren

**Windows:**
```powershell
# Download Flutter von: https://flutter.dev/docs/get-started/install/windows
# Entpacke nach C:\src\flutter
# Füge zum PATH hinzu: C:\src\flutter\bin
```

**Verifizieren:**
```bash
flutter --version
flutter doctor
```

### 2. Entwicklungsumgebung einrichten

**Android Studio** (empfohlen):
- Download: https://developer.android.com/studio
- Installiere Android SDK
- Installiere Flutter & Dart Plugins

**VS Code** (Alternative):
- Download: https://code.visualstudio.com/
- Installiere Extensions: Flutter, Dart

### 3. Android SDK Setup (WICHTIG für Windows)

#### Option A: Android Studio installieren (Empfohlen)

**Schritt 1: Android Studio herunterladen und installieren**
```powershell
# Download von: https://developer.android.com/studio
# Installiere nach: C:\Program Files\Android\Android Studio
```

**Schritt 2: Android Studio erstmalig öffnen**
- Starte Android Studio
- Folge dem Setup-Wizard
- Wähle "Standard" Installation
- Der SDK Manager wird automatisch geöffnet

**Schritt 3: SDK Komponenten installieren**

In Android Studio:
1. Öffne: `Tools` → `SDK Manager`
2. Unter "SDK Platforms" installiere:
   - ✅ Android 14.0 (API 34) - Latest
   - ✅ Android 13.0 (API 33)
   - ✅ Android SDK Command-line Tools

3. Unter "SDK Tools" installiere:
   - ✅ Android SDK Build-Tools (latest)
   - ✅ Android SDK Command-line Tools (latest)
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
   - ✅ Intel x86 Emulator Accelerator (HAXM installer)

**Schritt 4: ANDROID_HOME Umgebungsvariable setzen**

```powershell
# Öffne PowerShell als Administrator

# Standard SDK-Pfad (überprüfe deinen Pfad!)
$androidSdk = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"

# Setze ANDROID_HOME dauerhaft
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdk, "User")

# Füge Platform-Tools und Tools zum PATH hinzu
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$androidSdk\platform-tools;$androidSdk\tools;$androidSdk\tools\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# PowerShell neu starten!
```

**Schritt 5: Verifizieren**
```powershell
# Neue PowerShell öffnen!
echo $env:ANDROID_HOME
# Sollte ausgeben: C:\Users\<DeinName>\AppData\Local\Android\Sdk

# ADB testen
adb version

# Flutter prüfen
flutter doctor
```

**Schritt 6: Android Lizenzen akzeptieren**
```powershell
flutter doctor --android-licenses
# Drücke 'y' für alle Lizenzen
```

#### Option B: Manueller Android SDK Download (Ohne Android Studio)

**Nur verwenden, wenn du Android Studio NICHT installieren möchtest!**

**Schritt 1: Command Line Tools herunterladen**
```powershell
# Download von: https://developer.android.com/studio#command-line-tools-only
# Wähle: "commandlinetools-win-XXXXXX_latest.zip"
```

**Schritt 2: SDK Verzeichnis erstellen**
```powershell
# Erstelle Ordner
mkdir C:\Android\Sdk
mkdir C:\Android\Sdk\cmdline-tools\latest

# Entpacke die ZIP-Datei nach:
# C:\Android\Sdk\cmdline-tools\latest\
```

**Schritt 3: ANDROID_HOME setzen**
```powershell
# PowerShell als Administrator
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Android\Sdk", "User")

$androidSdk = "C:\Android\Sdk"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$androidSdk\cmdline-tools\latest\bin;$androidSdk\platform-tools"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

**Schritt 4: SDK Pakete installieren**
```powershell
# Neue PowerShell öffnen!
cd C:\Android\Sdk\cmdline-tools\latest\bin

# Build Tools installieren
.\sdkmanager.bat "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Lizenzen akzeptieren
.\sdkmanager.bat --licenses
```

**Schritt 5: Flutter konfigurieren**
```powershell
flutter config --android-sdk C:\Android\Sdk
flutter doctor
```

### 4. Für iOS (nur macOS)

```bash
# Xcode installieren
# Command Line Tools installieren
xcode-select --install

# CocoaPods installieren
sudo gem install cocoapods
```

## 🚀 Projekt bauen

### Schritt 1: Dependencies installieren

```bash
cd C:\Users\ByteCodes_\Desktop\BONUSSYSTEMAPP
flutter pub get
```

### Schritt 2: Firebase konfigurieren

**Option A: FlutterFire CLI (Empfohlen)**

```bash
# Firebase CLI installieren
npm install -g firebase-tools
firebase login

# FlutterFire CLI installieren
dart pub global activate flutterfire_cli

# Firebase konfigurieren
flutterfire configure
```

**Option B: Manuell**

1. Erstelle Firebase Projekt: https://console.firebase.google.com/
2. Lade Konfigurationsdateien herunter:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
3. Aktualisiere `lib/firebase_options.dart` mit deinen Credentials

Siehe: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### Schritt 3: Build-Varianten

## 🔧 Entwicklungs-Builds

### Debug Build (zum Testen)

```bash
# Android
flutter run

# iOS (nur macOS)
flutter run -d ios

# Spezifisches Gerät
flutter devices                    # Verfügbare Geräte anzeigen
flutter run -d <device-id>
```

**Features:**
- ✅ Hot Reload
- ✅ Debugging
- ✅ Große App-Größe
- ✅ Langsame Performance

### Profile Build (Performance-Tests)

```bash
flutter run --profile
```

**Features:**
- ✅ Performance-Profiling
- ✅ Ähnlich wie Release
- ❌ Kein Hot Reload

## 📦 Release Builds

### Android APK (zum Testen/Verteilen)

```bash
# APK bauen
flutter build apk --release

# Ausgabe:
# build/app/outputs/flutter-apk/app-release.apk
```

**APK installieren:**
```bash
# Gerät verbinden
adb devices

# APK installieren
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (für Google Play Store)

```bash
# App Bundle bauen
flutter build appbundle --release

# Ausgabe:
# build/app/outputs/bundle/release/app-release.aab
```

**Warum App Bundle?**
- ✅ Kleinere Downloads für Benutzer
- ✅ Optimiert für verschiedene Geräte
- ✅ Erforderlich für Google Play Store

### iOS Build (nur macOS)

```bash
# Pods installieren
cd ios
pod install
cd ..

# iOS App bauen
flutter build ios --release

# Oder direkt Archive erstellen
flutter build ipa
```

**IPA Datei:**
- Ausgabe: `build/ios/ipa/fairpoint.ipa`
- Upload zu TestFlight/App Store via Xcode

### iOS Build auf Windows

**Du kannst iOS-Apps NICHT direkt auf Windows kompilieren!**

Apple erlaubt iOS-Kompilierung nur auf macOS. Für Windows-Nutzer gibt es jedoch Alternativen:

#### Option 1: GitHub Actions (KOSTENLOS) ✅ **EMPFOHLEN**

Die einfachste Lösung für Windows-Nutzer:

```bash
# 1. Pushe dein Projekt zu GitHub
git add .
git commit -m "iOS Build vorbereiten"
git push

# 2. GitHub Actions baut automatisch die iOS-App
# 3. Gehe zu: https://github.com/DEIN_USERNAME/DEIN_REPO/actions
# 4. Lade die IPA-Datei unter "Artifacts" herunter
```

**Oder nutze das Build-Script:**
```bash
.\build.bat
# Wähle Option 4: "iOS zu GitHub pushen"
```

**Details:** Siehe [IOS_BUILD_GUIDE.md](IOS_BUILD_GUIDE.md)

#### Option 2: Codemagic

Professioneller CI/CD-Service mit 500 kostenlosen Minuten pro Monat.

```bash
# 1. Registriere dich auf https://codemagic.io
# 2. Verbinde dein GitHub-Repository
# 3. Die codemagic.yaml ist bereits konfiguriert
# 4. Starte den Build in der Codemagic UI
```

#### Option 3: Remote Mac Service

Miete einen Mac in der Cloud (ab $30/Monat):
- MacStadium
- MacinCloud
- AWS EC2 Mac Instances

#### Vergleich der Optionen

| Option | Kosten | Code-Signierung | Empfehlung |
|--------|--------|----------------|------------|
| GitHub Actions | Kostenlos | ❌ Nur zum Testen | ✅ Entwicklung |
| Codemagic | 500 Min Free | ✅ Ja | ✅ Production |
| Remote Mac | Ab $30/Monat | ✅ Ja | Fortgeschrittene |
| Lokaler Mac | Kostenlos | ✅ Ja | ✅✅ Ideal |

## 🔐 App Signierung

### Android App signieren

#### 1. Keystore erstellen

```bash
keytool -genkey -v -keystore fairpoint-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fairpoint
```

**Speichere diese Informationen sicher:**
- Keystore Passwort
- Key Alias Passwort
- Distinguished Name Informationen

#### 2. Key Properties konfigurieren

Erstelle `android/key.properties`:

```properties
storePassword=<dein-keystore-passwort>
keyPassword=<dein-key-passwort>
keyAlias=fairpoint
storeFile=<pfad-zu-fairpoint-release-key.jks>
```

#### 3. build.gradle aktualisieren

Öffne `android/app/build.gradle` und füge hinzu:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 4. Signierte APK/AAB bauen

```bash
flutter build apk --release
# oder
flutter build appbundle --release
```

### iOS App signieren

1. Öffne `ios/Runner.xcworkspace` in Xcode
2. Wähle Signing & Capabilities
3. Wähle dein Team
4. Configure Automatic Signing

## 🌐 Build für Web

```bash
# Web Build erstellen
flutter build web --release

# Ausgabe: build/web/

# Lokal testen
flutter run -d chrome
```

**Deployment-Optionen:**
- Firebase Hosting
- GitHub Pages
- Netlify
- Vercel
- Eigener Server

## 📊 Build-Optimierungen

### App-Größe reduzieren

```bash
# Mit Obfuscation und Tree Shaking
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# Split APKs für verschiedene Architekturen
flutter build apk --release --split-per-abi
```

**Ergebnis:**
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### Build-Variablen

**Version anpassen:**

In `pubspec.yaml`:
```yaml
version: 1.0.0+1
#        ^     ^
#        |     Build Number (für Stores)
#        Version Name (für Benutzer)
```

**Build Number erhöhen:**
```yaml
version: 1.0.1+2
```

## 🧪 Build testen

### Android

```bash
# Debug Build installieren und starten
flutter install

# Logs ansehen
flutter logs

# Performance messen
flutter run --profile
# Dann: DevTools öffnen für Performance-Analyse
```

### iOS

```bash
# Simulator starten
open -a Simulator

# App im Simulator installieren
flutter run

# Physisches Gerät
flutter run -d <device-id>
```

## 📱 Build-Dateien

### Android

```
build/app/outputs/
├── flutter-apk/
│   ├── app-release.apk           # Universal APK
│   ├── app-armeabi-v7a-release.apk
│   ├── app-arm64-v8a-release.apk
│   └── app-x86_64-release.apk
└── bundle/release/
    └── app-release.aab           # App Bundle für Play Store
```

### iOS

```
build/ios/
├── iphoneos/
│   └── Runner.app               # iOS App
└── ipa/
    └── fairpoint.ipa            # Installationspaket
```

## 🐛 Troubleshooting

### "Flutter not found"

```bash
# PATH prüfen
echo $PATH  # macOS/Linux
echo %PATH% # Windows

# Flutter-Pfad hinzufügen
export PATH="$PATH:/path/to/flutter/bin"  # macOS/Linux
```

### "SDK not found" oder "Unable to locate Android SDK"

**Problem**: Flutter kann den Android SDK nicht finden.

**Lösung 1: Android Studio installieren**
```powershell
# 1. Android Studio installieren
# Download: https://developer.android.com/studio

# 2. Android Studio öffnen und Setup-Wizard folgen
# 3. SDK Manager öffnen (Tools → SDK Manager)
# 4. Android SDK installieren (siehe Abschnitt 3)

# 5. ANDROID_HOME setzen
[Environment]::SetEnvironmentVariable("ANDROID_HOME", 
    "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk", "User")

# 6. PowerShell NEU STARTEN!
# 7. Verifizieren
flutter doctor
```

**Lösung 2: Existierenden SDK-Pfad angeben**
```powershell
# Finde deinen SDK-Pfad
# Typische Pfade:
# C:\Users\<Username>\AppData\Local\Android\Sdk
# C:\Android\Sdk
# C:\Program Files\Android\Sdk

# SDK-Pfad manuell setzen
flutter config --android-sdk "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"

flutter doctor -v
```

**Lösung 3: Umgebungsvariablen prüfen**
```powershell
# ANDROID_HOME prüfen
echo $env:ANDROID_HOME

# Wenn leer, setze es:
$androidSdk = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdk, "User")

# PATH prüfen
echo $env:PATH | Select-String "Android"

# Platform-tools zum PATH hinzufügen
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$androidSdk\platform-tools;$androidSdk\tools;$androidSdk\cmdline-tools\latest\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# WICHTIG: PowerShell neu starten!
```

**Lösung 4: Lizenzen nicht akzeptiert**
```powershell
# Starte PowerShell als Administrator
flutter doctor --android-licenses
# Drücke 'y' für alle Lizenzen
```

**Verifizierung:**
```powershell
# 1. Neue PowerShell öffnen
# 2. Prüfen:
echo $env:ANDROID_HOME
adb version
flutter doctor -v
```

### Android Build Fehler

```bash
# Clean build
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk
```

### iOS Build Fehler

```bash
# Pods neu installieren
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter build ios
```

### "Firebase configuration not found"

```bash
# Firebase neu konfigurieren
flutterfire configure
```

### Build dauert sehr lange

```bash
# Gradle Daemon aktivieren (Android)
# In android/gradle.properties:
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

## 📈 Build-Performance verbessern

### Gradle (Android)

In `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
```

### Flutter

```bash
# Pub Cache leeren (bei Problemen)
flutter pub cache repair

# Analyze vor Build
flutter analyze
```

## 🚀 Deployment Checkliste

### Vor dem Release

- [ ] Version Number erhöht (`pubspec.yaml`)
- [ ] CHANGELOG.md aktualisiert
- [ ] Flutter analyze ohne Fehler
- [ ] App auf mehreren Geräten getestet
- [ ] Firebase korrekt konfiguriert
- [ ] Security Rules geprüft
- [ ] Screenshots für Stores erstellt
- [ ] Store-Beschreibung vorbereitet

### Android Deployment

- [ ] App Bundle gebaut (`flutter build appbundle`)
- [ ] Mit Release Key signiert
- [ ] Play Store Listing vorbereitet
- [ ] Upload zu Google Play Console

### iOS Deployment

- [ ] Archive erstellt (`flutter build ipa`)
- [ ] Über Xcode zu TestFlight hochgeladen
- [ ] Beta-Testing durchgeführt
- [ ] App Store Listing vorbereitet
- [ ] Review eingereicht

## 📚 Weitere Ressourcen

- [Flutter Deployment Docs](https://flutter.dev/docs/deployment)
- [Android Publishing Guide](https://developer.android.com/studio/publish)
- [iOS Distribution Guide](https://developer.apple.com/distribute/)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

**Viel Erfolg beim Bauen deiner App!** 🎉
