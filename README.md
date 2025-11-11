# 📲 FairPoint – Das digitale Punktesystem

Eine moderne Android/iOS-App für Jugendeinrichtungen, die mithilfe eines klaren Punktesystems Motivation, Verantwortungsbewusstsein und soziale Kompetenzen fördert.

> **📚 Alle Anleitungen:** Siehe [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) für eine vollständige Übersicht aller Dokumentationen.

## 🌟 Hauptfunktionen

### 👥 Zwei Nutzerrollen

#### 🔐 Betreuer / Admin
- Zentrale Verwaltung aller Kinderkonten
- Punkte vergeben, abziehen oder zurücksetzen
- Neue Kinderkonten erstellen
- Belohnungsanfragen genehmigen oder ablehnen
- Vollständiger Transaktionsverlauf

#### 👦 Kinder / Jugendliche
- Eigenes Punktekonto mit Login
- Live-Punktestand und Fortschrittsanzeige
- Belohnungen einlösen
- Vollständiger Kontoauszug (Transaktionsverlauf)

### 💰 Kernfunktionen

- **Punktevergabe**: Admin kann Punkte für positives Verhalten vergeben
- **Punkteabzug**: Admin kann Punkte für Regelverstöße abziehen
- **Transparenz**: Alle Transaktionen werden protokolliert
- **Belohnungssystem**: Kinder können Punkte gegen Belohnungen eintauschen
- **Wochenziele**: 100 Punkte pro Woche als Standardziel
- **Fortschrittsvisualisierung**: Diagramme und Charts zeigen den Fortschritt

## 🛠️ Technologie-Stack

- **Framework**: Flutter (Android & iOS)
- **Backend**: Firebase
  - Authentication (Benutzerverwaltung)
  - Firestore (Datenbank)
  - Cloud Storage (optional für Bilder)
- **State Management**: Provider
- **UI**: Material 3 Design
- **Charts**: fl_chart
- **Fonts**: Google Fonts

## 🚀 Installation & Setup

### Voraussetzungen

1. **Flutter SDK** (3.0.0 oder höher)
   - Installation: https://flutter.dev/docs/get-started/install

2. **Firebase Projekt**
   - Erstelle ein Firebase Projekt: https://console.firebase.google.com/

3. **Firebase CLI** (optional, aber empfohlen)
   ```bash
   npm install -g firebase-tools
   ```

### Schritt 1: Repository klonen oder herunterladen

```bash
git clone <repository-url>
cd BONUSSYSTEMAPP
```

### Schritt 2: Dependencies installieren

```bash
flutter pub get
```

### Schritt 3: Firebase konfigurieren

#### Option A: Automatisch mit FlutterFire CLI (Empfohlen)

```bash
# FlutterFire CLI installieren
dart pub global activate flutterfire_cli

# Firebase konfigurieren
flutterfire configure
```

Folge den Anweisungen und wähle dein Firebase-Projekt aus.

#### Option B: Manuell

1. **Android Configuration**:
   - Lade `google-services.json` aus der Firebase Console herunter
   - Lege die Datei in `android/app/` ab

2. **iOS Configuration**:
   - Lade `GoogleService-Info.plist` aus der Firebase Console herunter
   - Lege die Datei in `ios/Runner/` ab

3. **Firebase Options aktualisieren**:
   - Öffne `lib/firebase_options.dart`
   - Ersetze die Platzhalter mit deinen Firebase-Konfigurationsdaten

### Schritt 4: Firebase Services aktivieren

In der Firebase Console:

1. **Authentication**
   - Gehe zu Authentication → Sign-in method
   - Aktiviere "Email/Password"

