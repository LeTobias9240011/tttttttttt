# 🚀 Quick Start Guide - FairPoint

Schnelleinstieg in 5 Minuten!

## ⚡ Schnellstart (Entwicklungsumgebung)

### 1. Flutter installieren

Windows:
```powershell
# Download Flutter SDK von https://flutter.dev/docs/get-started/install/windows
# Entpacke es nach C:\src\flutter
# Füge C:\src\flutter\bin zum PATH hinzu
```

Prüfe Installation:
```bash
flutter doctor
```

### 2. Dependencies installieren

```bash
cd BONUSSYSTEMAPP
flutter pub get
```

### 3. Firebase konfigurieren

**Option A: Schnell-Demo (ohne echtes Firebase)**
Für erste Tests kannst du die App mit Mock-Daten starten (siehe `DEVELOPMENT.md`)

**Option B: Mit Firebase (Empfohlen)**
```bash
# Firebase CLI installieren
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Firebase konfigurieren
flutterfire configure
```

Siehe detaillierte Anleitung: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 4. App starten

```bash
# Android Emulator starten oder Gerät verbinden
flutter run
```

### 5. Erster Admin-Login

Nach Firebase-Setup:
- Benutzername: `admin`
- Passwort: [dein gewähltes Passwort]

## 📱 Hauptfunktionen im Überblick

### Als Admin

1. **Kinder hinzufügen**
   - Klicke auf das "+" Icon in der App-Bar
   - Fülle das Formular aus
   - Konto erstellen

2. **Punkte vergeben**
   - Wähle ein Kind aus der Liste
   - Klicke "Punkte vergeben"
   - Gib Anzahl und Grund ein

3. **Belohnungen verwalten**
   - Gehe zum "Belohnungen"-Tab
   - Klicke "+" um neue Belohnungen zu erstellen

4. **Anfragen bearbeiten**
   - Gehe zum "Anfragen"-Tab
   - Genehmige oder lehne Belohnungsanfragen ab

### Als Kind

1. **Punkte ansehen**
   - Startseite zeigt aktuellen Punktestand
   - Fortschrittsbalken zum Wochenziel

2. **Belohnungen einlösen**
   - Gehe zum "Belohnungen"-Tab
   - Wähle verfügbare Belohnung
   - Warte auf Admin-Genehmigung

3. **Verlauf prüfen**
   - "Verlauf"-Tab zeigt alle Transaktionen
   - Siehe wer wann Punkte vergeben hat

## 🎯 Typischer Workflow

```
1. Admin erstellt Kindkonten
   ↓
2. Admin vergibt Punkte für gutes Verhalten
   ↓
3. Kind sieht Punkte in der App
   ↓
4. Kind löst Belohnung ein
   ↓
5. Admin genehmigt Belohnung
   ↓
6. Punkte werden automatisch abgezogen
```

## 🔑 Standard-Einstellungen

- **Wochenziel**: 100 Punkte
- **Startpunkte**: 0 Punkte
- **Admin-Email-Format**: `username@fairpoint.internal`

## 📊 Firebase Collections

Die App nutzt diese Firestore Collections:

| Collection | Beschreibung |
|------------|--------------|
| `users` | Alle Benutzer (Admin & Kinder) |
| `transactions` | Alle Punktebewegungen |
| `rewards` | Verfügbare Belohnungen |
| `rewardRequests` | Einlöseanfragen |

## 🛠️ Entwicklungsmodus

Für Entwicklung ohne Firebase:

```bash
# Hot Reload während Entwicklung
flutter run --debug

# Performance profiling
flutter run --profile

# Release Build testen
flutter run --release
```

## 📦 Build für Produktion

### Android APK
```bash
flutter build apk --release
# Datei: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (für Play Store)
```bash
flutter build appbundle --release
# Datei: build/app/outputs/bundle/release/app-release.aab
```

### iOS (auf macOS)
```bash
flutter build ios --release
```

### iOS (auf Windows)
```bash
# Nutze GitHub Actions oder Codemagic
.\build.bat
# Wähle Option 4: "iOS zu GitHub pushen"
# Detaillierte Anleitung: IOS_BUILD_GUIDE.md
```

## ⚙️ Konfiguration anpassen

### App-Name ändern
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

### App-Icon ändern
```bash
# Icon in assets/icon/icon.png platzieren
flutter pub add flutter_launcher_icons
flutter pub run flutter_launcher_icons
```

### Theme-Farben ändern
In `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4), // Hier ändern
),
```

## 🐛 Häufige Probleme

### App startet nicht
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Fehler
- Prüfe `google-services.json` (Android)
- Prüfe `GoogleService-Info.plist` (iOS)
- Führe `flutterfire configure` erneut aus

### Gradle Fehler (Android)
```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Pods Fehler (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

## 📚 Nächste Schritte

1. ✅ Lies [README.md](README.md) für vollständige Dokumentation
2. ✅ Siehe [FIREBASE_SETUP.md](FIREBASE_SETUP.md) für Firebase-Konfiguration
3. ✅ Passe Belohnungen und Punktesystem an deine Bedürfnisse an
4. ✅ Teste das System mit echten Nutzern

## 💡 Tipps

- **Backup**: Exportiere regelmäßig Firestore-Daten
- **Testing**: Teste mit mehreren Kinderkonten
- **Sicherheit**: Ändere Admin-Passwort nach erstem Login
- **Updates**: Halte Flutter und Dependencies aktuell

## 🆘 Support

Bei Problemen:
1. Prüfe die Konsole auf Fehlermeldungen
2. Schaue in `FIREBASE_SETUP.md` für Firebase-spezifische Probleme
3. Führe `flutter doctor` aus für System-Probleme

---

**Viel Erfolg mit FairPoint!** 🌟
