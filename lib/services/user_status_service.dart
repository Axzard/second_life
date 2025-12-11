import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStatusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Set user status to online
  Future<void> setUserOnline() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    try {
      await _db.collection('users').doc(userId).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Error setting user online
    }
  }

  /// Set user status to offline
  Future<void> setUserOffline() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    try {
      await _db.collection('users').doc(userId).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Error setting user offline
    }
  }

  /// Setup listener for auth state changes
  void setupAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setUserOnline();
      } else {
        setUserOffline();
      }
    });
  }
}
