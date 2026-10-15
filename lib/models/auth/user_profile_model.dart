// =========================================================================
// 📄 FILE: user_profile_model.dart
// ROLE: User Profile Blueprint Model for Firestore Database with Visibility & Level
// =========================================================================

class UserProfileModel {
  final String uid;
  final String fullName; // username / displayName
  final String email;
  final String registeredCity;
  final String gender;
  final bool showGender;
  final String nationality;
  final bool showNationality;
  final String age;
  final bool showAge;
  final String location;
  final bool showLocation;
  final String occupation;
  final String profileImageUrl;
  final String selectedCharacter;
  final String selectedCharacterImage;
  final int currentLevel; // level
  final int experiencePoints; // experience
  final int followersCount;
  final int followingCount;
  final double bedalTokensBalance;
  final String createdAt;
  final String updatedAt;

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

/// Avatar resolver utility function returning custom image, character asset, or fallback default.
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
