# 🚀 Android SDK Schnellstart für Windows

## Dein aktuelles Problem
```
[X] Android toolchain - develop for Android devices
    X Unable to locate Android SDK.
```

## ✅ Schnellste Lösung (Empfohlen)

### Schritt 1: Android Studio installieren

1. **Download Android Studio:**
   - Gehe zu: https://developer.android.com/studio
   - Lade die .exe-Datei herunter
   - Installiere nach: `C:\Program Files\Android\Android Studio`

2. **Erstmaliger Start:**
   - Starte Android Studio
   - Wähle **"Standard"** Installation
   - Lade **alles** herunter, was der Wizard vorschlägt
   - Warte, bis alle Downloads abgeschlossen sind (~2-5 GB)

### Schritt 2: SDK Komponenten verifizieren

1. In Android Studio:
   - Öffne `Tools` → `SDK Manager`
   - Unter **"SDK Platforms"** stelle sicher, dass installiert ist:
     - ✅ Android 14.0 (API 34)
     - ✅ Android 13.0 (API 33)
   
   - Unter **"SDK Tools"** stelle sicher, dass installiert ist:
     - ✅ Android SDK Build-Tools
     - ✅ Android SDK Command-line Tools (latest)
     - ✅ Android SDK Platform-Tools
     - ✅ Android Emulator

### Schritt 3: ANDROID_HOME Umgebungsvariable setzen

**Öffne PowerShell als Administrator** (Rechtsklick → "Als Administrator ausführen"):

```powershell
# Setze ANDROID_HOME
$androidSdk = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdk, "User")

# Füge SDK-Tools zum PATH hinzu
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$androidSdk\platform-tools;$androidSdk\tools;$androidSdk\cmdline-tools\latest\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

Write-Host "✅ ANDROID_HOME gesetzt!" -ForegroundColor Green
Write-Host "⚠️  WICHTIG: Schließe ALLE PowerShell-Fenster und öffne ein neues!" -ForegroundColor Yellow
```

### Schritt 4: Verifizieren (in NEUER PowerShell)

**Schließe alle PowerShell-Fenster und öffne eine NEUE PowerShell:**

```powershell
# Prüfe ANDROID_HOME
echo $env:ANDROID_HOME
# Erwartete Ausgabe: C:\Users\<DeinName>\AppData\Local\Android\Sdk

# Prüfe ADB
adb version
# Sollte Version anzeigen

# Prüfe Flutter
flutter doctor
```

### Schritt 5: Android Lizenzen akzeptieren

```powershell
flutter doctor --android-licenses
```

Drücke **'y'** für alle Lizenzen (ca. 5-7 Mal).

### Schritt 6: APK bauen

```powershell
cd C:\Users\ByteCodes_\Desktop\BONUSSYSTEMAPP
flutter clean
flutter pub get
flutter build apk --release
```

---

## 🔍 Überprüfung des SDK-Pfads

Falls du nicht sicher bist, wo dein Android SDK installiert ist:

```powershell
# Typische Pfade:
# 1. C:\Users\<Username>\AppData\Local\Android\Sdk  ← Standard
# 2. C:\Android\Sdk
# 3. C:\Program Files\Android\Sdk

# Prüfe, ob der Pfad existiert:
Test-Path "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
```

Falls der Standard-Pfad nicht existiert:
- Öffne Android Studio
- Gehe zu `Tools` → `SDK Manager`
- Oben siehst du den **Android SDK Location**
- Kopiere diesen Pfad und verwende ihn statt des Standard-Pfads

---

## 🚨 Häufige Fehler

### Fehler: "flutter doctor" zeigt immer noch Android SDK Fehler

**Lösung:**
```powershell
# 1. PowerShell NEU öffnen (wichtig!)
# 2. Verifizieren:
echo $env:ANDROID_HOME

# Wenn leer, wiederhole Schritt 3 und STARTE PowerShell NEU!
```

### Fehler: "adb not found"

**Lösung:**
```powershell
# Stelle sicher, dass platform-tools im PATH ist
$androidSdk = $env:ANDROID_HOME
[Environment]::SetEnvironmentVariable("Path", 
    "$env:PATH;$androidSdk\platform-tools", "User")

# PowerShell NEU starten!
```

### Fehler: "Unable to run 'flutter doctor --android-licenses'"

**Lösung:**
```powershell
# Command-line Tools fehlen
# In Android Studio:
# Tools → SDK Manager → SDK Tools → Android SDK Command-line Tools (latest)
# Installieren!
```

---

## 📊 Erwartetes Ergebnis nach Setup

```powershell
PS C:\> flutter doctor

[√] Flutter (Channel stable, 3.35.3, on Microsoft Windows)
[√] Windows Version (Windows 11 or higher)
[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)  ← Sollte grün sein!
[√] Chrome - develop for the web
[√] IntelliJ IDEA Community Edition (version 2025.2)
[√] VS Code (version 1.105.1)
[√] Connected device (2 available)
[√] Network resources

• No issues found!
```

---

## 🎯 Nächste Schritte nach erfolgreicher Installation

1. **APK bauen:**
   ```powershell
   flutter build apk --release
   ```

2. **App auf Gerät installieren:**
   ```powershell
   # Gerät per USB verbinden
   adb devices
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

3. **App Bundle für Play Store bauen:**
   ```powershell
   flutter build appbundle --release
   ```

---

## 💡 Tipp: Android Emulator verwenden

Falls du kein physisches Gerät hast:

1. In Android Studio: `Tools` → `Device Manager`
2. Klicke auf **"Create Device"**
3. Wähle z.B. **"Pixel 7 Pro"**
4. Lade ein System Image herunter (z.B. Android 13)
5. Starte den Emulator
6. In PowerShell:
   ```powershell
   flutter devices
   flutter run
   ```

---

**Bei weiteren Problemen, siehe vollständiges [BUILD_GUIDE.md](BUILD_GUIDE.md)**
