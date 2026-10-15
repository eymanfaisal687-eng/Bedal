import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/auth/user_profile_model.dart';

class DatabaseSeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Runs an automated injection sequence to populate your Firestore console
  /// with realistic campus profiles across your launch cities.
  Future<void> seedTestProfiles() async {
    debugPrint('Database Seeder: Initializing mock profile transmission sequence...');

    // Clean list of mock user profiles matching your app segmentation templates
    final List<UserProfileModel> mockUsers = [
      UserProfileModel(
        uid: 'mock_user_jeddah_1',
        fullName: 'Sara Ali',
        email: 'sara.ali@effat.edu.sa',
        registeredCity: 'Jeddah',
        currentLevel: 4,
        experiencePoints: 350,
        bedalTokensBalance: 3.5,
      ),
      UserProfileModel(
        uid: 'mock_user_islamabad_1',
        fullName: 'Omar Khan',
        email: 'omar.k@nust.edu.pk',
        registeredCity: 'Islamabad',
        currentLevel: 2,
        experiencePoints: 120,
      ),
    ];

    for (var user in mockUsers) {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    }

    debugPrint('Database Seeder: Successfully seeded ${mockUsers.length} profiles.');
  }
}
