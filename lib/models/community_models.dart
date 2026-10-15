// =========================================================================
// 📄 FILE: community_models.dart
// ROLE: Data Models for Skill Reels, Café Wall Posts, Workshops & Notices
// =========================================================================

class SkillReelModel {
  final String id;
  final String uid;
  final String authorName;
  final String caption;
  final String meetupTimings;
  final double bedalHoursRequired;
  final String meetupRestriction; // 'Girls Only', 'Boys Only', 'Open to All'
  final String videoUrl;
  final DateTime createdAt;

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

class CafePostModel {
  final String id;
  final String uid;
  final String authorName;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;

  const CafePostModel({
    required this.id,
    required this.uid,
    required this.authorName,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
  });

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

class WorkshopModel {
  final String id;
  final String hostUid;
  final String hostName;
  final String topic;
  final String date;
  final String time;
  final String venueLocation;
  final int maxStudents; // capped at 5
  final DateTime createdAt;

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

class NoticeCardModel {
  final String id;
  final String peerName;
  final String requestedSkill;
  final String city;
  final String status;
  final DateTime createdAt;

  const NoticeCardModel({
    required this.id,
    required this.peerName,
    required this.requestedSkill,
    required this.city,
    required this.status,
    required this.createdAt,
  });

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
