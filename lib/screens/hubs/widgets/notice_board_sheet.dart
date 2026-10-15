// =========================================================================
// 📄 FILE: notice_board_sheet.dart
// ROLE: Slide-up Sheet streaming live open 1-on-1 swap requests matching Explore colors
// =========================================================================

import 'package:flutter/material.dart';
import 'package:bedal/controllers/community_backend_controller.dart';
import 'package:bedal/models/community_models.dart';

const kPrimaryColor = Color(0xFFC5A059);
const kExploreBg = Color(0xFFF1EEE7);
const kCardBgColor = Color(0xFFFFFFFF);
const kCharcoal = Color(0xFF16171A);
const kMutedText = Color(0xFF7A7368);
const kDividerColor = Color(0xFFE3E0D6);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class NoticeBoardSheet extends StatelessWidget {
  final String activeCity;

  const NoticeBoardSheet({
    super.key,
    this.activeCity = 'Islamabad',
  });

  @override
  Widget build(BuildContext context) {
    final CommunityBackendController controller = CommunityBackendController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: kExploreBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kCharcoal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📢 Notice Board • Find a Learner',
                style: TextStyle(
                  color: kCharcoal,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: kPlusJakartaSans,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  activeCity,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<NoticeCardModel>>(
              stream: controller.streamNoticeBoard(city: activeCity),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
                }
                
                final notices = snapshot.data ?? [];
                
                final displayNotices = notices.isNotEmpty ? notices : [
                  NoticeCardModel(id: '1', peerName: 'Omar K.', requestedSkill: 'Flutter State Management', city: activeCity, status: 'Open', createdAt: DateTime.now()),
                  NoticeCardModel(id: '2', peerName: 'Sara Ali', requestedSkill: 'Figma Auto-Layout', city: activeCity, status: 'Open', createdAt: DateTime.now()),
                ];

                return ListView.builder(
                  itemCount: displayNotices.length,
                  itemBuilder: (context, index) {
                    final notice = displayNotices[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kDividerColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            child: Icon(Icons.school_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice.peerName,
                                  style: const TextStyle(
                                    color: kCharcoal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: kPlusJakartaSans,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Seeking: ${notice.requestedSkill}',
                                  style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: kPlusJakartaSans,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Connecting with ${notice.peerName} for swap...')),
                              );
                            },
                            child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
