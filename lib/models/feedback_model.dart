import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final DateTime weekStart;
  final DateTime weekEnd;
  final Map<String, int> ratings; // Question -> Rating (1-5)
  final String? additionalComments;
  final DateTime submittedAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.weekStart,
    required this.weekEnd,
    required this.ratings,
    this.additionalComments,
    required this.submittedAt,
  });

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      weekStart: (data['weekStart'] as Timestamp?)?.toDate() ?? DateTime.now(),
      weekEnd: (data['weekEnd'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ratings: Map<String, int>.from(data['ratings'] ?? {}),
      additionalComments: data['additionalComments'],
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'weekStart': Timestamp.fromDate(weekStart),
      'weekEnd': Timestamp.fromDate(weekEnd),
      'ratings': ratings,
      'additionalComments': additionalComments,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    final sum = ratings.values.reduce((a, b) => a + b);
    return sum / ratings.length;
  }
}
