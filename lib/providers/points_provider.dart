import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class PointsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> _children = [];
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<UserModel> get children => _children;
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadChildren() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('isAdmin', isEqualTo: false)
          .get();

      _children = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList()
        ..sort((a, b) => a.displayName.compareTo(b.displayName));
      
      debugPrint('Loaded ${_children.length} children');
    } catch (e) {
      debugPrint('Error loading children: $e');
      _children = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTransactions({String? userId, int limit = 50}) async {
    try {
      Query query = _firestore.collection('transactions');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.get();
      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Limit results after sorting
      if (_transactions.length > limit) {
        _transactions = _transactions.sublist(0, limit);
      }

      debugPrint('Loaded ${_transactions.length} transactions');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      _transactions = [];
    }
  }

  Future<String?> awardPoints({
    required String userId,
    required String userName,
    required int points,
    required String reason,
    required String adminId,
    required String adminName,
  }) async {
    try {
      // Create transaction
      final transaction = TransactionModel(
        id: '',
        userId: userId,
        userName: userName,
        points: points,
        type: TransactionType.award,
        reason: reason,
        adminId: adminId,
        adminName: adminName,
        timestamp: DateTime.now(),
      );

      // Add to Firestore
      await _firestore.collection('transactions').add(transaction.toFirestore());

      // Update user points
      await _firestore.collection('users').doc(userId).update({
        'currentPoints': FieldValue.increment(points),
      });

      await loadChildren();
      await loadTransactions();

      return null; // Success
    } catch (e) {
      debugPrint('Error awarding points: $e');
      return 'Fehler beim Vergeben der Punkte: $e';
    }
  }

  Future<String?> deductPoints({
    required String userId,
    required String userName,
    required int points,
    required String reason,
    required String adminId,
    required String adminName,
  }) async {
    try {
      // Create transaction
      final transaction = TransactionModel(
        id: '',
        userId: userId,
        userName: userName,
        points: -points.abs(),
        type: TransactionType.deduction,
        reason: reason,
        adminId: adminId,
        adminName: adminName,
        timestamp: DateTime.now(),
      );

      // Add to Firestore
      await _firestore.collection('transactions').add(transaction.toFirestore());

      // Update user points (ensure it doesn't go below 0)
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final currentPoints = userDoc.data()?['currentPoints'] ?? 0;
      final newPoints = (currentPoints - points.abs()).clamp(0, double.infinity).toInt();

      await _firestore.collection('users').doc(userId).update({
        'currentPoints': newPoints,
      });

      await loadChildren();
      await loadTransactions();

      return null; // Success
    } catch (e) {
      debugPrint('Error deducting points: $e');
      return 'Fehler beim Abziehen der Punkte: $e';
    }
  }

  Future<String?> resetPoints({
    required String userId,
    required String userName,
    required String reason,
    required String adminId,
    required String adminName,
  }) async {
    try {
      // Get current points for transaction record
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final currentPoints = userDoc.data()?['currentPoints'] ?? 0;

      // Create transaction
      final transaction = TransactionModel(
        id: '',
        userId: userId,
        userName: userName,
        points: -currentPoints,
        type: TransactionType.reset,
        reason: reason,
        adminId: adminId,
        adminName: adminName,
        timestamp: DateTime.now(),
      );

      // Add to Firestore
      await _firestore.collection('transactions').add(transaction.toFirestore());

      // Reset user points
      await _firestore.collection('users').doc(userId).update({
        'currentPoints': 0,
        'lastReset': FieldValue.serverTimestamp(),
      });

      await loadChildren();
      await loadTransactions();

      return null; // Success
    } catch (e) {
      debugPrint('Error resetting points: $e');
      return 'Fehler beim Zurücksetzen: $e';
    }
  }

  Future<String?> resetAllPoints({
    required String reason,
    required String adminId,
    required String adminName,
  }) async {
    try {
      final batch = _firestore.batch();

      for (final child in _children) {
        // Create transaction for each child
        final transactionRef = _firestore.collection('transactions').doc();
        final transaction = TransactionModel(
          id: transactionRef.id,
          userId: child.id,
          userName: child.displayName,
          points: -child.currentPoints,
          type: TransactionType.reset,
          reason: reason,
          adminId: adminId,
          adminName: adminName,
          timestamp: DateTime.now(),
        );
        batch.set(transactionRef, transaction.toFirestore());

        // Reset user points
        final userRef = _firestore.collection('users').doc(child.id);
        batch.update(userRef, {
          'currentPoints': 0,
          'lastReset': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      await loadChildren();
      await loadTransactions();

      return null; // Success
    } catch (e) {
      debugPrint('Error resetting all points: $e');
      return 'Fehler beim Zurücksetzen aller Punkte: $e';
    }
  }

  Stream<List<TransactionModel>> getUserTransactionsStream(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }
}
