// =========================================================================
// FILE: auth_service.dart
// ROLE: Firebase Authentication Network Service
// =========================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Service handling operations with Firebase Authentication.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registers a student with email and password, then dispatches an email verification link.
  Future<User?> registerStudentWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create user account credentials in Firebase Auth
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? user = credential.user;

      // 2. Dispatch verification link upon successful user creation
      if (user != null) {
        debugPrint('Account created for UID: ${user.uid}. Sending verification link...');
        await user.sendEmailVerification();
        debugPrint('Verification email link successfully dispatched.');
      }

      return user;
    } on FirebaseAuthException catch (e) {
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

  /// Reloads user data token and checks if email verification was completed.
  Future<bool> checkIfEmailIsVerified() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await user.reload();
      return _auth.currentUser?.emailVerified ?? false;
    }

    return false;
  }

  /// Signs out the active user session.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
