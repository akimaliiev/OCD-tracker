import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _auth.currentUser; 

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  /// Sign out from all accounts
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    _user = null;
    notifyListeners();
  }
}
