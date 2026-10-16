// =========================================================================
// FILE: schedule_models.dart
// ROLE: Data Models for Availability Slots and Meetup Requests
// =========================================================================

/// Model representing a user's calendar availability time slot.
class AvailabilitySlotModel {
  final String id; // Unique slot ID
  final String userId; // User ID owner
  final DateTime date; // Slot date
  final String startTime; // Start time string (e.g., "10:00 AM")
  final String endTime; // End time string (e.g., "12:00 PM")
  final bool isAvailable; // Availability status flag
  final bool isRecurring; // Recurring schedule flag

  AvailabilitySlotModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.isRecurring = false,
  });

  /// Converts the slot object into a Map.
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

  /// Instantiates an [AvailabilitySlotModel] from a Map.
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

/// Status enumeration for peer meetup requests.
enum MeetupStatus { pending, accepted, declined, cancelled }

/// Model representing a peer meetup booking request.
class MeetupRequestModel {
  final String id; // Unique request ID
  final String senderUid; // Sender user ID
  final String senderName; // Sender display name
  final String senderAvatar; // Sender avatar image URL or asset
  final String receiverUid; // Receiver user ID
  final String slotId; // Requested availability slot ID
  final DateTime date; // Request date
  final String timeSlot; // Formatted time window
  final String purpose; // Meetup purpose description
  final String? message; // Optional personal note message
  final MeetupStatus status; // Request lifecycle status
  final DateTime timestamp; // Creation timestamp

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

  /// Converts the request object into a Map.
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

  /// Instantiates a [MeetupRequestModel] from a Map.
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
