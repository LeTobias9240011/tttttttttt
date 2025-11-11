class AppConstants {
  // Points
  static const int defaultWeeklyGoal = 100;
  static const int minPoints = 0;
  
  // Rewards
  static const int minRewardCost = 1;
  static const int maxRewardCost = 1000;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Pagination
  static const int transactionsPerPage = 50;
  static const int rewardsPerPage = 20;
  
  // Validation
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 6;
  static const int minDisplayNameLength = 2;
  
  // Messages
  static const String successMessage = 'Erfolgreich!';
  static const String errorMessage = 'Ein Fehler ist aufgetreten';
  static const String noInternetMessage = 'Keine Internetverbindung';
}

class AppStrings {
  // Auth
  static const String login = 'Anmelden';
  static const String logout = 'Abmelden';
  static const String username = 'Benutzername';
  static const String password = 'Passwort';
  static const String displayName = 'Anzeigename';
  
  // Points
  static const String points = 'Punkte';
  static const String currentPoints = 'Aktuelle Punkte';
  static const String weeklyGoal = 'Wochenziel';
  static const String awardPoints = 'Punkte vergeben';
  static const String deductPoints = 'Punkte abziehen';
  static const String resetPoints = 'Punkte zurücksetzen';
  
  // Rewards
  static const String rewards = 'Belohnungen';
  static const String redeemReward = 'Belohnung einlösen';
  static const String pendingRequests = 'Offene Anfragen';
  
  // Common
  static const String confirm = 'Bestätigen';
  static const String cancel = 'Abbrechen';
  static const String save = 'Speichern';
  static const String delete = 'Löschen';
  static const String edit = 'Bearbeiten';
  static const String add = 'Hinzufügen';
  static const String refresh = 'Aktualisieren';
}
