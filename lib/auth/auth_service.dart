import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<DateTime?> getTrialStartDate() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _fireStore.collection("Users").doc(user.uid).get();

        if (userDoc.exists) {
          print('User document: ${userDoc.data()}');
          String? trialStartDateStr = userDoc.data()?['trialStartDate'];
          if (trialStartDateStr != null) {
            return DateTime.parse(trialStartDateStr);
          }
        } else {
          print("Document does not exist for user: ${user.uid}");
        }
      }
    } catch (e) {
      print('Error fetching trial start date: $e');
    }
    return null;
  }

  Future<bool> isUserSubscribed() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _fireStore.collection("Users").doc(user.uid).get();

        if (userDoc.exists) {
          return userDoc.data()?['isSubscribed'] ?? false;
        }
      }
    } catch (e) {
      print('Error checking subscription status: $e');
    }
    return false;
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      DocumentReference<Map<String, dynamic>> userRef =
          _fireStore.collection("Users").doc(userCredential.user!.uid);
      DocumentSnapshot<Map<String, dynamic>> userDoc = await userRef.get();

      if (!userDoc.exists) {
        await userRef.set({
          'uid': userCredential.user!.uid,
          'email': email,
          'trialStartDate': DateTime.now().toIso8601String(),
          'isSubscribed': false,
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error signing in: $e');
      throw Exception(e.message ?? 'Sign-in failed');
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        trialStartDate: DateTime.now(),
        isSubscribed: false,
      );

      await _fireStore.collection("Users").doc(newUser.uid).set(newUser.toFirestore());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error signing up: $e');
      throw Exception(e.message ?? 'Sign-up failed');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete the user's document from Firestore
        await _fireStore.collection("Users").doc(user.uid).delete();

        // Delete the user from Firebase Authentication
        await user.delete();

        print('Account deleted successfully');
      } else {
        throw Exception('No user is currently signed in');
      }
    } on FirebaseAuthException catch (e) {
      print('Error deleting account: $e');
      throw Exception(e.message ?? 'Failed to delete account');
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account');
    }
  }
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }
  Future<void> saveCompulsion(String compulsion) async {
  User? user = _auth.currentUser;
  if (user != null) {
    DocumentReference userRef = _fireStore.collection("Users").doc(user.uid);
    await userRef.update({
      'compulsions': FieldValue.arrayUnion([compulsion])
    });
  }
}

}
