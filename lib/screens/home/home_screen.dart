import 'package:flutter/material.dart';
import 'widgets/user_info_overlay.dart';
import 'widgets/video_feed.dart';
import 'widgets/right_action_button.dart';
import '../skill_video/skill_post_details.dart';

// =========================================================================
// FILE: home_screen.dart
// ROLE: Main Discovery Feed View
// =========================================================================

class HomeScreen extends StatefulWidget {
  final bool isActive;

  const HomeScreen({
    super.key,
    this.isActive = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  final List<String> _videoAssets = [
    'assets/videos/home_sample.mp4',
    'assets/videos/home_sample.mp4',
    'assets/videos/home_sample.mp4',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F5EF),
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        pageSnapping: true,
        itemCount: _videoAssets.length,

        itemBuilder: (context, index) {
          return Column(
            children: [
              // ======================================================
              // TOP SNAPPING GAP
              // ======================================================
              Container(
                height: 14,
                color: const Color(0xFFF8F5EF),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // ======================================================
                    // VIDEO
                    // ======================================================

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SkillPostDetails(
                                  videoAsset: _videoAssets[index],
                                ),
                          ),
                        );
                      },
                      child: VideoFeed(
                        videoAsset: _videoAssets[index],
                        isActive: widget.isActive,
                      ),
                    ),

                    // ======================================================
                    // RIGHT ACTION BUTTONS
                    // ======================================================

                    const Positioned(
                      right: 12,
                      bottom: 155,
                      child: RightActionButtons(),
                    ),

                    // ======================================================
                    // USER INFORMATION
                    // ======================================================

                    const Positioned(
                      bottom: 30,
                      left: 16,
                      right: 70,
                      child: UserInfoOverlay(),
                    ),
                  ],
                ),
              ),
              // ======================================================
              // SNAPPING GAP (Header Colored Seam)
              // =============-========================================
              Container(
                height: 14,
                color: const Color(0xFFF8F5EF),
              ),
            ],
          );
        },
      ),
    );
  }
}