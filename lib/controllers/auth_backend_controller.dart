// =========================================================================
// FILE: auth_backend_controller.dart
// ROLE: Database Access Gate & Regional Boundary Controller
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Controller handling database access evaluation and regional waitlist operations.
class AuthBackendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Regional permission flags and active location state
  bool isReadOnlyMode = false;
  String currentDetectedCity = "Detecting...";

  // List of launched cities with active operations
  final List<String> _launchedCitiesCluster = [
    'Islamabad',
    'Lahore',
    'Karachi',
    'Jeddah',
  ];

  /// Evaluates regional boundaries and establishes access states for the current session.
  Future<void> evaluateAccountBoundary({
    required String detectedCity,
    required VoidCallback onAccessGranted,
    required Function(String city) onCityNotLaunched,
  }) async {
    final String cleanCity = detectedCity.trim();
    currentDetectedCity = cleanCity;

    // Case-insensitive check against supported city list
    final bool isLaunched = _launchedCitiesCluster.any(
      (c) => c.toLowerCase() == cleanCity.toLowerCase(),
    );

    if (isLaunched) {
      isReadOnlyMode = false; // Full interactive marketplace access enabled
      onAccessGranted();
    } else {
      isReadOnlyMode = true; // Read-only mode activated for unlaunched regions
      onCityNotLaunched(cleanCity);
    }
  }

  /// Appends an unlaunched city user's email to the Firestore launch waitlist.
  Future<void> submitEmailToLaunchWaitlist({
    required String city,
    required String userEmail,
  }) async {
    if (userEmail.trim().isEmpty || !userEmail.contains('@')) {
      throw Exception('Invalid email address format.');
    }

    try {
      // Saves record to Firestore sub-collection: launch_waitlists/{city}/emails
      await _firestore
          .collection('launch_waitlists')
          .doc(city.toLowerCase().trim())
          .collection('emails')
          .add({
        'email': userEmail.trim().toLowerCase(),
        'registeredAt': FieldValue.serverTimestamp(),
        'platformSource': 'Mobile App Client',
      });
    } catch (databaseError) {
      throw Exception('Failed to save email to waitlist in Firebase: $databaseError');
    }
  }
}
