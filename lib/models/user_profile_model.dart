// =========================================================================
// 📄 FILE: user_profile_model.dart
// ROLE: User Profile Blueprint Model for Firestore Database
// =========================================================================

class UserProfileModel {
  final String uid;              // Unique Firebase Auth User ID
  final String fullName;         // Student's registered display name
  final String email;            // Student's email address
  final String registeredCity;   // User's selected campus city (e.g. Islamabad, Jeddah)
  final String gender;           // Man or Woman
  final String nationality;      // Saudi or Pakistani
  final int currentLevel;        // Gamified user level (default: 1)
  final int experiencePoints;    // Campus XP rewards (default: 0)

  const UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.registeredCity,
    this.gender = 'Man',
    this.nationality = 'Saudi',
    this.currentLevel = 1,
    this.experiencePoints = 0,
  });

  /// Converts our Dart object into a JSON Map so Firebase Firestore can save it to the cloud instantly.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'registeredCity': registeredCity,
      'gender': gender,
      'nationality': nationality,
      'currentLevel': currentLevel,
      'experiencePoints': experiencePoints,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates a UserProfileModel object from a Firestore database document snapshot.
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      registeredCity: map['registeredCity'] ?? '',
      gender: map['gender'] ?? 'Man',
      nationality: map['nationality'] ?? 'Saudi',
      currentLevel: map['currentLevel'] ?? 1,
      experiencePoints: map['experiencePoints'] ?? 0,
    );
  }
}
