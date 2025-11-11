# 🔥 Firebase Setup Guide für FairPoint

Diese Anleitung führt dich Schritt für Schritt durch die Firebase-Konfiguration.

## 📋 Voraussetzungen

- Google-Konto
- Flutter SDK installiert
- Node.js installiert (für Firebase CLI)

## Schritt 1: Firebase Projekt erstellen

1. Gehe zu [Firebase Console](https://console.firebase.google.com/)
2. Klicke auf "Projekt hinzufügen"
3. Gib einen Projektnamen ein (z.B. "FairPoint")
4. Google Analytics kannst du optional aktivieren
5. Klicke auf "Projekt erstellen"

## Schritt 2: Firebase CLI installieren

```bash
npm install -g firebase-tools
```

Login:
```bash
firebase login
```

## Schritt 3: FlutterFire CLI installieren

```bash
dart pub global activate flutterfire_cli
```

## Schritt 4: Firebase für Flutter konfigurieren

Im Projektverzeichnis:

```bash
flutterfire configure
```

Wähle:
- Dein Firebase Projekt
- Die Plattformen: Android, iOS (optional: Web)

Dies erstellt automatisch:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Schritt 5: Authentication aktivieren

1. In der Firebase Console → **Authentication**
2. Klicke auf "Get Started"
3. Wähle **Email/Password** als Sign-in method
4. Aktiviere "Email/Password"
5. Speichern

## Schritt 6: Firestore Database erstellen

1. In der Firebase Console → **Firestore Database**
2. Klicke auf "Create database"
3. Wähle **Start in production mode**
4. Wähle eine Location (europe-west3 für Deutschland)
5. Klicke auf "Enable"

## Schritt 7: Firestore Security Rules setzen

1. Gehe zu **Firestore Database** → **Rules**
2. Ersetze die Rules mit folgendem Code:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Users collection
    match /users/{userId} {
      // Anyone authenticated can read user documents
      allow read: if isAuthenticated();
      
      // Users can update their own document, admins can update any
      allow write: if isAuthenticated() && (request.auth.uid == userId || isAdmin());
      
      // Only admins can create new users
      allow create: if isAdmin();
    }
    
    // Transactions collection - read by all, write by admin only
    match /transactions/{transactionId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin();
      allow update, delete: if false; // Transactions are immutable
    }
    
    // Rewards collection
    match /rewards/{rewardId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Reward Requests collection
    match /rewardRequests/{requestId} {
      allow read: if isAuthenticated();
      
      // Users can create requests for themselves
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      
      // Only admins can update/approve requests
      allow update: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // Feedback collection (optional)
    match /feedback/{feedbackId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if isAdmin();
    }
  }
}
```

3. Klicke auf **"Publish"**

## Schritt 8: Ersten Admin-Benutzer erstellen

### Variante A: Über Firebase Console (Empfohlen)

1. Gehe zu **Authentication** → **Users**
2. Klicke auf **"Add user"**
3. Email: `admin@fairpoint.internal`
4. Passwort: [Wähle ein sicheres Passwort]
5. Klicke auf **"Add user"**
6. **Kopiere die User UID** (wichtig!)

7. Gehe zu **Firestore Database**
8. Klicke auf **"Start collection"**
9. Collection ID: `users`
10. Document ID: [Füge die User UID ein]
11. Füge folgende Felder hinzu:

| Field | Type | Value |
|-------|------|-------|
| username | string | admin |
| displayName | string | Administrator |
| isAdmin | boolean | true |
| currentPoints | number | 0 |
| weeklyGoal | number | 100 |
| createdAt | timestamp | [jetzt] |
| lastReset | timestamp | [leer lassen] |

12. Klicke auf **"Save"**

### Variante B: Über die App (nach erstem Start)

Wenn du die App startest, kannst du auch einen temporären Admin erstellen:

1. In `lib/providers/auth_provider.dart` kannst du temporär die `createChildAccount` Methode nutzen
2. Nach dem ersten Admin-Login, setze in Firestore `isAdmin: true`

## Schritt 9: Erste Belohnungen erstellen

1. In **Firestore Database**
2. Erstelle eine neue Collection: `rewards`
3. Füge Dokumente hinzu:

### Belohnung 1:
```
Document ID: [Auto-ID]
title: "Snack oder kleine Aktivität"
description: "Wähle einen Snack oder eine kleine Aktivität"
pointsCost: 20
isActive: true
sortOrder: 1
createdAt: [timestamp - jetzt]
```

### Belohnung 2:
```
Document ID: [Auto-ID]
title: "Gruppenaktivität"
description: "Teilnahme an einer Gruppenaktivität"
pointsCost: 40
isActive: true
sortOrder: 2
createdAt: [timestamp - jetzt]
```

### Belohnung 3:
```
Document ID: [Auto-ID]
title: "Großes Event"
description: "Ausflug oder besonderes Event"
pointsCost: 80
isActive: true
sortOrder: 3
createdAt: [timestamp - jetzt]
```

## Schritt 10: Indices erstellen (Optional)

Für bessere Performance, erstelle Indices:

1. Gehe zu **Firestore Database** → **Indexes**
2. Erstelle folgende Composite Indexes:

### Index 1: Transactions by User
- Collection: `transactions`
- Fields: `userId` (Ascending), `timestamp` (Descending)

### Index 2: Reward Requests by Status
- Collection: `rewardRequests`
- Fields: `status` (Ascending), `requestedAt` (Descending)

**Hinweis**: Flutter zeigt im Debug-Log automatisch Links zu benötigten Indices an!

## ✅ Fertig!

Deine Firebase-Konfiguration ist abgeschlossen. Du kannst jetzt:

1. Die App starten: `flutter run`
2. Dich mit dem Admin-Konto anmelden
3. Kindkonten erstellen
4. Punkte vergeben
5. Das System nutzen!

## 🔧 Troubleshooting

### "No Firebase App has been created"
- Stelle sicher, dass `firebase_options.dart` existiert
- Führe `flutterfire configure` erneut aus

### "Permission denied" Fehler
- Prüfe die Firestore Security Rules
- Stelle sicher, dass der User in der `users` Collection existiert

### "User not found"
- Prüfe, ob die UID in Authentication mit der Document ID in Firestore übereinstimmt
- Stelle sicher, dass `isAdmin` auf `true` gesetzt ist

### Android Build Fehler
- Stelle sicher, dass `google-services.json` in `android/app/` liegt
- Sync Gradle files

### iOS Build Fehler
- Stelle sicher, dass `GoogleService-Info.plist` in `ios/Runner/` liegt
- Führe `pod install` im `ios/` Verzeichnis aus

## 📚 Weitere Ressourcen

- [Firebase Dokumentation](https://firebase.google.com/docs)
- [FlutterFire Dokumentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

---

Bei weiteren Fragen, siehe README.md oder die offizielle Dokumentation.
