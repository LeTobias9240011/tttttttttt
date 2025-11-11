import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String displayName;
  final bool isAdmin;
  final int currentPoints;
  final int weeklyGoal;
  final DateTime createdAt;
  final DateTime? lastReset;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.isAdmin,
    this.currentPoints = 0,
    this.weeklyGoal = 100,
    required this.createdAt,
    this.lastReset,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      displayName: data['displayName'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      currentPoints: data['currentPoints'] ?? 0,
      weeklyGoal: data['weeklyGoal'] ?? 100,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastReset: (data['lastReset'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'currentPoints': currentPoints,
      'weeklyGoal': weeklyGoal,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastReset': lastReset != null ? Timestamp.fromDate(lastReset!) : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? displayName,
    bool? isAdmin,
    int? currentPoints,
    int? weeklyGoal,
    DateTime? createdAt,
    DateTime? lastReset,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      isAdmin: isAdmin ?? this.isAdmin,
      currentPoints: currentPoints ?? this.currentPoints,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      createdAt: createdAt ?? this.createdAt,
      lastReset: lastReset ?? this.lastReset,
    );
  }
}
