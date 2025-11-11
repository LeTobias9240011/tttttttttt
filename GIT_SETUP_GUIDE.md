# 🔧 Git & GitHub Setup für FairPoint

Komplette Anleitung zur Einrichtung von Git und GitHub für iOS-Builds.

---

## 📋 Voraussetzungen

### 1. Git installieren

**Windows:**
```powershell
# Download von: https://git-scm.com/download/win
# Installiere Git für Windows
# Wähle "Git Bash" und "Git GUI" während Installation
```

**Verifizieren:**
```bash
git --version
# Sollte ausgeben: git version 2.x.x
```

### 2. Git konfigurieren

```bash
# Setze deinen Namen
git config --global user.name "Dein Name"

# Setze deine Email
git config --global user.email "deine@email.com"

# Prüfe Konfiguration
git config --list
```

### 3. GitHub Account erstellen

1. Gehe zu [github.com](https://github.com)
2. Registriere dich (kostenlos)
3. Verifiziere deine Email-Adresse

---

## 🚀 Schnellstart mit Build-Script

### Option A: Automatisches Setup (EMPFOHLEN)

```bash
# 1. Führe Build-Script aus
.\build.bat

# 2. Wähle Option [7]
[7] Git Repository einrichten

# 3. Folge den Anweisungen
# - Git wird initialisiert
# - .gitignore wird erstellt
# - Initial Commit wird gemacht
# - GitHub Remote wird konfiguriert

# 4. Gib deine Repository URL ein
GitHub Repository URL: https://github.com/username/fairpoint-app.git

# 5. Bestätige den Push
Push durchfuehren? (j/n): j

# 6. Fertig!
```

---

## 📝 Manuelles Setup

### Schritt 1: GitHub Repository erstellen

1. Gehe zu [github.com/new](https://github.com/new)
2. Repository Name: `fairpoint-app` (oder beliebig)
3. Beschreibung: `FairPoint - Digitales Punktesystem`
4. **Wichtig:** Wähle **Private** oder **Public**
5. **NICHT** initialisieren mit README/License/gitignore
6. Klicke "Create repository"

### Schritt 2: Lokales Repository initialisieren

```bash
# Im Projekt-Verzeichnis
cd C:\Users\ByteCodes_\Desktop\BONUSSYSTEMAPP

# Git initialisieren
git init

# Haupt-Branch erstellen
git branch -M main
```

### Schritt 3: .gitignore erstellen

Erstelle `.gitignore` im Projekt-Root:

```gitignore
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.log

# Android
android/.gradle/
android/.idea/
android/local.properties
android/key.properties
android/*.iml
android/captures/
android/gradlew
android/gradlew.bat
android/gradle/

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
ios/Runner/GeneratedPluginRegistrant.*

# IDE
.idea/
.vscode/
*.swp
*.swo
*~
.DS_Store

# Secrets
*.jks
*.keystore
*.p12
*.mobileprovision
**/google-services.json
**/GoogleService-Info.plist
firebase_app_id_file.json
```

### Schritt 4: Initial Commit

```bash
# Alle Dateien hinzufügen
git add .

# Status prüfen
git status

# Commit erstellen
git commit -m "Initial commit - FairPoint App"
```

### Schritt 5: Mit GitHub verbinden

```bash
# Remote hinzufügen (ersetze USERNAME und REPO)
git remote add origin https://github.com/USERNAME/fairpoint-app.git

# Zu GitHub pushen
git push -u origin main
```

---

## 🔐 GitHub Authentication

### Option A: Personal Access Token (EMPFOHLEN)

**Erstellen:**
1. Gehe zu GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. "Generate new token (classic)"
4. Name: `FairPoint Build`
5. Scopes auswählen:
   - ✅ `repo` (alle)
   - ✅ `workflow`
6. "Generate token"
7. **WICHTIG:** Kopiere den Token sofort!

**Verwenden:**
```bash
# Beim ersten Push wirst du nach Credentials gefragt
Username: dein-github-username
Password: <DEIN_PERSONAL_ACCESS_TOKEN>

# Windows speichert dies im Credential Manager
```

### Option B: SSH Key

**SSH Key erstellen:**
```bash
# Generiere SSH Key
ssh-keygen -t ed25519 -C "deine@email.com"

# Speichere in: C:\Users\DEIN_NAME\.ssh\id_ed25519
# Passwort optional

# Public Key anzeigen
cat ~/.ssh/id_ed25519.pub
```

**Zu GitHub hinzufügen:**
1. Gehe zu GitHub → Settings → SSH and GPG keys
2. "New SSH key"
3. Füge den Public Key ein
4. "Add SSH key"

**Remote URL ändern:**
```bash
# Entferne HTTPS Remote
git remote remove origin

# Füge SSH Remote hinzu
git remote add origin git@github.com:USERNAME/fairpoint-app.git

# Push
git push -u origin main
```

---

## 🔄 Workflow nach Setup

### Tägliche Arbeit

```bash
# Änderungen ansehen
git status

# Dateien hinzufügen
git add .

# Commit erstellen
git commit -m "Beschreibung der Änderung"

# Zu GitHub pushen
git push
```

### iOS Build auslösen

```bash
# Mit Build-Script
.\build.bat
# Wähle [4] iOS zu GitHub pushen

# Oder manuell
git add .
git commit -m "iOS Build mit neuen Features"
git push
```

**GitHub Actions startet automatisch!**

---

## 🐛 Troubleshooting

### Problem: "fatal: not a git repository"

**Ursache:** Git nicht initialisiert.

**Lösung:**
```bash
# Im Projekt-Verzeichnis
git init
git branch -M main
```

### Problem: "fatal: remote origin already exists"

**Ursache:** Remote bereits konfiguriert.

**Lösung:**
```bash
# Entferne altes Remote
git remote remove origin

# Füge neues hinzu
git remote add origin https://github.com/USERNAME/REPO.git
```

### Problem: "Permission denied (publickey)" oder "Authentication failed"

**Ursache:** Keine oder falsche Credentials.

**Lösung 1 - Personal Access Token:**
```bash
# Erstelle neues Token auf GitHub
# Setze Remote neu mit Token
git remote set-url origin https://<TOKEN>@github.com/USERNAME/REPO.git
```

**Lösung 2 - SSH Key:**
```bash
# Erstelle SSH Key (siehe oben)
# Füge zu GitHub hinzu
# Ändere Remote URL
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### Problem: "Updates were rejected because the remote contains work"

**Ursache:** Remote-Repository hat Änderungen, die lokal nicht vorhanden sind.

**Lösung:**
```bash
# Pull mit Rebase
git pull --rebase origin main

# Oder Force Push (VORSICHT!)
git push -f origin main
```

### Problem: "failed to push some refs"

**Ursache:** Lokaler Branch ist nicht up-to-date.

**Lösung:**
```bash
# Hole Änderungen
git pull origin main

# Löse eventuelle Konflikte
# Dann erneut pushen
git push origin main
```

### Problem: Build-Script findet Git nicht

**Ursache:** Git nicht im PATH.

**Lösung:**
```powershell
# PowerShell als Administrator
# Füge Git zum PATH hinzu
$env:Path += ";C:\Program Files\Git\bin"

# Permanent setzen
[Environment]::SetEnvironmentVariable("Path", 
    $env:Path + ";C:\Program Files\Git\bin", 
    "Machine")

# PowerShell neu starten
```

---

## 📊 Repository-Struktur

Dein GitHub Repository sollte so aussehen:

```
fairpoint-app/
├── .github/
│   └── workflows/
│       └── build-ios.yml          ← iOS Build Workflow
├── android/                       ← Android-spezifische Dateien
├── ios/                           ← iOS-spezifische Dateien
├── lib/                           ← Flutter Dart Code
├── .gitignore                     ← Git Ignore Regeln
├── pubspec.yaml                   ← Flutter Dependencies
├── README.md                      ← Projekt-Dokumentation
├── build.bat                      ← Build Script
└── ...
```

---

## 🎯 Best Practices

### Commit Messages

**Gut:**
```bash
git commit -m "Füge Belohnungssystem hinzu"
git commit -m "Fixe iOS Build Fehler mit Pods"
git commit -m "Update Flutter zu 3.24.0"
```

**Schlecht:**
```bash
git commit -m "update"
git commit -m "fix"
git commit -m "asdf"
```

### Branch-Strategie

```bash
# Haupt-Branch für Production
main

# Entwicklungs-Branch
git checkout -b development

# Feature-Branch
git checkout -b feature/neue-funktion

# Merge zurück zu main
git checkout main
git merge feature/neue-funktion
```

### .gitignore Regeln

**Niemals committen:**
- ❌ API Keys / Secrets
- ❌ Build-Artefakte (`build/`)
- ❌ Keystores / Certificates
- ❌ IDE-Konfiguration

**Immer committen:**
- ✅ Source Code (`lib/`)
- ✅ Konfigurationsdateien (`pubspec.yaml`)
- ✅ Workflows (`.github/workflows/`)
- ✅ Dokumentation (`README.md`)

---

## 🔒 Sicherheit

### Secrets aus Git History entfernen

Wenn du versehentlich Secrets committed hast:

```bash
# BFG Repo-Cleaner herunterladen
# https://rtyley.github.io/bfg-repo-cleaner/

# Secrets entfernen
java -jar bfg.jar --delete-files google-services.json

# Git Cleanup
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force Push (überschreibt History!)
git push --force
```

**Besser:** Secrets rotieren (neue API Keys generieren).

---

## ✅ Checkliste vor GitHub Actions

Vor dem ersten iOS Build:

- [ ] Git installiert und konfiguriert
- [ ] GitHub Account erstellt
- [ ] Repository auf GitHub erstellt
- [ ] Lokales Repo mit GitHub verbunden
- [ ] `.gitignore` konfiguriert
- [ ] Initial Commit gemacht
- [ ] Push erfolgreich
- [ ] Workflow-Datei vorhanden (`.github/workflows/build-ios.yml`)

---

## 📚 Weiterführende Links

- **Git Documentation**: [git-scm.com/doc](https://git-scm.com/doc)
- **GitHub Guides**: [guides.github.com](https://guides.github.com)
- **GitHub Actions**: [docs.github.com/actions](https://docs.github.com/actions)
- **Git Cheat Sheet**: [education.github.com/git-cheat-sheet-education.pdf](https://education.github.com/git-cheat-sheet-education.pdf)

---

## 🆘 Weitere Hilfe

Bei Problemen:

1. Prüfe `git status` und `git remote -v`
2. Schaue in die Fehlermeldung
3. Google die Fehlermeldung
4. Prüfe GitHub Actions Logs

---

**Viel Erfolg mit Git und GitHub!** 🚀
