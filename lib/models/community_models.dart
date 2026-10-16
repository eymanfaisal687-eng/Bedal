// =========================================================================
// FILE: community_models.dart
// ROLE: Data Models for Skill Reels, Cafe Wall Posts, Workshops & Notices
// =========================================================================

/// Data model for short skill video reels.
class SkillReelModel {
  final String id; // Unique reel document ID
  final String uid; // Author user ID
  final String authorName; // Author display name
  final String caption; // Reel video caption text
  final String meetupTimings; // Preferred meetup availability
  final double bedalHoursRequired; // Duration cost in Bedal Hours
  final String meetupRestriction; // Audience filter restriction ('Girls Only', 'Boys Only', 'Open to All')
  final String videoUrl; // Hosted video URL
  final DateTime createdAt; // Creation timestamp

  const SkillReelModel({
    required this.id,
    required this.uid,
    required this.authorName,
    required this.caption,
    required this.meetupTimings,
    required this.bedalHoursRequired,
    required this.meetupRestriction,
    required this.videoUrl,
    required this.createdAt,
  });

  /// Converts the reel object into a Firestore Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'authorName': authorName,
      'caption': caption,
      'meetupTimings': meetupTimings,
      'bedalHoursRequired': bedalHoursRequired,
      'meetupRestriction': meetupRestriction,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Data model for community cafe wall messages.
class CafePostModel {
  final String id; // Post document ID
  final String uid; // Author user ID
  final String authorName; // Author display name
  final String content; // Message content text
  final String? mediaUrl; // Optional attached media URL
  final DateTime createdAt; // Creation timestamp

  const CafePostModel({
    required this.id,
    required this.uid,
    required this.authorName,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
  });

  /// Converts the cafe post object into a Firestore Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'authorName': authorName,
      'content': content,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Data model for group learning workshops.
class WorkshopModel {
  final String id; // Workshop document ID
  final String hostUid; // Workshop host user ID
  final String hostName; // Host display name
  final String topic; // Learning topic title
  final String date; // Event date string
  final String time; // Event time string
  final String venueLocation; // Physical venue address
  final int maxStudents; // Student capacity limit (max 5)
  final DateTime createdAt; // Creation timestamp

  const WorkshopModel({
    required this.id,
    required this.hostUid,
    required this.hostName,
    required this.topic,
    required this.date,
    required this.time,
    required this.venueLocation,
    required this.maxStudents,
    required this.createdAt,
  });

  /// Converts the workshop object into a Firestore Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hostUid': hostUid,
      'hostName': hostName,
      'topic': topic,
      'date': date,
      'time': time,
      'venueLocation': venueLocation,
      'maxStudents': maxStudents,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Data model for community notice board request cards.
class NoticeCardModel {
  final String id; // Notice card ID
  final String peerName; // Peer display name
  final String requestedSkill; // Skill requested
  final String city; // Hub city location
  final String status; // Notice status ('Open', 'Matched', 'Closed')
  final DateTime createdAt; // Creation timestamp

  const NoticeCardModel({
    required this.id,
    required this.peerName,
    required this.requestedSkill,
    required this.city,
    required this.status,
    required this.createdAt,
  });

  /// Converts notice card object into a Firestore Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'peerName': peerName,
      'requestedSkill': requestedSkill,
      'city': city,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory constructor to instantiate a notice card from Firestore snapshot data.
  factory NoticeCardModel.fromMap(Map<String, dynamic> map, String docId) {
    return NoticeCardModel(
      id: docId,
      peerName: map['peerName'] ?? 'Bedal Student',
      requestedSkill: map['requestedSkill'] ?? 'Skill Swap',
      city: map['city'] ?? 'Islamabad',
      status: map['status'] ?? 'Open',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
