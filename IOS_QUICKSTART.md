# 🍎 iOS Build - Schnellstart für Windows

**Wichtig:** iOS-Apps können nur auf macOS kompiliert werden. Aber keine Sorge - es gibt einfache Lösungen für Windows!

## ⚡ Schnellste Methode: GitHub Actions (3 Schritte)

### 1️⃣ Repository zu GitHub pushen

```bash
# Erstelle ein neues GitHub Repository
# Dann:
git init
git add .
git commit -m "Initial commit mit iOS-Konfiguration"
git branch -M main
git remote add origin https://github.com/DEIN_USERNAME/fairpoint-app.git
git push -u origin main
```

### 2️⃣ Build beobachten

```bash
# Gehe zu GitHub:
https://github.com/DEIN_USERNAME/fairpoint-app/actions

# Der iOS Workflow startet automatisch
# Dauer: ca. 10-15 Minuten
```

### 3️⃣ IPA herunterladen

```bash
# Nach erfolgreichem Build:
# 1. Klicke auf den erfolgreichen Workflow-Run
# 2. Scrolle nach unten zu "Artifacts"
# 3. Lade "FairPoint-iOS" herunter
# 4. Entpacke die ZIP-Datei
# 5. Die FairPoint.ipa ist fertig!
```

---

## 🚀 Mit Build-Script

Noch einfacher mit dem integrierten Script:

```bash
# 1. Führe das Script aus
.\build.bat

# 2. Wähle Option 4
[4] iOS zu GitHub pushen (automatischer Build)

# 3. Gib eine Commit-Message ein
Commit Message: iOS Build mit neuen Features

# 4. Fertig! Gehe zu GitHub Actions
```

---

## 📱 IPA auf iPhone installieren

### Option A: TestFlight (empfohlen)
- Benötigt Apple Developer Account (99€/Jahr)
- Upload über Xcode oder Codemagic
- Teile Beta-Link mit Testern

### Option B: Diawi (kostenlos)
```bash
# 1. Gehe zu https://www.diawi.com
# 2. Lade deine IPA-Datei hoch
# 3. Erhalte einen Link
# 4. Öffne den Link auf deinem iPhone
# 5. Installiere die App
```

### Option C: AltStore (für persönliche Geräte)
```bash
# 1. Installiere AltStore auf deinem PC
# 2. Verbinde dein iPhone
# 3. Installiere die IPA über AltStore
```

---

## ⚙️ Alternative: Codemagic (mit Code-Signierung)

Wenn du direkt für den App Store bauen willst:

### 1. Registrierung
```bash
# Gehe zu: https://codemagic.io
# Registriere dich mit GitHub
```

### 2. Repository verbinden
```bash
# 1. Klicke "Add application"
# 2. Wähle dein Repository
# 3. Die codemagic.yaml wird automatisch erkannt
```

### 3. Code-Signierung einrichten
```bash
# In Codemagic UI:
# 1. Settings → Code signing
# 2. Upload dein Apple Certificate (.p12)
# 3. Upload dein Provisioning Profile
# 4. Bundle ID: com.fairpoint.app
```

### 4. Build starten
```bash
# Klicke "Start new build"
# Warte ca. 15-20 Minuten
# Lade IPA herunter oder pushe zu TestFlight
```

---

## 🆘 Troubleshooting

### Build schlägt fehl
```bash
# Prüfe GitHub Actions Logs:
# 1. Gehe zu Actions Tab
# 2. Klicke auf fehlgeschlagenen Run
# 3. Prüfe die Logs für Fehler

# Häufige Probleme:
# - Firebase-Konfiguration fehlt
# - Podfile Fehler → Prüfe ios/Podfile
# - Flutter Version → Aktualisiere .github/workflows/build-ios.yml
```

### IPA installiert nicht
```bash
# Prüfe:
# 1. Ist die IPA für dein Gerät signiert?
# 2. Hast du das richtige Provisioning Profile?
# 3. Ist die App im Developer Portal registriert?

# Für Tests ohne Signierung:
# Nutze den iOS Simulator in Xcode
```

### GitHub Actions Limit erreicht
```bash
# Kostenlose Limits:
# - Public Repos: Unbegrenzt
# - Private Repos: 2000 Minuten/Monat

# Lösung:
# 1. Mache dein Repo public
# 2. Oder nutze Codemagic (500 Min/Monat)
# 3. Oder baue nur bei wichtigen Commits
```

---

## 📊 Build-Zeiten

| Methode | Durchschnittliche Zeit |
|---------|----------------------|
| GitHub Actions | 10-15 Minuten |
| Codemagic | 15-20 Minuten |
| Lokaler Mac | 5-10 Minuten |

---

## ✅ Checkliste vor dem Build

- [ ] Firebase für iOS konfiguriert (`ios/Runner/GoogleService-Info.plist`)
- [ ] Bundle ID in Xcode gesetzt
- [ ] App-Icon hinzugefügt
- [ ] Version in `pubspec.yaml` aktualisiert
- [ ] Pods installiert (`cd ios && pod install`)
- [ ] App läuft lokal (Android/Web)

---

## 🎯 Nächste Schritte

Nach erfolgreichem Build:

1. **Testen**
   - Installiere die IPA auf einem Test-Gerät
   - Prüfe alle Funktionen
   - Teste Firebase-Verbindung

2. **Beta-Testing**
   - Upload zu TestFlight
   - Lade Beta-Tester ein
   - Sammle Feedback

3. **App Store Submission**
   - Bereite Screenshots vor
   - Schreibe App-Beschreibung
   - Reiche zur Review ein

---

## 💡 Pro-Tipps

- **Automatische Builds**: GitHub Actions baut bei jedem Push automatisch
- **Branch-Strategie**: Nutze einen `release`-Branch für Production-Builds
- **Versionierung**: Erhöhe die Version in `pubspec.yaml` vor jedem Build
- **Caching**: GitHub Actions cached Dependencies → schnellere Builds
- **Logs**: Schaue immer in die Build-Logs bei Fehlern

---

## 📚 Weitere Ressourcen

- **Detaillierte Anleitung**: [IOS_BUILD_GUIDE.md](IOS_BUILD_GUIDE.md)
- **GitHub Actions Workflow**: [.github/workflows/build-ios.yml](.github/workflows/build-ios.yml)
- **Codemagic Config**: [codemagic.yaml](codemagic.yaml)
- **Haupt-Dokumentation**: [README.md](README.md)

---

**Viel Erfolg mit deinem iOS-Build!** 🚀
