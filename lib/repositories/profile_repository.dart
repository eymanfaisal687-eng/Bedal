// =========================================================================
// FILE: profile_repository.dart
// ROLE: Firestore Data & Firebase Storage Repository for User Profiles
// =========================================================================

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/auth/user_profile_model.dart';

/// Repository managing Firestore user profile persistence and Firebase Storage uploads.
class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Fetches a user profile document from Firestore by user ID.
  Future<UserProfileModel?> getUserProfile(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfileModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  /// Saves or merges a user profile document in Firestore.
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      await _firestore.collection('users').doc(profile.uid).set(
            profile.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Updates specific fields on a user profile document in Firestore.
  Future<void> updateProfileFields(String uid, Map<String, dynamic> fields) async {
    try {
      fields['updatedAt'] = DateTime.now().toIso8601String();
      await _firestore.collection('users').doc(uid).update(fields);
    } catch (e) {
      throw Exception('Failed to update profile fields: $e');
    }
  }

  /// Uploads profile image file to Firebase Storage and returns its download URL.
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      final Reference ref = _storage.ref().child('users/$uid/profile/profile_image.jpg');
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Deletes profile image from Firebase Storage if present.
  Future<void> deleteProfileImage(String uid) async {
    try {
      final Reference ref = _storage.ref().child('users/$uid/profile/profile_image.jpg');
      await ref.delete();
    } catch (_) {
      // Ignored if file does not exist
    }
  }
}
