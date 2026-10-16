import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth/user_profile_model.dart';
import '../repositories/profile_repository.dart';

// =========================================================================
// 📄 FILE: profile_provider.dart
// PURPOSE: Provider managing user profile state, updates, and storage integration
// =========================================================================

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfileModel? _profile;
  bool _isLoading = false;
  String _errorMessage = '';

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Loads current user profile from Firebase Firestore
  Future<void> loadUserProfile({String? userId}) async {
    final uid = userId ?? _auth.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _profile = await _repository.getUserProfile(uid);
      // If profile doesn't exist yet, initialize default new user profile
      if (_profile == null) {
        _profile = UserProfileModel(
          uid: uid,
          fullName: _auth.currentUser?.displayName ?? 'Bedal Member',
          email: _auth.currentUser?.email ?? '',
          registeredCity: 'Jeddah',
          currentLevel: 1,
          experiencePoints: 0,
        );
        await _repository.saveUserProfile(_profile!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates editable profile fields
  Future<bool> updateProfileDetails({
    required String fullName,
    required String age,
    required bool showAge,
    required bool showGender,
    required bool showNationality,
    required String location,
    required bool showLocation,
    required String occupation,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _profile == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updated = _profile!.copyWith(
        fullName: fullName,
        age: age,
        showAge: showAge,
        showGender: showGender,
        showNationality: showNationality,
        location: location,
        showLocation: showLocation,
        occupation: occupation,
      );

      await _repository.saveUserProfile(updated);
      _profile = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Uploads custom profile picture to Firebase Storage and saves URL
  Future<bool> uploadProfilePicture(File imageFile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _profile == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final downloadUrl = await _repository.uploadProfileImage(uid, imageFile);
      final updated = _profile!.copyWith(profileImageUrl: downloadUrl);
      await _repository.saveUserProfile(updated);
      _profile = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Removes custom profile picture, reverting to selected character face avatar
  Future<bool> removeProfilePicture() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _profile == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteProfileImage(uid);
      final updated = _profile!.copyWith(profileImageUrl: '');
      await _repository.saveUserProfile(updated);
      _profile = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates visibility settings only
  Future<void> updateVisibility({
    bool? showAge,
    bool? showGender,
    bool? showNationality,
    bool? showLocation,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _profile == null) return;

    final updated = _profile!.copyWith(
      showAge: showAge ?? _profile!.showAge,
      showGender: showGender ?? _profile!.showGender,
      showNationality: showNationality ?? _profile!.showNationality,
      showLocation: showLocation ?? _profile!.showLocation,
    );

    _profile = updated;
    notifyListeners();
    await _repository.saveUserProfile(updated);
  }
}
