import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType {
  award,
  deduction,
  reset,
  rewardRedemption,
  refund,
}

class TransactionModel {
  final String id;
  final String userId;
  final String userName;
  final int points;
  final TransactionType type;
  final String reason;
  final String adminId;
  final String adminName;
  final DateTime timestamp;
  final String? rewardId;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.points,
    required this.type,
    required this.reason,
    required this.adminId,
    required this.adminName,
    required this.timestamp,
    this.rewardId,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      points: data['points'] ?? 0,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${data['type']}',
        orElse: () => TransactionType.award,
      ),
      reason: data['reason'] ?? '',
      adminId: data['adminId'] ?? '',
      adminName: data['adminName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rewardId: data['rewardId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'points': points,
      'type': type.toString().split('.').last,
      'reason': reason,
      'adminId': adminId,
      'adminName': adminName,
      'timestamp': Timestamp.fromDate(timestamp),
      'rewardId': rewardId,
    };
  }

  String get displayText {
    switch (type) {
      case TransactionType.award:
        return '+$points Punkte für $reason';
      case TransactionType.deduction:
        return '-${points.abs()} Punkte für $reason';
      case TransactionType.reset:
        return 'Punkte zurückgesetzt - $reason';
      case TransactionType.rewardRedemption:
        return '-$points Punkte - Belohnung eingelöst: $reason';
      case TransactionType.refund:
        return '+$points Punkte zurückerstattet - $reason';
    }
  }

  String get icon {
    switch (type) {
      case TransactionType.award:
        return '✅';
      case TransactionType.deduction:
        return '⚠️';
      case TransactionType.reset:
        return '🕓';
      case TransactionType.rewardRedemption:
        return '🎁';
      case TransactionType.refund:
        return '💰';
    }
  }
}
