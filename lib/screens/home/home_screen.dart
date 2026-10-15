import 'package:flutter/material.dart';
import 'widgets/user_info_overlay.dart';
import 'widgets/video_feed.dart';
import 'widgets/right_action_button.dart';
import '../skill_video/skill_post_details.dart';
import '../profile/tabs/cafe_wall_tab.dart';

// =========================================================================
// FILE: home_screen.dart
// ROLE: Main Discovery Feed View with Smooth Horizontal PageView & Real-time Draggable Floating Glass Selector
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
  int _selectedSection = 0; // 0 = Skill Videos, 1 = Café Wall
  final PageController _videoPageController = PageController();
  final PageController _sectionPageController = PageController(initialPage: 0);

  double _dragExtent = 0.0;

  final List<String> _videoAssets = [
    'assets/videos/home_sample.mp4',
    'assets/videos/home_sample.mp4',
    'assets/videos/home_sample.mp4',
  ];

  @override
  void dispose() {
    _videoPageController.dispose();
    _sectionPageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedSection = index;
    });
    _sectionPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details, double halfWidth) {
    if (halfWidth <= 0) return;
    setState(() {
      _dragExtent += details.delta.dx;
      _dragExtent = _dragExtent.clamp(-halfWidth, halfWidth);
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details, double halfWidth) {
    if (halfWidth <= 0) return;
    final threshold = halfWidth * 0.3;
    if (_dragExtent > threshold || details.velocity.pixelsPerSecond.dx < -300) {
      _onTabSelected(1);
    } else if (_dragExtent < -threshold || details.velocity.pixelsPerSecond.dx > 300) {
      _onTabSelected(0);
    }
    setState(() {
      _dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16171A), // Dark canvas background
      child: Stack(
        children: [
          // ======================================================
          // HORIZONTAL PAGE VIEW FOR REAL-TIME FINGER SLIDING
          // ======================================================
          Positioned.fill(
            child: PageView(
              controller: _sectionPageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedSection = index;
                });
              },
              children: [
                // Page 0: Skill Videos Feed
                PageView.builder(
                  controller: _videoPageController,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  pageSnapping: true,
                  itemCount: _videoAssets.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SkillPostDetails(
                                  videoAsset: _videoAssets[index],
                                ),
                              ),
                            );
                          },
                          child: VideoFeed(
                            videoAsset: _videoAssets[index],
                            isActive: widget.isActive && _selectedSection == 0,
                          ),
                        ),
                        const Positioned(
                          right: 12,
                          bottom: 155,
                          child: RightActionButtons(),
                        ),
                        const Positioned(
                          bottom: 30,
                          left: 16,
                          right: 70,
                          child: UserInfoOverlay(),
                        ),
                      ],
                    );
                  },
                ),

                // Page 1: Café Wall
                Container(
                  color: const Color(0xFFF8F5EF),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
                    child: const CafeWallsTab(),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // FLOATING GLASS SEGMENTED CONTROL LAYERED OVER TOP
          // ======================================================
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 290,
                child: _buildFloatingGlassSelector(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // FLOATING GLASS TAB SELECTOR WIDGET WITH REAL-TIME DRAG
  // ======================================================
  Widget _buildFloatingGlassSelector() {
    final bool isSkillVideosSelected = _selectedSection == 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final halfWidth = totalWidth / 2;

        double baseAlignment = isSkillVideosSelected ? -1.0 : 1.0;
        double dragOffset = (_dragExtent / halfWidth);
        double finalAlignment = (baseAlignment + dragOffset).clamp(-1.0, 1.0);

        return GestureDetector(
          onHorizontalDragUpdate: (details) => _handleHorizontalDragUpdate(details, halfWidth),
          onHorizontalDragEnd: (details) => _handleHorizontalDragEnd(details, halfWidth),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF16171A).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 1. SLIDING BORDERLESS GOLD HIGHLIGHT
                Align(
                  alignment: Alignment(finalAlignment, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC5A059),
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
                ),

                // 2. INTERACTIVE BUTTONS
                Positioned.fill(
                  child: Row(
                    children: [
                      // Tab 0: Skill Videos
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onTabSelected(0),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.movie_creation_outlined,
                                  size: 20,
                                  color: isSkillVideosSelected ? Colors.white : Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Skill Videos',
                                  style: TextStyle(
                                    color: isSkillVideosSelected ? Colors.white : Colors.white70,
                                    fontSize: 13,
                                    fontWeight: isSkillVideosSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Tab 1: Café Wall
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onTabSelected(1),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.coffee_outlined,
                                  size: 20,
                                  color: !isSkillVideosSelected ? Colors.white : Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Café Wall',
                                  style: TextStyle(
                                    color: !isSkillVideosSelected ? Colors.white : Colors.white70,
                                    fontSize: 13,
                                    fontWeight: !isSkillVideosSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
