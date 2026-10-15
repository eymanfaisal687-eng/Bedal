import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/location_service.dart';
import '../models/auth/user_profile_model.dart';
import '../models/coin_workshop_model.dart';

/// This class manages live form data, profile fields, gender, nationality, privacy toggles, blocked users, and auth sessions.
class SignupProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Live Form Field States
  String _fullName = '';
  String _invitationCode = '';
  String _email = '';
  String _password = '';
  String _gender = 'Man';          // 'Man' or 'Woman'
  String _nationality = 'Saudi';   // 'Saudi' or 'Pakistani'

  // 2. Profile & Editable States
  String _profileImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80';
  String _age = '24';
  String _location = 'Al Rawdah, Jeddah';
  String _occupation = 'Student';

  // 3. Privacy Controls
  bool _showAge = true;
  bool _showLocation = true;

  // 4. Blocked Users
  final List<String> _blockedUsers = ['blocked_user_1', 'spammer_99'];

  // 5. Status UI States
  bool _isLoading = false;
  String _errorMessage = '';
  final bool _isEmailVerified = false;

  // Hardcoded valid beta-testing invitation codes for Bedal
  final List<String> _validInvitationCodes = ['BEDAL100', 'CAMPUS2026', 'JEDDAH2026'];

  // --- Getters ---
  String get fullName => _fullName;
  String get invitationCode => _invitationCode;
  String get email => _email;
  String get password => _password;
  String get gender => _gender;
  String get nationality => _nationality;
  String get profileImageUrl => _profileImageUrl;
  String get age => _age;
  String get location => _location;
  String get occupation => _occupation;
  bool get showAge => _showAge;
  bool get showLocation => _showLocation;
  List<String> get blockedUsers => _blockedUsers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isEmailVerified => _isEmailVerified;

  // Bedal Coins Balance & Redemptions
  double _bedalCoins = 4.5;
  final List<CoinWorkshopModel> _redeemedWorkshops = [];

  double get bedalCoins => _bedalCoins;
  List<CoinWorkshopModel> get redeemedWorkshops => _redeemedWorkshops;

  bool redeemWorkshop(CoinWorkshopModel workshop) {
    if (_bedalCoins >= workshop.coinCost && workshop.remainingSeats > 0) {
      if (_redeemedWorkshops.any((w) => w.id == workshop.id)) {
        return false; // Already redeemed
      }
      _bedalCoins -= workshop.coinCost;
      workshop.remainingSeats -= 1;
      _redeemedWorkshops.add(workshop);
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- Setters & Updaters ---
  void updateFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void updateInvitationCode(String value) {
    _invitationCode = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void updateNationality(String value) {
    _nationality = value;
    notifyListeners();
  }

  void updateProfileImage(String url) {
    _profileImageUrl = url;
    notifyListeners();
  }

  void updateProfileDetails({
    required String fullName,
    required String gender,
    required String nationality,
    required String age,
    required String location,
    required String occupation,
  }) {
    _fullName = fullName;
    _gender = gender;
    _nationality = nationality;
    _age = age;
    _location = location;
    _occupation = occupation;
    notifyListeners();
  }

  void toggleShowAge(bool value) {
    _showAge = value;
    notifyListeners();
  }

  void toggleShowLocation(bool value) {
    _showLocation = value;
    notifyListeners();
  }

  void blockUser(String userId) {
    if (!_blockedUsers.contains(userId)) {
      _blockedUsers.add(userId);
      notifyListeners();
    }
  }

  void unblockUser(String userId) {
    _blockedUsers.remove(userId);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _fullName = '';
    _email = '';
    _password = '';
    notifyListeners();
  }

  // --- Core Backend Verification Functions ---
  bool verifyInvitationCode() {
    _errorMessage = '';

    if (_invitationCode.trim().isEmpty) {
      notifyListeners();
      return true;
    }

    if (!_validInvitationCodes.contains(_invitationCode.trim().toUpperCase())) {
      _errorMessage = 'Invalid invitation code. Please check with your campus Lead.';
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> executeRegistrationSequence() async {
    if (!verifyInvitationCode()) return;

    setLoading(true);
    clearError();

    try {
      User? newUser = await _authService.registerStudentWithEmail(
        email: _email,
        password: _password,
      );

      if (newUser != null) {
        debugPrint('Sequence complete. Awaiting user inbox validation verification.');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> executeRegistrationAndSaveProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String detectedCity = await _locationService.getDeviceCityName();
      _location = detectedCity;

      User? firebaseUser = await _authService.registerStudentWithEmail(
        email: _email,
        password: _password,
      );

      if (firebaseUser != null) {
        UserProfileModel newProfile = UserProfileModel(
          uid: firebaseUser.uid,
          fullName: _fullName.isNotEmpty ? _fullName : 'Ahmed',
          email: _email,
          registeredCity: detectedCity,
          gender: _gender,
          nationality: _nationality,
        );

        await _firestore.collection('users').doc(firebaseUser.uid).set(newProfile.toMap());
        debugPrint('Firestore: Secure user profile saved successfully for city: $detectedCity');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
