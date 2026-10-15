// =========================================================================
// 📄 FILE: signup_backend_controller.dart
// ROLE: Beginner-friendly Authentication & Invitation Code Controller
// =========================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SignupBackendController {
  // Firebase Auth instance to talk to Google's authentication servers
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // =======================================================================
  // FEATURE A: INVITATION CODE GATE
  // =======================================================================
  // A secure list of pre-approved invitation codes for our closed beta launch.
  final List<String> _validInvitationCodes = [
    'BEDAL100',
    'CAMPUS2026',
    'JEDDAHCHILL',
    'RIYADHDEV',
    'BETAALUMNI'
  ];

  /// Checks if the code entered by the user matches our valid beta list.
  /// Returns [true] if valid, [false] if fake or incorrect.
  bool verifyInvitationCode(String inputCode) {
    // Clean up user input: remove spaces and convert to uppercase
    final String sanitizedCode = inputCode.trim().toUpperCase();
    
    // Check if our hardcoded list contains this code
    final bool isValid = _validInvitationCodes.contains(sanitizedCode);
    
    if (isValid) {
      debugPrint('✅ Invitation code approved: $sanitizedCode');
    } else {
      debugPrint('❌ Invalid invitation code attempted: $sanitizedCode');
    }
    
    return isValid;
  }

  // =======================================================================
  // FEATURE B: FIREBASE EMAIL REGISTRATION & VERIFICATION
  // =======================================================================
  
  /// Creates a new student account with Firebase Auth and triggers the email verification link.
  /// Returns the newly created [User?] object if successful, or null if it fails.
  Future<User?> registerStudentWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('⏳ Creating new user account in Firebase Auth for: $email');

      // 1. Create the user account with email and password in Firebase
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? currentUser = userCredential.user;

      if (currentUser != null) {
        debugPrint('✅ Account created successfully! User UID: ${currentUser.uid}');

        // 2. Immediately trigger Google's automated verification email engine
        await currentUser.sendEmailVerification();
        debugPrint('📧 Verification email sent to: ${currentUser.email}');
      }

      return currentUser;
    } catch (error) {
      debugPrint('❌ Error during student registration: $error');
      return null;
    }
  }

  // =======================================================================
  // FEATURE C: EMAIL VERIFICATION CHECKER
  // =======================================================================
  
  /// Refreshes the current user state from Google's servers to check if they clicked the verification link.
  /// Returns [true] if verified, [false] if still unverified.
  Future<bool> checkIfEmailIsVerified() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // 1. Pull fresh server status from Google
        await currentUser.reload();

        // 2. Re-assign currentUser after reload to get updated properties
        currentUser = _firebaseAuth.currentUser;

        bool isVerified = currentUser?.emailVerified ?? false;
        debugPrint('🔍 Email verification check: $isVerified');
        return isVerified;
      }
      return false;
    } catch (error) {
      debugPrint('❌ Error checking email verification status: $error');
      return false;
    }
  }

  /// Helper to get the currently signed-in user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
