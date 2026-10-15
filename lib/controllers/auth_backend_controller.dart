// =========================================================================
// 🗄️ FILE: auth_backend_controller.dart
// ROLE: Layer 2 Database Validation Gate & Global Expansion Routing Engine
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthBackendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Global State Keys tracking regional permission parameters
  bool isReadOnlyMode = false;
  String currentDetectedCity = "Detecting...";

  // 🇵🇰 Core authorized production-ready startup target cluster list matrix
  final List<String> _launchedCitiesCluster = [
    'Islamabad',
    'Lahore',
    'Karachi',
    'Jeddah'
  ];

  /// Evaluates regional boundaries and establishes access states for the current session.
  Future<void> evaluateAccountBoundary({
    required String detectedCity,
    required VoidCallback onAccessGranted,
    required Function(String city) onCityNotLaunched,
  }) async {
    final String cleanCity = detectedCity.trim();
    currentDetectedCity = cleanCity;

    // Case-insensitive check against launched cities cluster
    final bool isLaunched = _launchedCitiesCluster.any(
      (c) => c.toLowerCase() == cleanCity.toLowerCase(),
    );

    if (isLaunched) {
      isReadOnlyMode = false; // Full interactive marketplace permissions unlocked!
      onAccessGranted();
    } else {
      isReadOnlyMode = true; // Lock down state variables automatically
      onCityNotLaunched(cleanCity);
    }
  }

  /// Appends an unlaunched city citizen's email straight into your database launch waitlists.
  Future<void> submitEmailToLaunchWaitlist({
    required String city,
    required String userEmail,
  }) async {
    if (userEmail.trim().isEmpty || !userEmail.contains('@')) {
      throw Exception('Invalid administrative email address schema parameters.');
    }

    try {
      // Saves directly to a secure Firestore sub-collection: launch_waitlists/{city}/emails
      await _firestore
          .collection('launch_waitlists')
          .doc(city.toLowerCase().trim())
          .collection('emails')
          .add({
        'email': userEmail.trim().toLowerCase(),
        'registeredAt': FieldValue.serverTimestamp(),
        'platformSource': 'Android/iOS Client Stack Layer',
      });
    } catch (databaseError) {
      throw Exception('Failed to push email ledger record entry to Firebase: $databaseError');
    }
  }
}
