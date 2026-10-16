// =========================================================================
// FILE: social_repository.dart
// ROLE: Firestore Repository for Social Connections (Follow/Unfollow & Counts)
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository managing social relationships (followers/following) and counters in Firestore.
class SocialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Follows a target user using a Firestore batched write to update relationships and counts atomically.
  Future<void> followUser(String currentUid, String targetUid) async {
    if (currentUid == targetUid) {
      throw Exception('Users cannot follow themselves.');
    }

    try {
      final DocumentReference followerRef =
          _firestore.collection('users').doc(targetUid).collection('followers').doc(currentUid);
      final DocumentReference followingRef =
          _firestore.collection('users').doc(currentUid).collection('following').doc(targetUid);

      final DocumentSnapshot followerSnap = await followerRef.get();
      if (followerSnap.exists) {
        return; // Relationship already exists
      }

      final WriteBatch batch = _firestore.batch();
      batch.set(followerRef, {'timestamp': FieldValue.serverTimestamp()});
      batch.set(followingRef, {'timestamp': FieldValue.serverTimestamp()});

      // Increment social counters on both profiles
      batch.update(_firestore.collection('users').doc(targetUid), {'followersCount': FieldValue.increment(1)});
      batch.update(_firestore.collection('users').doc(currentUid), {'followingCount': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  /// Removes follow relationship and decrements social counters atomically.
  Future<void> unfollowUser(String currentUid, String targetUid) async {
    try {
      final DocumentReference followerRef =
          _firestore.collection('users').doc(targetUid).collection('followers').doc(currentUid);
      final DocumentReference followingRef =
          _firestore.collection('users').doc(currentUid).collection('following').doc(targetUid);

      final DocumentSnapshot followerSnap = await followerRef.get();
      if (!followerSnap.exists) {
        return; // Relationship does not exist
      }

      final WriteBatch batch = _firestore.batch();
      batch.delete(followerRef);
      batch.delete(followingRef);

      // Decrement social counters on both profiles
      batch.update(_firestore.collection('users').doc(targetUid), {'followersCount': FieldValue.increment(-1)});
      batch.update(_firestore.collection('users').doc(currentUid), {'followingCount': FieldValue.increment(-1)});

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }
}
