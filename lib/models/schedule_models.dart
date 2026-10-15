// =========================================================================
// 📄 FILE: schedule_models.dart
// PURPOSE: Data models for availability time slots and meetup requests
// =========================================================================

class AvailabilitySlotModel {
  final String id;
  final String userId;
  final DateTime date;
  final String startTime; // e.g. "10:00 AM"
  final String endTime;   // e.g. "12:00 PM"
  final bool isAvailable; // true = Available, false = Busy/Unavailable
  final bool isRecurring;

  AvailabilitySlotModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.isRecurring = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'isRecurring': isRecurring,
    };
  }

  factory AvailabilitySlotModel.fromMap(Map<String, dynamic> map) {
    return AvailabilitySlotModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      startTime: map['startTime'] ?? '10:00 AM',
      endTime: map['endTime'] ?? '12:00 PM',
      isAvailable: map['isAvailable'] ?? true,
      isRecurring: map['isRecurring'] ?? false,
    );
  }
}

enum MeetupStatus { pending, accepted, declined, cancelled }

class MeetupRequestModel {
  final String id;
  final String senderUid;
  final String senderName;
  final String senderAvatar;
  final String receiverUid;
  final String slotId;
  final DateTime date;
  final String timeSlot;
  final String purpose;
  final String? message;
  final MeetupStatus status;
  final DateTime timestamp;

  MeetupRequestModel({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.senderAvatar,
    required this.receiverUid,
    required this.slotId,
    required this.date,
    required this.timeSlot,
    required this.purpose,
    this.message,
    this.status = MeetupStatus.pending,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderUid': senderUid,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'receiverUid': receiverUid,
      'slotId': slotId,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'purpose': purpose,
      'message': message,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MeetupRequestModel.fromMap(Map<String, dynamic> map) {
    return MeetupRequestModel(
      id: map['id'] ?? '',
      senderUid: map['senderUid'] ?? '',
      senderName: map['senderName'] ?? '',
      senderAvatar: map['senderAvatar'] ?? '',
      receiverUid: map['receiverUid'] ?? '',
      slotId: map['slotId'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      timeSlot: map['timeSlot'] ?? '',
      purpose: map['purpose'] ?? '',
      message: map['message'],
      status: MeetupStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => MeetupStatus.pending,
      ),
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
    );
  }
}
