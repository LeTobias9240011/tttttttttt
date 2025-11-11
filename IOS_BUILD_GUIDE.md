# iOS Build Guide - Windows Edition

Da Apple's iOS-Apps nur auf macOS kompiliert werden können, gibt es für Windows-Nutzer mehrere Lösungen:

## Option 1: GitHub Actions (KOSTENLOS) ✅ **EMPFOHLEN**

GitHub Actions stellt kostenlos macOS-Runner zur Verfügung.

### Setup:
1. Pushe dein Projekt zu GitHub
2. Die Datei `.github/workflows/build-ios.yml` ist bereits erstellt
3. Gehe zu GitHub → Repository → Actions
4. Der Workflow startet automatisch bei jedem Push
5. Lade die fertige IPA-Datei unter "Artifacts" herunter

**Vorteile:**
- ✅ Komplett kostenlos (2000 Minuten/Monat für private Repos)
- ✅ Keine Konfiguration nötig
- ✅ Automatisch bei jedem Push
- ⚠️ Build ohne Code-Signierung (nur zum Testen)

---

## Option 2: Codemagic (KOSTENLOS für 500 Min/Monat)

Codemagic ist ein CI/CD-Service speziell für Flutter.

### Setup:
1. Gehe zu [codemagic.io](https://codemagic.io)
2. Melde dich mit GitHub an
3. Wähle dein Repository
4. Die `codemagic.yaml` ist bereits konfiguriert
5. Starte den Build

**Vorteile:**
- ✅ 500 Build-Minuten kostenlos
- ✅ Code-Signierung möglich
- ✅ Direkt zu TestFlight/App Store
- ✅ Einfache Konfiguration

### Code-Signierung für iOS (benötigt Apple Developer Account):
```bash
# In Codemagic UI:
1. Settings → Code signing identities
2. Upload dein Provisioning Profile
3. Upload dein Certificate (.p12)
4. Konfiguriere Bundle ID: com.fairpoint.app
```

---

## Option 3: Remote Mac (z.B. MacStadium)

Miete einen Mac in der Cloud.

### Anbieter:
- **MacStadium**: ab $99/Monat
- **AWS EC2 Mac**: ab $1.08/Stunde
- **MacinCloud**: ab $30/Monat

**Vorteile:**
- ✅ Volle Kontrolle
- ✅ Xcode verfügbar
- ❌ Kostenpflichtig

---

## Option 4: Lokaler Mac (Freund/Familie)

Wenn du Zugang zu einem Mac hast:

### Build-Befehle:
```bash
# Terminal auf dem Mac
cd /path/to/BONUSSYSTEMAPP

# Dependencies installieren
flutter pub get
cd ios
pod install
cd ..

# iOS App bauen
flutter build ios --release

# Oder IPA erstellen
flutter build ipa --release
```

---

## Vergleich der Optionen

| Option | Kosten | Code-Signierung | Schwierigkeit | Empfehlung |
|--------|--------|----------------|---------------|------------|
| GitHub Actions | Kostenlos | ❌ Nein | ⭐ Einfach | ✅ Zum Testen |
| Codemagic | 500 Min Free | ✅ Ja | ⭐⭐ Mittel | ✅ Für Production |
| Remote Mac | Ab $30/Monat | ✅ Ja | ⭐⭐⭐ Komplex | Nur wenn nötig |
| Lokaler Mac | Kostenlos | ✅ Ja | ⭐ Einfach | ✅ Ideal |

---

## Code-Signierung für App Store (Apple Developer Account benötigt)

### Schritt 1: Apple Developer Account
1. Gehe zu [developer.apple.com](https://developer.apple.com)
2. Melde dich an (99€/Jahr)

### Schritt 2: App ID erstellen
1. Certificates, Identifiers & Profiles
2. Identifiers → App IDs
3. Erstelle: `com.fairpoint.app`

### Schritt 3: Distribution Certificate
1. Certificates → iOS Distribution
2. Lade CSR hoch
3. Lade Certificate herunter

### Schritt 4: Provisioning Profile
1. Profiles → Distribution
2. Wähle App ID: com.fairpoint.app
3. Lade Provisioning Profile herunter

### Schritt 5: In Codemagic hochladen
1. Settings → Code signing
2. Upload Certificate (.p12)
3. Upload Provisioning Profile
4. Bundle ID einstellen

---

## Schnellstart für GitHub Actions

```bash
# 1. Repository erstellen (falls noch nicht vorhanden)
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/DEIN_USERNAME/fairpoint-app.git
git push -u origin main

# 2. Zu GitHub gehen
# 3. Actions Tab → iOS Workflow
# 4. Warten (ca. 10-15 Minuten)
# 5. IPA unter Artifacts herunterladen
```

---

## FAQ

**Q: Kann ich die iOS-App ohne Mac testen?**
A: Ja! Mit GitHub Actions kannst du eine IPA erstellen und sie im iOS Simulator testen.

**Q: Brauche ich einen Apple Developer Account?**
A: Nur wenn du im App Store veröffentlichen willst. Zum Testen reicht GitHub Actions.

**Q: Wie installiere ich die IPA auf meinem iPhone?**
A: Mit Tools wie:
- **TestFlight** (benötigt Developer Account)
- **Diawi** (kostenlos, aber max. 100 MB)
- **AltStore** (für persönliche Geräte)

**Q: Ist die Android-Version identisch?**
A: Ja! Flutter kompiliert für beide Plattformen aus dem gleichen Code.

---

## Support

Bei Fragen:
1. Prüfe die GitHub Actions Logs
2. Prüfe `flutter doctor` Output
3. Stelle sicher, dass Firebase korrekt konfiguriert ist
4. Kontrolliere die `ios/Runner/Info.plist`

---

## Nächste Schritte

1. ✅ Pushe zu GitHub
2. ✅ Warte auf den ersten Build
3. ✅ Lade IPA herunter
4. ✅ Teste die App
5. 🚀 Veröffentliche im App Store (mit Codemagic + Developer Account)
