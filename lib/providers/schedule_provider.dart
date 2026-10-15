import 'package:flutter/material.dart';
import '../models/schedule_models.dart';

// =========================================================================
// 📄 FILE: schedule_provider.dart
// PURPOSE: Provider for managing calendar availability slots and meetup requests
// =========================================================================

class ScheduleProvider extends ChangeNotifier {
  final List<AvailabilitySlotModel> _slots = [
    AvailabilitySlotModel(
      id: 'slot_1',
      userId: 'current_user',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '10:00 AM',
      endTime: '12:00 PM',
      isAvailable: true,
    ),
    AvailabilitySlotModel(
      id: 'slot_2',
      userId: 'current_user',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '12:00 PM',
      endTime: '2:00 PM',
      isAvailable: false, // Busy / Unavailable
    ),
    AvailabilitySlotModel(
      id: 'slot_3',
      userId: 'current_user',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '2:00 PM',
      endTime: '5:00 PM',
      isAvailable: true,
    ),
    AvailabilitySlotModel(
      id: 'slot_4',
      userId: 'other_user',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '11:00 AM',
      endTime: '1:00 PM',
      isAvailable: true,
    ),
    AvailabilitySlotModel(
      id: 'slot_5',
      userId: 'other_user',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '3:00 PM',
      endTime: '6:00 PM',
      isAvailable: true,
    ),
  ];

  final List<MeetupRequestModel> _requests = [];

  List<AvailabilitySlotModel> get slots => _slots;
  List<MeetupRequestModel> get requests => _requests;

  // Get slots for a specific user
  List<AvailabilitySlotModel> getSlotsForUser(String userId) {
    return _slots.where((s) => s.userId == userId).toList();
  }

  // PROTECTED PRIVACY: Public slots for visitors (never exposes private notes, only shows Available vs Unavailable)
  List<AvailabilitySlotModel> getPublicSlotsForUser(String userId) {
    return _slots.where((s) => s.userId == userId).toList();
  }

  void addSlot(AvailabilitySlotModel slot) {
    _slots.add(slot);
    notifyListeners();
  }

  void updateSlot(AvailabilitySlotModel updatedSlot) {
    final index = _slots.indexWhere((s) => s.id == updatedSlot.id);
    if (index != -1) {
      _slots[index] = updatedSlot;
      notifyListeners();
    }
  }

  void deleteSlot(String slotId) {
    _slots.removeWhere((s) => s.id == slotId);
    notifyListeners();
  }

  void sendMeetupRequest(MeetupRequestModel request) {
    _requests.add(request);
    notifyListeners();
  }

  void updateRequestStatus(String requestId, MeetupStatus status) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      final req = _requests[index];
      _requests[index] = MeetupRequestModel(
        id: req.id,
        senderUid: req.senderUid,
        senderName: req.senderName,
        senderAvatar: req.senderAvatar,
        receiverUid: req.receiverUid,
        slotId: req.slotId,
        date: req.date,
        timeSlot: req.timeSlot,
        purpose: req.purpose,
        message: req.message,
        status: status,
        timestamp: req.timestamp,
      );
      notifyListeners();
    }
  }
}
