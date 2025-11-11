# 🤝 Beitragen zu FairPoint

Vielen Dank für dein Interesse, FairPoint zu verbessern! Hier erfährst du, wie du beitragen kannst.

## 🌟 Wie kann ich beitragen?

### 🐛 Bugs melden

1. Prüfe, ob der Bug bereits gemeldet wurde (Issues durchsuchen)
2. Erstelle ein neues Issue mit:
   - Klare Beschreibung des Problems
   - Schritte zur Reproduktion
   - Erwartetes vs. tatsächliches Verhalten
   - Screenshots (falls hilfreich)
   - Flutter/Dart Version
   - Gerät/Emulator Info

### 💡 Feature-Vorschläge

1. Prüfe bestehende Feature-Requests
2. Erstelle ein Issue mit:
   - Detaillierte Beschreibung des Features
   - Use-Case (Warum ist es nützlich?)
   - Mockups/Sketches (optional)
   - Mögliche Implementierung (optional)

### 🔧 Code beitragen

#### 1. Fork & Clone

```bash
# Fork das Repository auf GitHub
# Clone dein Fork
git clone https://github.com/DEIN-USERNAME/fairpoint.git
cd fairpoint
```

#### 2. Branch erstellen

```bash
git checkout -b feature/mein-neues-feature
# oder
git checkout -b fix/bug-beschreibung
```

#### 3. Development Setup

```bash
flutter pub get
# Firebase konfigurieren (siehe FIREBASE_SETUP.md)
flutter run
```

#### 4. Code-Änderungen

**Code-Style Guidelines:**

```dart
// ✅ Gut: Aussagekräftige Namen
class UserPointsManager {
  Future<void> awardPoints(int amount, String reason) async {
    // Implementation
  }
}

// ❌ Schlecht: Unklare Namen
class UPM {
  Future<void> ap(int a, String r) async {
    // Implementation
  }
}

// ✅ Gut: Kommentare für komplexe Logik
/// Calculates weekly progress based on current points and goal
double calculateWeeklyProgress(int currentPoints, int weeklyGoal) {
  return (currentPoints / weeklyGoal).clamp(0.0, 1.0);
}

// ✅ Gut: const constructors wo möglich
const EdgeInsets.all(16.0)

// ✅ Gut: Error Handling
try {
  await performOperation();
} catch (e) {
  debugPrint('Error: $e');
  return 'Fehler bei der Operation';
}
```

#### 5. Testen

```bash
# Code formatieren
flutter format .

# Linting
flutter analyze

# Tests ausführen (wenn vorhanden)
flutter test
```

#### 6. Commit & Push

```bash
git add .
git commit -m "feat: Neue Funktion hinzugefügt"
# oder
git commit -m "fix: Bug in Punktevergabe behoben"

git push origin feature/mein-neues-feature
```

**Commit Message Format:**

```
<typ>: <kurze Beschreibung>

[Optional: Längere Beschreibung]

[Optional: Breaking Changes]
```

Typen:
- `feat`: Neues Feature
- `fix`: Bugfix
- `docs`: Dokumentation
- `style`: Code-Formatierung
- `refactor`: Code-Refactoring
- `test`: Tests
- `chore`: Build/Config-Änderungen

Beispiele:
```
feat: Wöchentliches Feedback-Formular hinzugefügt
fix: Punkteberechnung bei Reset korrigiert
docs: Firebase Setup-Anleitung erweitert
style: Code-Formatierung angepasst
refactor: Provider-Struktur verbessert
```

#### 7. Pull Request erstellen

1. Gehe zu deinem Fork auf GitHub
2. Klicke "Compare & pull request"
3. Fülle die PR-Vorlage aus:
   - Was wurde geändert?
   - Warum wurde es geändert?
   - Wie wurde es getestet?
   - Screenshots (bei UI-Änderungen)
4. Verlinke relevante Issues

## 📋 Code-Richtlinien

### Dart/Flutter Best Practices

```dart
// ✅ Provider Pattern verwenden
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyProvider>();
    return Text(provider.data);
  }
}

// ✅ Null-Safety beachten
String? nullableValue;
String nonNullableValue = nullableValue ?? 'default';

// ✅ Async/Await verwenden
Future<void> loadData() async {
  final data = await fetchData();
  processData(data);
}

// ✅ Error Handling
try {
  await riskyOperation();
} on FirebaseException catch (e) {
  print('Firebase error: ${e.code}');
} catch (e) {
  print('Unknown error: $e');
}
```

### Projektstruktur

Neue Dateien sollten hier platziert werden:

```
lib/
├── models/          # Neue Datenmodelle
├── providers/       # Neue Provider
├── screens/         # Neue UI-Screens
│   ├── admin/       # Admin-Screens
│   └── child/       # Kind-Screens
├── widgets/         # Wiederverwendbare Widgets
├── services/        # Business-Logik
└── utils/           # Hilfsfunktionen
```

### UI-Richtlinien

- Material Design 3 verwenden
- Responsive Design (verschiedene Bildschirmgrößen)
- Accessibility beachten (Screenreader-Support)
- Dark Mode kompatibel
- Deutsche Texte (i18n für Zukunft vorbereiten)

### Firebase-Richtlinien

- Firestore Security Rules prüfen
- Batched Writes für mehrere Operationen
- Offline-Fähigkeit berücksichtigen
- Fehlerbehandlung implementieren

## 🧪 Testing

### Manuelle Tests

Vor dem Commit:
1. App auf Android testen
2. App auf iOS testen (wenn möglich)
3. Verschiedene Bildschirmgrößen
4. Dark Mode
5. Edge Cases (0 Punkte, viele Punkte, etc.)

### Automatische Tests (Zukunft)

```dart
// Unit Test Beispiel
test('calculates weekly progress correctly', () {
  final progress = calculateWeeklyProgress(75, 100);
  expect(progress, 0.75);
});

// Widget Test Beispiel
testWidgets('displays points correctly', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('100 Punkte'), findsOneWidget);
});
```

## 📝 Dokumentation

### Code-Dokumentation

```dart
/// Vergibt Punkte an einen Benutzer
///
/// [userId] Die ID des Benutzers
/// [points] Anzahl der zu vergebenden Punkte
/// [reason] Grund für die Punktevergabe
///
/// Returns null bei Erfolg, Fehlermeldung bei Fehler
Future<String?> awardPoints({
  required String userId,
  required int points,
  required String reason,
}) async {
  // Implementation
}
```

### README/Dokumentation aktualisieren

Bei neuen Features:
1. README.md aktualisieren
2. CHANGELOG.md aktualisieren
3. Screenshots aktualisieren (falls nötig)

## 🎯 Prioritäten

High Priority:
- 🔴 Kritische Bugs
- 🔴 Sicherheitsprobleme
- 🟡 Performance-Verbesserungen

Medium Priority:
- 🟡 Neue Features
- 🟡 UI/UX-Verbesserungen
- 🟢 Code-Refactoring

Low Priority:
- 🟢 Dokumentation
- 🟢 Tests
- 🟢 Nice-to-have Features

## ❓ Fragen?

- 📧 Erstelle ein Issue mit dem Label "question"
- 💬 Diskutiere in bestehenden Issues
- 📚 Lies die Dokumentation (README, QUICKSTART, etc.)

## 🙏 Danke!

Jeder Beitrag hilft, FairPoint besser zu machen und mehr Kindern und Jugendlichen zu helfen!

---

**Happy Coding!** 🚀
