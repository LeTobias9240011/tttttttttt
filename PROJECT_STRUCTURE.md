# 📁 FairPoint - Projektstruktur

Übersicht über die Ordnerstruktur und Organisation des Projekts.

## 📂 Hauptstruktur

```
BONUSSYSTEMAPP/
├── lib/                          # Haupt-Dart-Code
│   ├── main.dart                 # App-Einstiegspunkt
│   ├── firebase_options.dart     # Firebase-Konfiguration (generiert)
│   │
│   ├── models/                   # Datenmodelle
│   │   ├── user_model.dart       # Benutzer-Datenmodell
│   │   ├── transaction_model.dart # Transaktion-Datenmodell
│   │   ├── reward_model.dart     # Belohnungs-Datenmodell
│   │   └── feedback_model.dart   # Feedback-Datenmodell
│   │
│   ├── providers/                # State Management (Provider)
│   │   ├── auth_provider.dart    # Authentifizierung
│   │   ├── points_provider.dart  # Punkteverwaltung
│   │   └── rewards_provider.dart # Belohnungsverwaltung
│   │
│   ├── screens/                  # UI-Bildschirme
│   │   ├── splash_screen.dart    # Ladebildschirm
│   │   ├── login_screen.dart     # Login
│   │   │
│   │   ├── admin/                # Admin-Screens
│   │   │   ├── admin_dashboard.dart
│   │   │   ├── children_overview_screen.dart
│   │   │   ├── child_detail_screen.dart
│   │   │   ├── create_child_screen.dart
│   │   │   ├── pending_requests_screen.dart
│   │   │   └── manage_rewards_screen.dart
│   │   │
│   │   └── child/                # Kind-Screens
│   │       ├── child_dashboard.dart
│   │       ├── points_overview_screen.dart
│   │       ├── rewards_screen.dart
│   │       └── transaction_history_screen.dart
│   │
│   ├── widgets/                  # Wiederverwendbare Widgets
│   │   ├── custom_app_bar.dart
│   │   └── loading_overlay.dart
│   │
│   ├── services/                 # Business-Logik-Services
│   │   └── notification_service.dart
│   │
│   └── utils/                    # Hilfsfunktionen
│       ├── constants.dart
│       └── date_utils.dart
│
├── android/                      # Android-spezifische Dateien
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/com/fairpoint/app/
│   │   │   │   └── MainActivity.kt
│   │   │   └── res/             # Android Resources
│   │   ├── build.gradle         # App-Level Gradle
│   │   └── google-services.json # Firebase Config (generiert)
│   ├── build.gradle             # Project-Level Gradle
│   ├── settings.gradle
│   └── gradle.properties
│
├── ios/                          # iOS-spezifische Dateien
│   ├── Runner/
│   │   ├── Info.plist
│   │   └── GoogleService-Info.plist # Firebase Config (generiert)
│   └── Podfile                   # iOS Dependencies
│
├── assets/                       # Statische Assets
│   ├── images/                   # Bilder
│   └── icons/                    # Icons
│
├── pubspec.yaml                  # Flutter Dependencies
├── analysis_options.yaml         # Dart Linter-Konfiguration
├── .gitignore                    # Git Ignore-Regeln
│
├── README.md                     # Haupt-Dokumentation
├── QUICKSTART.md                 # Schnellstart-Anleitung
├── FIREBASE_SETUP.md             # Firebase Setup-Guide
└── PROJECT_STRUCTURE.md          # Diese Datei
```

## 📋 Datei-Beschreibungen

### Core Files

| Datei | Beschreibung |
|-------|--------------|
| `lib/main.dart` | App-Einstiegspunkt, Theme-Konfiguration, Provider-Setup |
| `lib/firebase_options.dart` | Firebase-Plattform-Konfigurationen |
| `pubspec.yaml` | Flutter-Abhängigkeiten und Asset-Definitionen |

### Models (`lib/models/`)

| Datei | Klasse | Beschreibung |
|-------|--------|--------------|
| `user_model.dart` | `UserModel` | Benutzer (Admin/Kind) mit Punktestand |
| `transaction_model.dart` | `TransactionModel` | Punktetransaktion mit Typ und Grund |
| `reward_model.dart` | `RewardModel`, `RewardRequest` | Belohnung und Einlöseanfrage |
| `feedback_model.dart` | `FeedbackModel` | Wöchentliches Feedback (optional) |

### Providers (`lib/providers/`)

| Datei | Klasse | Verantwortlichkeit |
|-------|--------|-------------------|
| `auth_provider.dart` | `AuthProvider` | Login, Logout, User-Session |
| `points_provider.dart` | `PointsProvider` | Punkte vergeben/abziehen/reset |
| `rewards_provider.dart` | `RewardsProvider` | Belohnungen verwalten, Anfragen |

### Screens

#### Admin (`lib/screens/admin/`)

