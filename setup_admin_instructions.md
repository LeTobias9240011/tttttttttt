# 🔧 Admin-Konto einrichten - Anleitung

## Deine Situation
Du hast bereits einen Firebase Auth Benutzer mit der Email: `cahatobias@protonmail.com`

## ✅ Schnelle Lösung: Mit Email anmelden

Die App unterstützt jetzt direkt die Anmeldung mit Email:

**Benutzername**: `cahatobias@protonmail.com`  
**Passwort**: Dein Firebase-Passwort

### Wichtig: Firestore-Dokument prüfen

Stelle sicher, dass in **Firestore Database** → **users** Collection ein Dokument existiert mit:
- **Document ID**: Die UID von deinem Firebase Auth User (z.B. `L3puFSUk810OzxF0AG92DgvChiA93`)
- **Felder**: Siehe Screenshot - muss `isAdmin: true` enthalten

---

## Alternative: Admin-Konto mit internem Format erstellen

### Schritt 1: Gehe zur Firebase Console
1. Öffne: https://console.firebase.google.com/
2. Wähle dein Projekt "FairPoint" aus

### Schritt 2: Benutzer in Authentication erstellen

1. Klicke im Menü auf **"Authentication"**
2. Klicke auf **"Users"** Tab
3. Klicke auf **"Add user"** Button
4. Gib ein:
   - **Email**: `admin@fairpoint.internal`
   - **Password**: Wähle ein sicheres Passwort (z.B. `Admin1234!`)
   - ⚠️ **WICHTIG**: Merke dir dieses Passwort!
5. Klicke auf **"Add user"**
6. **Kopiere die UID** des erstellten Benutzers (z.B. `abc123xyz...`)

### Schritt 3: Firestore-Dokument erstellen

1. Klicke im Menü auf **"Firestore Database"**
2. Falls noch keine Collection existiert:
   - Klicke auf **"Start collection"**
   - Collection ID: `users`
   - Klicke auf **"Next"**

3. Document erstellen:
   - **Document ID**: Füge die kopierte UID aus Schritt 2 ein
   - Klicke auf **"Add field"** und füge folgende Felder hinzu:

| Field Name      | Field Type | Value             |
|-----------------|------------|-------------------|
| username        | string     | admin             |
| displayName     | string     | Administrator     |
| isAdmin         | boolean    | true              |
| currentPoints   | number     | 0                 |
| weeklyGoal      | number     | 100               |
| createdAt       | timestamp  | [klicke "Add"]    |

4. Klicke auf **"Save"**

### Schritt 4: In der App anmelden

1. Öffne die FairPoint App
2. Anmelden mit:
   - **Benutzername**: `admin`
   - **Passwort**: Das Passwort aus Schritt 2

## Häufige Fehler

### "The supplied auth credential is incorrect"
- Das Passwort stimmt nicht mit dem überein, das du in Firebase erstellt hast
- Gehe zu Firebase Authentication → Klicke auf den Benutzer → "Reset password"

### "Benutzername nicht gefunden"
- Das Firestore-Dokument fehlt oder die UID stimmt nicht überein
- Die UID in Firestore muss **EXAKT** die gleiche sein wie in Authentication

### "Permission denied"
- Firebase Security Rules fehlen oder sind falsch
- Kopiere die Rules aus `FIREBASE_SETUP.md` Schritt 7

## Alternative: Über Firebase CLI (Fortgeschritten)

Falls du die Firebase CLI nutzen möchtest, kannst du auch über Node.js ein Admin-Setup-Script erstellen.

---

**Nach erfolgreicher Anmeldung** kannst du dann weitere Kinderkonten über die App erstellen!
