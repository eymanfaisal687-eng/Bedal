// =========================================================================
// FILE: blocked_users_repository.dart
// ROLE: Firestore Repository for User Blocking & Moderation Operations
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository handling Firestore operations for blocking and unblocking users.
class BlockedUsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Blocks a user by adding their UID to the current user's blockedUsers sub-collection.
  Future<void> blockUser(String currentUid, String blockedUid) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUid)
          .collection('blockedUsers')
          .doc(blockedUid)
          .set({'timestamp': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  /// Removes a user from the current user's blockedUsers sub-collection.
  Future<void> unblockUser(String currentUid, String blockedUid) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUid)
          .collection('blockedUsers')
          .doc(blockedUid)
          .delete();
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  /// Retrieves the list of blocked user UIDs for the current user.
  Future<List<String>> getBlockedUsers(String currentUid) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUid)
          .collection('blockedUsers')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('Failed to fetch blocked users: $e');
    }
  }
}
