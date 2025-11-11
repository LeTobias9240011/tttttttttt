import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reward_model.dart';

class RewardsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<RewardModel> _rewards = [];
  List<RewardRequest> _pendingRequests = [];
  bool _isLoading = false;

  List<RewardModel> get rewards => _rewards;
  List<RewardRequest> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;

  Future<void> loadRewards() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('rewards')
          .where('isActive', isEqualTo: true)
          .get();

      _rewards = snapshot.docs
          .map((doc) => RewardModel.fromFirestore(doc))
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      
      debugPrint('Loaded ${_rewards.length} rewards');
    } catch (e) {
      debugPrint('Error loading rewards: $e');
      _rewards = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingRequests() async {
    try {
      final snapshot = await _firestore
          .collection('rewardRequests')
          .where('status', isEqualTo: 'pending')
          .get();

      _pendingRequests = snapshot.docs
          .map((doc) => RewardRequest.fromFirestore(doc))
          .toList()
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      debugPrint('Loaded ${_pendingRequests.length} pending requests');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading pending requests: $e');
      _pendingRequests = [];
    }
  }

  Future<String?> createReward({
    required String title,
    required String description,
    required int pointsCost,
    int sortOrder = 0,
  }) async {
    try {
      final reward = RewardModel(
        id: '',
        title: title,
        description: description,
        pointsCost: pointsCost,
        isActive: true,
        sortOrder: sortOrder,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('rewards').add(reward.toFirestore());
      await loadRewards();

      return null; // Success
    } catch (e) {
      debugPrint('Error creating reward: $e');
      return 'Fehler beim Erstellen der Belohnung: $e';
    }
  }

  Future<String?> deleteReward(String rewardId) async {
    try {
      // Belohnung auf inaktiv setzen statt zu löschen (für Historie)
      await _firestore.collection('rewards').doc(rewardId).update({
        'isActive': false,
      });
      
      await loadRewards();
      
      debugPrint('Reward deleted: $rewardId');
      return null; // Success
    } catch (e) {
      debugPrint('Error deleting reward: $e');
      return 'Fehler beim Löschen der Belohnung: $e';
    }
  }

  Future<String?> requestReward({
    required String userId,
    required String userName,
    required String rewardId,
    required String rewardTitle,
    required int pointsCost,
  }) async {
    try {
      // Prüfe ob Benutzer genug Punkte hat
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return 'Benutzer nicht gefunden';
      }

      final currentPoints = userDoc.data()?['currentPoints'] ?? 0;
      if (currentPoints < pointsCost) {
        return 'Nicht genug Punkte (${currentPoints}/${pointsCost})';
      }

      final request = RewardRequest(
        id: '',
        userId: userId,
        userName: userName,
        rewardId: rewardId,
        rewardTitle: rewardTitle,
        pointsCost: pointsCost,
        status: RewardStatus.pending,
        requestedAt: DateTime.now(),
      );

      // Punkte sofort abziehen
      await _firestore.collection('users').doc(userId).update({
        'currentPoints': FieldValue.increment(-pointsCost),
      });

      // Anfrage erstellen
      await _firestore.collection('rewardRequests').add(request.toFirestore());

      debugPrint('Reward requested: $rewardTitle for $pointsCost points (deducted immediately)');
      return null; // Success
    } catch (e) {
      debugPrint('Error requesting reward: $e');
      return 'Fehler beim Anfordern der Belohnung: $e';
    }
  }

  Future<String?> approveRewardRequest({
    required String requestId,
    required String adminId,
    required String adminName,
    String? note,
  }) async {
    try {
      // Get the request
      final requestDoc = await _firestore.collection('rewardRequests').doc(requestId).get();
      final request = RewardRequest.fromFirestore(requestDoc);

      // Update request status
      await _firestore.collection('rewardRequests').doc(requestId).update({
        'status': 'approved',
        'processedAt': FieldValue.serverTimestamp(),
        'adminId': adminId,
        'adminName': adminName,
        'adminNote': note,
      });

      // Punkte wurden bereits bei der Anfrage abgezogen, daher hier kein Abzug mehr
      // Nur Transaktion erstellen für die Historie
      await _firestore.collection('transactions').add({
        'userId': request.userId,
        'userName': request.userName,
        'points': -request.pointsCost,
        'type': 'rewardRedemption',
        'reason': request.rewardTitle + (note != null && note.isNotEmpty ? ' - $note' : ''),
        'adminId': adminId,
        'adminName': adminName,
        'timestamp': FieldValue.serverTimestamp(),
        'rewardId': request.rewardId,
      });

      await loadPendingRequests();

      debugPrint('Reward request approved: ${request.rewardTitle}');
      return null; // Success
    } catch (e) {
      debugPrint('Error approving reward request: $e');
      return 'Fehler beim Genehmigen: $e';
    }
  }

  Future<String?> rejectRewardRequest({
    required String requestId,
    required String adminId,
    required String adminName,
    String? note,
  }) async {
    try {
      // Get the request
      final requestDoc = await _firestore.collection('rewardRequests').doc(requestId).get();
      final request = RewardRequest.fromFirestore(requestDoc);

      // Update request status
      await _firestore.collection('rewardRequests').doc(requestId).update({
        'status': 'rejected',
        'processedAt': FieldValue.serverTimestamp(),
        'adminId': adminId,
        'adminName': adminName,
        'adminNote': note,
      });

      // Punkte zurückgeben, da Anfrage abgelehnt wurde
      await _firestore.collection('users').doc(request.userId).update({
        'currentPoints': FieldValue.increment(request.pointsCost),
      });

      // Transaktion für Rückgabe erstellen
      await _firestore.collection('transactions').add({
        'userId': request.userId,
        'userName': request.userName,
        'points': request.pointsCost,
        'type': 'refund',
        'reason': 'Belohnungsanfrage abgelehnt: ${request.rewardTitle}' + (note != null && note.isNotEmpty ? ' - $note' : ''),
        'adminId': adminId,
        'adminName': adminName,
        'timestamp': FieldValue.serverTimestamp(),
        'rewardId': request.rewardId,
      });

      await loadPendingRequests();

      debugPrint('Reward request rejected and points refunded: ${request.rewardTitle}');
      return null; // Success
    } catch (e) {
      debugPrint('Error rejecting reward request: $e');
      return 'Fehler beim Ablehnen: $e';
    }
  }

  Stream<List<RewardRequest>> getUserRewardRequestsStream(String userId) {
    return _firestore
        .collection('rewardRequests')
        .where('userId', isEqualTo: userId)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RewardRequest.fromFirestore(doc))
            .toList());
  }

  /// Admin vergibt eine Belohnung direkt an ein Kind
  Future<String?> grantRewardDirectly({
    required String userId,
    required String userName,
    required String rewardId,
    required String rewardTitle,
    required int pointsCost,
    required String adminId,
    required String adminName,
    String? note,
  }) async {
    try {
      // Prüfe ob Kind genug Punkte hat
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return 'Benutzer nicht gefunden';
      }

      final currentPoints = userDoc.data()?['currentPoints'] ?? 0;
      if (currentPoints < pointsCost) {
        return 'Kind hat nicht genug Punkte (${currentPoints}/${pointsCost})';
      }

      // Punkte abziehen
      await _firestore.collection('users').doc(userId).update({
        'currentPoints': FieldValue.increment(-pointsCost),
      });

      // Transaktion erstellen
      await _firestore.collection('transactions').add({
        'userId': userId,
        'userName': userName,
        'points': -pointsCost,
        'type': 'rewardRedemption',
        'reason': rewardTitle + (note != null && note.isNotEmpty ? ' - $note' : ''),
        'adminId': adminId,
        'adminName': adminName,
        'timestamp': FieldValue.serverTimestamp(),
        'rewardId': rewardId,
      });

      // Optional: Automatisch genehmigte Anfrage erstellen für Historie
      await _firestore.collection('rewardRequests').add({
        'userId': userId,
        'userName': userName,
        'rewardId': rewardId,
        'rewardTitle': rewardTitle,
        'pointsCost': pointsCost,
        'status': 'approved',
        'requestedAt': FieldValue.serverTimestamp(),
        'processedAt': FieldValue.serverTimestamp(),
        'adminId': adminId,
        'adminName': adminName,
        'adminNote': note ?? 'Direkt vom Admin vergeben',
      });

      return null; // Success
    } catch (e) {
      debugPrint('Error granting reward directly: $e');
      return 'Fehler beim Vergeben der Belohnung: $e';
    }
  }
}