| Datei | Beschreibung |
|-------|--------------|
| `admin_dashboard.dart` | Haupt-Navigation für Admins |
| `children_overview_screen.dart` | Liste aller Kinder mit Punktestand |
| `child_detail_screen.dart` | Detailansicht eines Kindes |
| `create_child_screen.dart` | Formular zum Erstellen neuer Kinderkonten |
| `pending_requests_screen.dart` | Liste offener Belohnungsanfragen |
| `manage_rewards_screen.dart` | Belohnungen erstellen/verwalten |

#### Child (`lib/screens/child/`)

| Datei | Beschreibung |
|-------|--------------|
| `child_dashboard.dart` | Haupt-Navigation für Kinder |
| `points_overview_screen.dart` | Punktestand mit Fortschrittsanzeige |
| `rewards_screen.dart` | Verfügbare Belohnungen anzeigen/einlösen |
| `transaction_history_screen.dart` | Kontoauszug (Transaktionsverlauf) |

### Services & Utils

| Datei | Beschreibung |
|-------|--------------|
| `services/notification_service.dart` | SnackBar-Benachrichtigungen |
| `utils/constants.dart` | App-Konstanten und Strings |
| `utils/date_utils.dart` | Datums-Formatierungen |

## 🔄 Datenfluss

```
UI (Screens)
    ↓
Provider (State Management)
    ↓
Firebase Services (Firestore, Auth)
    ↓
Models (Data Objects)
```

## 🎨 Design Pattern

### State Management: Provider Pattern

```dart
// 1. Provider definieren
class PointsProvider extends ChangeNotifier {
  // State
  List<UserModel> _children = [];
  
  // Getter
  List<UserModel> get children => _children;
  
  // Action
  Future<void> loadChildren() async {
    // Load from Firestore
    notifyListeners(); // UI aktualisieren
  }
}

// 2. Provider registrieren (main.dart)
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => PointsProvider()),
  ],
  child: App(),
)

// 3. Provider nutzen (Screen)
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PointsProvider>();
    return ListView(children: provider.children);
  }
}
```

### Repository Pattern (implizit in Providers)

Jeder Provider fungiert als Repository:
- Datenabruf aus Firestore
- Geschäftslogik
- UI-State-Updates

## 📊 Firebase Collections Schema

### users
```javascript
{
  userId: {
    username: "string",
    displayName: "string", 
    isAdmin: boolean,
    currentPoints: number,
    weeklyGoal: number,
    createdAt: timestamp,
    lastReset: timestamp?
  }
}
```

### transactions
```javascript
{
  transactionId: {
    userId: "string",
    userName: "string",
    points: number,
    type: "award|deduction|reset|rewardRedemption",
    reason: "string",
    adminId: "string",
    adminName: "string",
    timestamp: timestamp,
    rewardId?: "string"
  }
}
```

### rewards
```javascript
{
  rewardId: {
    title: "string",
    description: "string",
    pointsCost: number,
    isActive: boolean,
    sortOrder: number,
    createdAt: timestamp
  }
}
```

### rewardRequests
```javascript
{
  requestId: {
    userId: "string",
    userName: "string",
    rewardId: "string",
    rewardTitle: "string",
    pointsCost: number,
    status: "pending|approved|rejected",
    requestedAt: timestamp,
    processedAt?: timestamp,
    adminId?: "string",
    adminName?: "string",
    adminNote?: "string"
  }
}
```

## 🔐 Authentifizierung

### User-Typen
- **Admin**: `isAdmin: true` in Firestore
- **Kind**: `isAdmin: false` in Firestore

### Auth-Flow
1. User gibt Username + Passwort ein
2. Username → Email-Format: `username@fairpoint.internal`
3. Firebase Auth prüft Credentials
4. Bei Erfolg: Lade User-Daten aus Firestore
5. Route zu Dashboard basierend auf `isAdmin`

## 🚀 Erweiterungspunkte

### Neue Features hinzufügen

1. **Neues Datenmodell**: Erstelle in `lib/models/`
2. **Business-Logik**: Erstelle Provider in `lib/providers/`
3. **UI**: Erstelle Screen in `lib/screens/`
4. **Navigation**: Aktualisiere entsprechendes Dashboard

### Beispiel: Wöchentliches Feedback

```dart
// 1. Model erstellen (bereits vorhanden)
lib/models/feedback_model.dart

// 2. Provider erstellen
lib/providers/feedback_provider.dart

// 3. Screen erstellen
lib/screens/child/feedback_screen.dart

// 4. Zum Dashboard hinzufügen
lib/screens/child/child_dashboard.dart
```

## 🧪 Testing-Struktur (für Zukunft)

```
test/
├── unit/
│   ├── models/
│   ├── providers/
│   └── services/
├── widget/
│   └── screens/
└── integration/
    └── flows/
```

## 📦 Build Outputs

```
build/
├── app/
│   └── outputs/
│       ├── flutter-apk/
│       │   └── app-release.apk
│       └── bundle/
│           └── release/
│               └── app-release.aab
```

---

Diese Struktur folgt Flutter Best Practices und ermöglicht einfache Wartung und Erweiterung.
