// =========================================================================
// FILE: user_profile_model.dart
// ROLE: User Profile Blueprint Data Model for Firestore
// =========================================================================

/// Data model representing a user profile with personal info, stats, and privacy toggles.
class UserProfileModel {
  final String uid; // Unique Firebase Authentication User ID
  final String fullName; // Display name
  final String email; // Account email address
  final String registeredCity; // Primary city location
  final String gender; // Gender identity
  final bool showGender; // Privacy toggle for public gender display
  final String nationality; // Country nationality
  final bool showNationality; // Privacy toggle for public nationality display
  final String age; // User age string
  final bool showAge; // Privacy toggle for public age display
  final String location; // Area or neighborhood location
  final bool showLocation; // Privacy toggle for public location display
  final String occupation; // Student or professional role
  final String profileImageUrl; // Custom profile image URL from Firebase Storage
  final String selectedCharacter; // Avatar character identifier key
  final String selectedCharacterImage; // Avatar asset image path
  final int currentLevel; // Gamified user level
  final int experiencePoints; // Experience points (XP)
  final int followersCount; // Total followers count
  final int followingCount; // Total following count
  final double bedalTokensBalance; // Bedal Tokens wallet balance
  final String createdAt; // ISO timestamp string of profile creation
  final String updatedAt; // ISO timestamp string of last profile update

  UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.registeredCity,
    this.gender = 'Man',
    this.showGender = true,
    this.nationality = 'Saudi',
    this.showNationality = true,
    this.age = '24',
    this.showAge = true,
    this.location = 'Al Rawdah, Jeddah',
    this.showLocation = true,
    this.occupation = 'Student',
    this.profileImageUrl = '',
    this.selectedCharacter = 'saudi_man',
    this.selectedCharacterImage = '',
    this.currentLevel = 1,
    this.experiencePoints = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.bedalTokensBalance = 1.0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  /// Converts the profile instance into a JSON Map for Firestore persistence.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'registeredCity': registeredCity,
      'gender': gender,
      'showGender': showGender,
      'nationality': nationality,
      'showNationality': showNationality,
      'age': age,
      'showAge': showAge,
      'location': location,
      'showLocation': showLocation,
      'occupation': occupation,
      'profileImageUrl': profileImageUrl,
      'selectedCharacter': selectedCharacter,
      'selectedCharacterImage': selectedCharacterImage,
      'currentLevel': currentLevel,
      'experiencePoints': experiencePoints,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'bedalTokensBalance': bedalTokensBalance,
      'createdAt': createdAt.isEmpty ? DateTime.now().toIso8601String() : createdAt,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Instantiates a [UserProfileModel] from a Firestore document snapshot map.
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? map['username'] ?? map['displayName'] ?? '',
      email: map['email'] ?? '',
      registeredCity: map['registeredCity'] ?? 'Unknown City',
      gender: map['gender'] ?? 'Man',
      showGender: map['showGender'] ?? true,
      nationality: map['nationality'] ?? 'Saudi',
      showNationality: map['showNationality'] ?? true,
      age: map['age']?.toString() ?? '24',
      showAge: map['showAge'] ?? true,
      location: map['location'] ?? 'Al Rawdah, Jeddah',
      showLocation: map['showLocation'] ?? true,
      occupation: map['occupation'] ?? 'Student',
      profileImageUrl: map['profileImageUrl'] ?? '',
      selectedCharacter: map['selectedCharacter'] ?? 'saudi_man',
      selectedCharacterImage: map['selectedCharacterImage'] ?? '',
      currentLevel: map['currentLevel'] ?? map['level'] ?? 1,
      experiencePoints: map['experiencePoints'] ?? map['experience'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      bedalTokensBalance: (map['bedalTokensBalance'] ?? 1.0).toDouble(),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  /// Creates a copy of [UserProfileModel] with updated field values.
  UserProfileModel copyWith({
    String? fullName,
    String? age,
    bool? showAge,
    bool? showGender,
    bool? showNationality,
    String? location,
    bool? showLocation,
    String? occupation,
    String? profileImageUrl,
    String? selectedCharacter,
    String? selectedCharacterImage,
  }) {
    return UserProfileModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email,
      registeredCity: registeredCity,
      gender: gender,
      showGender: showGender ?? this.showGender,
      nationality: nationality,
      showNationality: showNationality ?? this.showNationality,
      age: age ?? this.age,
      showAge: showAge ?? this.showAge,
      location: location ?? this.location,
      showLocation: showLocation ?? this.showLocation,
      occupation: occupation ?? this.occupation,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      selectedCharacterImage: selectedCharacterImage ?? this.selectedCharacterImage,
      currentLevel: currentLevel,
      experiencePoints: experiencePoints,
      followersCount: followersCount,
      followingCount: followingCount,
      bedalTokensBalance: bedalTokensBalance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Resolves avatar image asset path or network URL based on user profile preferences.
String resolveAvatarAssetOrUrl(UserProfileModel? profile) {
  if (profile != null && profile.profileImageUrl.trim().isNotEmpty) {
    return profile.profileImageUrl.trim();
  }
  final gender = (profile?.gender ?? 'Man').toLowerCase();
  final nationality = (profile?.nationality ?? 'Saudi').toLowerCase();

  if (gender.contains('woman') || gender.contains('female')) {
    if (nationality.contains('pakistani')) {
      return 'assets/images/profile/character_profile/female_characters/pakistani_women.png';
    } else {
      return 'assets/images/profile/character_profile/female_characters/saudi_women.png';
    }
  } else {
    if (nationality.contains('pakistani')) {
      return 'assets/images/profile/character_profile/male_characters/pakistani_man.png';
    } else {
      return 'assets/images/profile/character_profile/male_characters/saudi_man.png';
    }
  }
}
