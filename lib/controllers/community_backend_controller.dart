// =========================================================================
// 📄 FILE: community_backend_controller.dart
// ROLE: Firestore Backend Controller for Community Actions (Reels, Café Wall, Workshops, Notices)
// =========================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:bedal/models/community_models.dart';

class CommunityBackendController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Save Skill Reel to 'skill_reels' collection
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
      debugPrint('✅ Skill reel posted successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error posting skill reel: $e');
      return false;
    }
  }

  // 2. Save Café Post to 'cafe_wall_posts' collection
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
      debugPrint('✅ Café wall post saved successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error posting to café wall: $e');
      return false;
    }
  }

  // 3. Save Workshop to 'group_workshops' collection
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
        maxStudents: maxStudents > 5 ? 5 : maxStudents, // capped at 5
        createdAt: DateTime.now(),
      );

      await docRef.set(workshop.toMap());
      debugPrint('✅ Group workshop created successfully: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error creating workshop: $e');
      return false;
    }
  }

  // 4. Stream Notice Board Cards from 'hubs_notice_board' based on city
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
