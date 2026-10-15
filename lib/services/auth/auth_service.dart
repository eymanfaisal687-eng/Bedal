import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This service class handles all direct network communication with Firebase Auth.
/// It keeps your signup screens and providers entirely clean.
class AuthService {
  // Initialize the Firebase Auth instance profile
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a fresh student account using email and password,
  /// then immediately fires a secure verification link to their inbox.
  Future<User?> registerStudentWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the user credential profile on Google's secure auth database
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = credential.user;

      // 2. If the user account creation is successful, instantly fire the verification email
      if (user != null) {
        debugPrint('Account created for UID: ${user.uid}. Sending link...');
        await user.sendEmailVerification();
        debugPrint('Verification email link successfully dispatched.');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Handle explicit Firebase errors cleanly so we can show them on our UI screen
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address format is invalid.');
      } else {
        throw Exception(e.message ?? 'Authentication failed. Please try again.');
      }
    } catch (e) {
      throw Exception('An unexpected network error occurred: $e');
    }
  }

  /// Reloads the user's profile state from Google's servers
  /// and checks if they have successfully clicked the verification link.
  Future<bool> checkIfEmailIsVerified() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Force reload the user data token to capture the live click status update
      await user.reload();
      return _auth.currentUser!.emailVerified;
    }

    return false;
  }

  /// Logs out the user profile session instantly
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
