// =========================================================================
// FILE: schedule_repository.dart
// ROLE: Firestore Repository for Availability Slots, Meetup Requests & Bookings
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_models.dart';

/// Repository managing availability slots, meetup requests, and atomic booking transactions.
class ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves a new availability slot to the 'availability' Firestore collection.
  Future<void> addAvailabilitySlot(AvailabilitySlotModel slot) async {
    try {
      await _firestore.collection('availability').doc(slot.id).set(slot.toMap());
    } catch (e) {
      throw Exception('Failed to add availability slot: $e');
    }
  }

  /// Deletes an availability slot from Firestore by slot ID.
  Future<void> deleteAvailabilitySlot(String slotId) async {
    try {
      await _firestore.collection('availability').doc(slotId).delete();
    } catch (e) {
      throw Exception('Failed to delete availability slot: $e');
    }
  }

  /// Retrieves availability slots for a specific user ID from Firestore.
  Future<List<AvailabilitySlotModel>> getAvailabilityForUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('availability')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => AvailabilitySlotModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch availability: $e');
    }
  }

  /// Sends a meetup request document to the 'meetupRequests' Firestore collection.
  Future<void> sendMeetupRequest(MeetupRequestModel request) async {
    try {
      await _firestore.collection('meetupRequests').doc(request.id).set(request.toMap());
    } catch (e) {
      throw Exception('Failed to send meetup request: $e');
    }
  }

  /// Atomic transaction preventing double-booking: verifies slot availability before confirming booking.
  Future<bool> confirmBookingTransaction(String requestId, String slotId) async {
    try {
      return await _firestore.runTransaction<bool>((transaction) async {
        final DocumentReference slotRef = _firestore.collection('availability').doc(slotId);
        final DocumentSnapshot slotSnap = await transaction.get(slotRef);

        if (!slotSnap.exists) {
          return false;
        }

        final Map<String, dynamic> data = slotSnap.data() as Map<String, dynamic>;
        final bool isAvailable = data['isAvailable'] ?? false;

        if (!isAvailable) {
          return false; // Slot already booked or unavailable
        }

        // Mark slot as unavailable atomically
        transaction.update(slotRef, {'isAvailable': false});

        // Update meetup request status to accepted
        final DocumentReference reqRef = _firestore.collection('meetupRequests').doc(requestId);
        transaction.update(reqRef, {'status': MeetupStatus.accepted.name});

        // Create confirmed booking document record
        final DocumentReference bookingRef = _firestore.collection('bookings').doc();
        transaction.set(bookingRef, {
          'id': bookingRef.id,
          'slotId': slotId,
          'participant1': data['userId'],
          'participant2': data['requesterId'] ?? '',
          'date': data['date'],
          'timeSlot': '${data['startTime']} – ${data['endTime']}',
          'createdAt': FieldValue.serverTimestamp(),
        });

        return true;
      });
    } catch (e) {
      throw Exception('Booking transaction failed: $e');
    }
  }
}
