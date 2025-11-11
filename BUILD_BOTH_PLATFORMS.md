# Build Android & iOS - Komplettanleitung

## 📱 Android Build (auf Windows)

### Voraussetzungen:
- ✅ Android SDK installiert
- ✅ Flutter installiert

### Build-Befehle:

```bash
# APK für Tests
flutter build apk --release

# APK-Datei Location:
# build/app/outputs/flutter-apk/app-release.apk

# AAB für Google Play Store
flutter build appbundle --release

# AAB-Datei Location:
# build/app/outputs/bundle/release/app-release.aab
```

### Installation:
```bash
# Auf Gerät installieren (USB Debug aktiviert)
flutter install

# Oder APK manuell auf Gerät kopieren und installieren
```

---

## 🍎 iOS Build (auf Windows mit GitHub Actions)

Da iOS-Builds nur auf macOS möglich sind, nutzen wir **GitHub Actions** (kostenlos):

### Schritt 1: Repository zu GitHub pushen

```bash
# Falls noch nicht initialisiert
git init
git add .
git commit -m "iOS build setup"

# GitHub Repository erstellen, dann:
git remote add origin https://github.com/DEIN_USERNAME/DEIN_REPO.git
git branch -M main
git push -u origin main
```

### Schritt 2: GitHub Actions aktivieren

1. Gehe zu deinem GitHub Repository
2. Tab "Actions" → Workflows
3. Der `Build iOS App` Workflow sollte automatisch starten
4. Warte ca. 10-15 Minuten

### Schritt 3: IPA herunterladen

1. Gehe zu Actions → Letzter erfolgreicher Build
2. Scrolle nach unten zu "Artifacts"
3. Lade `FairPoint-iOS.zip` herunter
4. Entpacke → `FairPoint.ipa`

### Schritt 4: Auf iPhone installieren (ohne Developer Account)