2. **Firestore Database**
   - Gehe zu Firestore Database
   - Erstelle eine Datenbank (Produktionsmodus)
   - Setze folgende Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId || 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Transactions collection
    match /transactions/{transactionId} {
      allow read: if request.auth != null;
      allow create: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Rewards collection
    match /rewards/{rewardId} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Reward Requests collection
    match /rewardRequests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Feedback collection
    match /feedback/{feedbackId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

### Schritt 5: Admin-Konto erstellen

Da das erste Konto ein Admin sein muss, erstelle es manuell:

1. Gehe zur Firebase Console → Authentication
2. Klicke auf "Add user"
3. Erstelle einen Benutzer (z.B. admin@fairpoint.internal)
4. Gehe zu Firestore Database
5. Erstelle manuell ein Dokument in der `users` Collection:

```json
{
  "username": "admin",
  "displayName": "Administrator",
  "isAdmin": true,
  "currentPoints": 0,
  "weeklyGoal": 100,
  "createdAt": [Timestamp: jetzt],
  "lastReset": null
}
```

**Wichtig**: Die Dokument-ID muss die UID des erstellten Benutzers sein!

### Schritt 6: Erste Belohnungen erstellen

Erstelle in Firestore Database → `rewards` Collection einige Beispiel-Belohnungen:

```json
{
  "title": "Snack oder kleine Aktivität",
  "description": "Wähle einen Snack oder eine kleine Aktivität",
  "pointsCost": 20,
  "isActive": true,
  "sortOrder": 1,
  "createdAt": [Timestamp: jetzt]
}
```

```json
{
  "title": "Gruppenaktivität",
  "description": "Teilnahme an einer Gruppenaktivität",
  "pointsCost": 40,
  "isActive": true,
  "sortOrder": 2,
  "createdAt": [Timestamp: jetzt]
}
```

```json
{
  "title": "Großes Event",
  "description": "Ausflug oder besonderes Event",
  "pointsCost": 80,
  "isActive": true,
  "sortOrder": 3,
  "createdAt": [Timestamp: jetzt]
}
```

### Schritt 7: App starten

```bash
# Für Android
flutter run

# Für iOS (nur auf macOS)
flutter run -d ios

# Für Web (Entwicklung)
flutter run -d chrome
```

### Schritt 8: iOS Build auf Windows

Da iOS-Apps nur auf macOS kompiliert werden können, gibt es für Windows-Nutzer mehrere Optionen:

**Option 1: GitHub Actions (KOSTENLOS) - Empfohlen**
- Pushe dein Projekt zu GitHub
- Der Workflow in `.github/workflows/build-ios.yml` baut automatisch die iOS-App
- Lade die fertige IPA-Datei als Artifact herunter

**Option 2: Codemagic (500 Min/Monat kostenlos)**
- Registriere dich auf [codemagic.io](https://codemagic.io)
- Verbinde dein Repository
- Die `codemagic.yaml` ist bereits konfiguriert

**Detaillierte Anleitung**: Siehe [IOS_BUILD_GUIDE.md](IOS_BUILD_GUIDE.md)  
**Schnellstart**: Siehe [IOS_QUICKSTART.md](IOS_QUICKSTART.md)

**Schnellstart mit build.bat:**
```bash
# Führe das Build-Script aus
.\build.bat

# Wähle Option 4: "iOS zu GitHub pushen"
# Die App wird automatisch auf GitHub Actions gebaut
```

## 📱 Verwendung

### Erste Anmeldung (Admin)

1. Starte die App
2. Melde dich mit deinem Admin-Konto an:
   - Benutzername: `admin`
   - Passwort: [dein gewähltes Passwort]

### Kindkonten erstellen

1. Im Admin-Dashboard auf das "+" Icon klicken
2. Benutzername, Anzeigename und Passwort eingeben
3. Konto erstellen

### Punkte vergeben/abziehen

1. Im Admin-Dashboard auf ein Kind klicken
2. "Punkte vergeben" oder "Punkte abziehen" wählen
3. Anzahl und Grund eingeben
4. Bestätigen

### Belohnungen einlösen (Kind)

1. Als Kind anmelden
2. Zum "Belohnungen"-Tab wechseln
3. Verfügbare Belohnung auswählen
4. Einlösen bestätigen
5. Warten auf Admin-Genehmigung

### Belohnungen genehmigen (Admin)

1. Im "Anfragen"-Tab werden alle offenen Anfragen angezeigt
2. Anfrage prüfen
3. Genehmigen oder Ablehnen

## 🔒 Sicherheit

- ✅ Rollenbasierte Authentifizierung (Admin vs. Kind)
- ✅ Firestore Security Rules verhindern unbefugten Zugriff
- ✅ Nur Admins können Punkte-Transaktionen durchführen
- ✅ Kinder können nicht untereinander interagieren
- ✅ Alle Änderungen werden protokolliert
- ✅ Passwörter werden sicher gespeichert (Firebase Auth)

## 📊 Firestore Datenstruktur

```
/users/{userId}
  - username: string
  - displayName: string
  - isAdmin: boolean
  - currentPoints: number
  - weeklyGoal: number
  - createdAt: timestamp
  - lastReset: timestamp

/transactions/{transactionId}
  - userId: string
  - userName: string
  - points: number
  - type: string (award|deduction|reset|rewardRedemption)
  - reason: string
  - adminId: string
  - adminName: string
  - timestamp: timestamp
  - rewardId: string (optional)

/rewards/{rewardId}
  - title: string
  - description: string
  - pointsCost: number
  - isActive: boolean
  - sortOrder: number
  - createdAt: timestamp

/rewardRequests/{requestId}
  - userId: string
  - userName: string
  - rewardId: string
  - rewardTitle: string
  - pointsCost: number
  - status: string (pending|approved|rejected)
  - requestedAt: timestamp
  - processedAt: timestamp
  - adminId: string
  - adminName: string
  - adminNote: string
```

## 🎨 Anpassungen

### Wochenziel ändern

In der Firestore Console kannst du das `weeklyGoal` für jeden Benutzer individuell anpassen.

### Belohnungen verwalten

1. Als Admin anmelden
2. Zum "Belohnungen"-Tab wechseln
3. Neue Belohnungen hinzufügen oder bestehende bearbeiten

### Design anpassen

Farben und Theme können in `lib/main.dart` angepasst werden:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4), // Deine Farbe hier
  brightness: Brightness.light,
),
```

## 🐛 Troubleshooting

### Firebase Connection Error

- Prüfe, ob `google-services.json` (Android) und `GoogleService-Info.plist` (iOS) vorhanden sind
- Stelle sicher, dass die Firebase-Konfiguration korrekt ist
- Führe `flutter clean` und `flutter pub get` aus

### Login funktioniert nicht

- Prüfe Firebase Authentication Console
- Stelle sicher, dass Email/Password Authentication aktiviert ist
- Prüfe, ob der Benutzer in der Users-Collection existiert

### Punkte werden nicht angezeigt

- Aktualisiere die App (Pull-to-Refresh)
- Prüfe Firestore Security Rules
- Prüfe die Console auf Fehler

## 📝 Zukünftige Features

- [ ] Push-Benachrichtigungen bei Punktevergabe
- [ ] Wöchentliche PDF-Berichte
- [ ] Statistiken und Diagramme (Trends)
- [ ] Offline-Modus mit Synchronisation
- [ ] Wöchentliches Feedback-Formular
- [ ] Mehrsprachigkeit (Deutsch/Englisch)
- [ ] Export von Transaktionsdaten
- [ ] Admin Web-Dashboard

## 📄 Lizenz

Dieses Projekt ist für den internen Gebrauch in Jugendeinrichtungen gedacht.

## 👨‍💻 Support

Bei Fragen oder Problemen:
1. Prüfe die Troubleshooting-Sektion
2. Schaue in die Firebase Console für Logs
3. Prüfe die Flutter-Dokumentation: https://flutter.dev/docs

## 🎯 Entwickelt mit

- Flutter & Dart
- Firebase (Auth, Firestore)
- Material Design 3
- Provider für State Management
- FL Chart für Visualisierungen

---

**FairPoint** - Förderung durch Transparenz und Motivation 🌟
