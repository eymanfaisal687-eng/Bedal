// =========================================================================
// FILE: community_backend_controller.dart
// ROLE: Firestore Backend Controller for Community Features
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:bedal/models/community_models.dart';

/// Backend controller managing community operations (Skill Reels, Cafe Wall, Workshops, Notices).
class CommunityBackendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Saves a new Skill Reel document to the 'skill_reels' Firestore collection.
  Future<bool> postSkillReel({
    required String caption,
    required String meetupTimings,
    required double bedalHoursRequired,
    required String meetupRestriction,
    required String videoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? 'anonymous_user';
      final authorName = user?.displayName ?? 'Bedal Creator';
      final docRef = _firestore.collection('skill_reels').doc();

      final reel = SkillReelModel(
        id: docRef.id,
        uid: uid,
        authorName: authorName,
        caption: caption,
        meetupTimings: meetupTimings,
        bedalHoursRequired: bedalHoursRequired,
        meetupRestriction: meetupRestriction,
        videoUrl: videoUrl,
        createdAt: DateTime.now(),
      );

      await docRef.set(reel.toMap());
      debugPrint('Skill reel posted successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('Error posting skill reel: $e');
      return false;
    }
  }

  /// Saves a new post document to the 'cafe_wall_posts' Firestore collection.
  Future<bool> postCafeWallMessage({
    required String content,
    String? mediaUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? 'anonymous_user';
      final authorName = user?.displayName ?? 'Bedal Member';
      final docRef = _firestore.collection('cafe_wall_posts').doc();

      final post = CafePostModel(
        id: docRef.id,
        uid: uid,
        authorName: authorName,
        content: content,
        mediaUrl: mediaUrl,
        createdAt: DateTime.now(),
      );

      await docRef.set(post.toMap());
      debugPrint('Cafe wall post saved successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('Error posting to cafe wall: $e');
      return false;
    }
  }

  /// Creates a new group workshop record capped at a maximum of 5 students per session.
  Future<bool> createWorkshop({
    required String topic,
    required String date,
    required String time,
    required String venueLocation,
    required int maxStudents,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? 'anonymous_mentor';
      final hostName = user?.displayName ?? 'Senior Mentor';
      final docRef = _firestore.collection('group_workshops').doc();

      final workshop = WorkshopModel(
        id: docRef.id,
        hostUid: uid,
        hostName: hostName,
        topic: topic,
        date: date,
        time: time,
        venueLocation: venueLocation,
        maxStudents: maxStudents > 5 ? 5 : maxStudents, // Enforce maximum 5 students limit
        createdAt: DateTime.now(),
      );

      await docRef.set(workshop.toMap());
      debugPrint('Group workshop created successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('Error creating workshop: $e');
      return false;
    }
  }

  /// Streams notice board entries from 'hubs_notice_board' filtered by user city.
  Stream<List<NoticeCardModel>> streamNoticeBoard({required String city}) {
    return _firestore
        .collection('hubs_notice_board')
        .where('city', isEqualTo: city)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoticeCardModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