**Option A: AltStore (empfohlen)**
1. Installiere [AltStore](https://altstore.io/) auf deinem PC
2. Installiere AltStore auf deinem iPhone
3. Öffne AltStore auf dem iPhone
4. "+" → Wähle die IPA-Datei
5. App wird installiert

**Option B: Diawi (Online)**
1. Gehe zu [diawi.com](https://www.diawi.com/)
2. Lade die IPA hoch
3. Teile den Link mit deinem iPhone
4. Öffne Link auf iPhone → Installieren

**Option C: TestFlight (mit Developer Account)**
1. Braucht Apple Developer Account ($99/Jahr)
2. Siehe `IOS_BUILD_GUIDE.md`

---

## 🚀 Beide Plattformen gleichzeitig bauen

### Mit GitHub Actions:

Pushe einfach zu GitHub, beide Workflows laufen automatisch:

```bash
git add .
git commit -m "Build both platforms"
git push
```

**Ergebnisse:**
- Android APK: Nach ~5 Minuten
- iOS IPA: Nach ~15 Minuten

### Mit Codemagic (empfohlen für Production):

1. Gehe zu [codemagic.io](https://codemagic.io)
2. Verbinde GitHub Repository
3. Die `codemagic.yaml` ist bereits konfiguriert
4. Starte beide Workflows

**Vorteile:**
- ✅ Gleichzeitiges Bauen
- ✅ Code-Signierung
- ✅ Automatisches Publishing (App Store, Play Store)

---

## 📊 Build-Zeit Vergleich

| Plattform | Lokal (Windows) | GitHub Actions | Codemagic |
|-----------|-----------------|----------------|-----------|
| Android | 2-5 Min | 5-8 Min | 5-8 Min |
| iOS | ❌ Nicht möglich | 10-15 Min | 10-15 Min |

---

## 🔧 Troubleshooting

### Android Build Fehler

**Problem:** `AAPT: error: resource android:attr/lStar not found`
```bash
# Lösung: Update build.gradle
compileSdkVersion 34
```

**Problem:** `Execution failed for task ':app:processReleaseResources'`
```bash
# Lösung: Clean build
flutter clean
flutter pub get
flutter build apk --release
```

### iOS Build Fehler (GitHub Actions)

**Problem:** `Pod install failed`
```bash
# Lösung: Prüfe Podfile
# Bereits korrekt konfiguriert ✅
```

**Problem:** `Code signing error`
```bash
# Lösung: Build mit --no-codesign
flutter build ios --release --no-codesign
# Bereits in GitHub Actions konfiguriert ✅
```

---

## 📦 Dateigrößen

| Datei | Größe (ca.) | Zweck |
|-------|-------------|-------|
| app-release.apk | 40-60 MB | Android Installation |
| app-release.aab | 30-40 MB | Google Play Store |
| FairPoint.ipa | 50-70 MB | iOS Installation |

---

## 🎯 Empfohlener Workflow

### Für Entwicklung:
```bash
# Android: Lokal bauen (schnell)
flutter build apk --release

# iOS: GitHub Actions (automatisch bei Push)
git push
```

### Für Production:
```bash
# Beide Plattformen mit Codemagic
# Automatisch bei Push zu main branch

# Oder einzeln:
flutter build appbundle --release  # Google Play
# iOS über Codemagic mit Code-Signierung
```

---

## 🔑 Code-Signierung

### Android (für Play Store):

1. Keystore erstellen (bereits vorhanden in `android/app/`)
2. In `key.properties` konfigurieren
3. Build mit: `flutter build appbundle --release`

### iOS (für App Store):

**Benötigt:**
- Apple Developer Account ($99/Jahr)
- Distribution Certificate
- Provisioning Profile

**Setup über Codemagic:**
1. Settings → Code signing
2. Upload Certificate + Provisioning Profile
3. Build automatisch signiert

Siehe: `IOS_BUILD_GUIDE.md`

---

## ✅ Checkliste vor Release

### Android:
- [ ] Version in `pubspec.yaml` erhöhen
- [ ] `flutter build appbundle --release` erfolgreich
- [ ] Auf mehreren Geräten getestet
- [ ] Icons & Screenshots aktualisiert
- [ ] Play Store Listing vorbereitet

### iOS:
- [ ] Version in `pubspec.yaml` erhöhen
- [ ] GitHub Actions Build erfolgreich
- [ ] Auf iPhone getestet (via AltStore/TestFlight)
- [ ] Icons & Screenshots aktualisiert
- [ ] App Store Listing vorbereitet

---

## 📱 Versions-Management

```yaml
# pubspec.yaml
version: 1.0.0+1
#        │   │  └─ Build number (für Updates)
#        │   └──── Patch
#        └──────── Major.Minor

# Nächstes Update:
version: 1.0.1+2
```

Bei jedem Release beide Nummern erhöhen!

---

## 🌐 Publishing

### Google Play Store:
1. [Google Play Console](https://play.google.com/console)
2. Create App
3. Upload `app-release.aab`
4. Store Listing ausfüllen
5. Submit for Review

### Apple App Store:
1. [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → New App
3. Upload via Codemagic/Transporter
4. App Information ausfüllen
5. Submit for Review

---

## 💡 Tipps

1. **Nutze GitHub Actions für iOS** - Kostenlos und einfach
2. **Nutze AAB statt APK** - Kleinere Downloads im Play Store
3. **Teste beide Plattformen** - Auch wenn der Code gleich ist
4. **Automatisiere Builds** - Spart Zeit und verhindert Fehler
5. **Versionierung** - Immer erhöhen bei Updates

---

## 📚 Weiterführende Ressourcen

- [Flutter Deployment](https://docs.flutter.dev/deployment)
- [GitHub Actions for Flutter](https://github.com/marketplace/actions/flutter-action)
- [Codemagic Dokumentation](https://docs.codemagic.io/flutter/)
- [iOS Build Guide](./IOS_BUILD_GUIDE.md)

---

## 🆘 Support

Bei Problemen:
1. Prüfe `flutter doctor -v`
2. Prüfe GitHub Actions Logs
3. Siehe `IOS_BUILD_GUIDE.md` für iOS-spezifische Probleme
4. Clean build: `flutter clean && flutter pub get`
