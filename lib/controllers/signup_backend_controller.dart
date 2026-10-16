// =========================================================================
// FILE: signup_backend_controller.dart
// ROLE: Authentication, Registration & Invitation Gate Controller
// =========================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Controller managing user registration, email verification, and invitation code validation.
class SignupBackendController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // List of valid invitation codes for the closed access rollout
  final List<String> _validInvitationCodes = [
    'BEDAL100',
    'CAMPUS2026',
    'JEDDAHCHILL',
    'RIYADHDEV',
    'BETAALUMNI',
  ];

  /// Checks if the code entered by the user matches the authorized access list.
  /// Returns [true] if valid, [false] otherwise.
  bool verifyInvitationCode(String inputCode) {
    // Sanitize user input: trim whitespace and convert to uppercase
    final String sanitizedCode = inputCode.trim().toUpperCase();
    final bool isValid = _validInvitationCodes.contains(sanitizedCode);

    if (isValid) {
      debugPrint('Invitation code approved: $sanitizedCode');
    } else {
      debugPrint('Invalid invitation code attempted: $sanitizedCode');
    }

    return isValid;
  }

  /// Registers a user account in Firebase Auth and dispatches an email verification link.
  /// Returns the created [User] object upon success, or null on failure.
  Future<User?> registerStudentWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Creating user account in Firebase Auth for: $email');

      // 1. Create account with email and password
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? currentUser = userCredential.user;

      // 2. Dispatch verification email upon successful account creation
      if (currentUser != null) {
        debugPrint('Account created successfully for UID: ${currentUser.uid}');
        await currentUser.sendEmailVerification();
        debugPrint('Verification email dispatched to: ${currentUser.email}');
      }

      return currentUser;
    } catch (error) {
      debugPrint('Error during registration sequence: $error');
      return null;
    }
  }

  /// Reloads current user state from Firebase servers to verify email confirmation status.
  /// Returns [true] if verified, [false] otherwise.
  Future<bool> checkIfEmailIsVerified() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Force reload user token to obtain updated email verification state
        await currentUser.reload();
        currentUser = _firebaseAuth.currentUser;

        final bool isVerified = currentUser?.emailVerified ?? false;
        debugPrint('Email verification state: $isVerified');
        return isVerified;
      }
      return false;
    } catch (error) {
      debugPrint('Error checking email verification status: $error');
      return false;
    }
  }

  /// Helper returning the currently authenticated user.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
