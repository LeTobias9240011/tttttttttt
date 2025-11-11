import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      try {
        if (firebaseUser != null) {
          debugPrint('Auth state changed: User logged in (${firebaseUser.uid})');
          await _loadUserData(firebaseUser.uid);
        } else {
          debugPrint('Auth state changed: No user logged in');
          _currentUser = null;
          _isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error in auth state listener: $e');
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      debugPrint('Loading user data for UID: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        debugPrint('User data loaded: ${_currentUser!.displayName} (Admin: ${_currentUser!.isAdmin})');
      } else {
        debugPrint('User document not found for UID: $uid');
        _currentUser = null;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn(String username, String password) async {
    try {
      String email;
      
      // Check if input is already an email or just a username
      if (username.contains('@')) {
        // It's an email, use it directly
        email = username.toLowerCase().trim();
        debugPrint('Login mit Email: $email');
      } else {
        // It's a username, query Firestore to find the user document
        final querySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: username.toLowerCase().trim())
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          return 'Benutzername nicht gefunden';
        }

        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        
        // Check if email field exists in Firestore document
        if (userData.containsKey('email') && userData['email'] != null) {
          email = userData['email'].toString().toLowerCase().trim();
          debugPrint('Email aus Firestore: $email');
        } else {
          // Fallback: Use internal email format
          email = '${username.toLowerCase().trim()}@fairpoint.internal';
          debugPrint('Fallback Email: $email');
        }
      }

      // Sign in with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Firebase Auth erfolgreich. UID: ${userCredential.user?.uid}');

      // Check if user document exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User authenticated but no Firestore document
        await _auth.signOut();
        return 'Benutzerprofil nicht gefunden. Bitte kontaktiere den Administrator.';
      }

      debugPrint('Firestore-Dokument gefunden für UID: ${userCredential.user?.uid}');
      return null; // Success
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        return 'Benutzername oder Email nicht gefunden';
      } else if (e.code == 'wrong-password') {
        return 'Falsches Passwort';
      } else if (e.code == 'invalid-email') {
        return 'Ungültige Email-Adresse';
      } else if (e.code == 'invalid-credential') {
        return 'Falsche Anmeldedaten. Bitte Benutzername und Passwort prüfen.';
      }
      return 'Anmeldefehler: ${e.message}';
    } catch (e) {
      debugPrint('Allgemeiner Fehler: $e');
      return 'Ein Fehler ist aufgetreten: $e';
    }
  }

  Future<String?> createChildAccount({
    required String username,
    required String displayName,
    required String password,
  }) async {
    try {
      // Check if admin is logged in
      final currentAdminUser = _currentUser;
      
      if (currentAdminUser == null) {
        return 'Admin nicht eingeloggt';
      }

      if (!currentAdminUser.isAdmin) {
        return 'Nur Admins können Kindkonten erstellen';
      }

      debugPrint('Creating child account for username: $username');

      // Check if username already exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'Benutzername bereits vergeben';
      }

      final childEmail = '${username.toLowerCase()}@fairpoint.internal';

      // Use Firebase REST API to create user without logging out the admin
      // Get API key from Firebase App
      final apiKey = _auth.app.options.apiKey;
      
      final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey'
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': childEmail,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unbekannter Fehler';
        debugPrint('Firebase REST API Error: $errorMessage');
        
        if (errorMessage.contains('EMAIL_EXISTS')) {
          return 'Email bereits vergeben';
        } else if (errorMessage.contains('WEAK_PASSWORD')) {
          return 'Passwort ist zu schwach (mindestens 6 Zeichen)';
        }
        return 'Fehler beim Erstellen: $errorMessage';
      }

      final responseData = json.decode(response.body);
      final childUid = responseData['localId'];

      debugPrint('Child created via REST API with UID: $childUid');

      // Create Firestore user document for child
      final newUser = UserModel(
        id: childUid,
        username: username.toLowerCase(),
        displayName: displayName,
        isAdmin: false,
        currentPoints: 0,
        weeklyGoal: 100,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(childUid)
          .set(newUser.toFirestore());

      debugPrint('Firestore document created for child');
      debugPrint('Admin bleibt eingeloggt!');

      return null; // Success
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException during child creation: ${e.code} - ${e.message}');
      return 'Fehler beim Erstellen: ${e.message}';
    } catch (e) {
      debugPrint('Error creating child account: $e');
      return 'Ein Fehler ist aufgetreten: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    if (_auth.currentUser != null) {
      await _loadUserData(_auth.currentUser!.uid);
    }
  }
}
