import 'package:cloud_firestore/cloud_firestore.dart';

enum RewardStatus {
  available,
  pending,
  approved,
  rejected,
}

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
  });

  factory RewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      pointsCost: data['pointsCost'] ?? 0,
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'pointsCost': pointsCost,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsCost,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsCost: pointsCost ?? this.pointsCost,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RewardRequest {
  final String id;
  final String userId;
  final String userName;
  final String rewardId;
  final String rewardTitle;
  final int pointsCost;
  final RewardStatus status;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? adminId;
  final String? adminName;
  final String? adminNote;

  RewardRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rewardId,
    required this.rewardTitle,
    required this.pointsCost,
    required this.status,
    required this.requestedAt,
    this.processedAt,
    this.adminId,
    this.adminName,
    this.adminNote,
  });

  factory RewardRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardRequest(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      rewardId: data['rewardId'] ?? '',
      rewardTitle: data['rewardTitle'] ?? '',
      pointsCost: data['pointsCost'] ?? 0,
      status: RewardStatus.values.firstWhere(
        (e) => e.toString() == 'RewardStatus.${data['status']}',
        orElse: () => RewardStatus.pending,
      ),
      requestedAt: (data['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      processedAt: (data['processedAt'] as Timestamp?)?.toDate(),
      adminId: data['adminId'],
      adminName: data['adminName'],
      adminNote: data['adminNote'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'rewardId': rewardId,
      'rewardTitle': rewardTitle,
      'pointsCost': pointsCost,
      'status': status.toString().split('.').last,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'processedAt': processedAt != null ? Timestamp.fromDate(processedAt!) : null,
      'adminId': adminId,
      'adminName': adminName,
      'adminNote': adminNote,
    };
  }
}
