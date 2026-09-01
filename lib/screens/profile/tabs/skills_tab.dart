import 'package:flutter/material.dart';

class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color cream = Color(0xFFF8F5EF);

  // ===============================================================
  // MAXIMUM NUMBER OF SKILL VIDEOS
  // ===============================================================

  static const int maxVideos = 4;

  // ===============================================================
  // TEMPORARY VIDEO DATA
  // ===============================================================

  static const List<SkillVideo> videos = [
    SkillVideo(
      title: 'Python Basics',
      description: 'Teaching beginners how to start coding.',
      category: 'Programming',
      views: '128',
      xp: '+50 XP',
      thumbnailIcon: Icons.code_rounded,
    ),
    SkillVideo(
      title: 'Figma UI Design',
      description: 'A quick look at my design workflow.',
      category: 'Design',
      views: '94',
      xp: '+50 XP',
      thumbnailIcon: Icons.design_services_rounded,
    ),
    SkillVideo(
      title: 'Padel Tips',
      description: 'Three simple tips for your next match.',
      category: 'Sports',
      views: '76',
      xp: '+30 XP',
      thumbnailIcon: Icons.sports_tennis_rounded,
    ),
    SkillVideo(
      title: 'Photography',
      description: 'How I capture Jeddah during golden hour.',
      category: 'Creative',
      views: '61',
      xp: '+40 XP',
      thumbnailIcon: Icons.camera_alt_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Safety check:
    // Even if more items are accidentally added later,
    // this widget will never display more than 4 videos.

    final visibleVideos = videos.take(maxVideos).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ===========================================================
        // SECTION HEADER
        // ===========================================================

        Row(
          children: [

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    'My Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: dark,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Show the community what you can do.',
                    style: TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),

            // Video limit

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${visibleVideos.length}/$maxVideos',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: gold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ===========================================================
        // VERTICAL VIDEO LIST
        // ===========================================================

        ...visibleVideos.asMap().entries.map(
              (entry) {
            final int index = entry.key;
            final SkillVideo video = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == visibleVideos.length - 1
                    ? 0
                    : 14,
              ),
              child: _SkillVideoCard(
                video: video,
                index: index,
                onTap: () {
                  _openVideo(context, video);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // ===============================================================
  // OPEN VIDEO
  // ===============================================================

  void _openVideo(
      BuildContext context,
      SkillVideo video,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: dark,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Video placeholder

                AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF30302E),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    video.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
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

// ===================================================================
// VIDEO CARD
// ===================================================================

class _SkillVideoCard extends StatelessWidget {
  final SkillVideo video;
  final int index;
  final VoidCallback onTap;

  const _SkillVideoCard({
    required this.video,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFC5A059).withValues(alpha: 0.13),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================================
              // VIDEO PREVIEW
              // =====================================================

              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [

                    // Placeholder background

                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFEADFCB),
                              Color(0xFFF8F5EF),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            video.thumbnailIcon,
                            size: 58,
                            color: const Color(0xFFC5A059)
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),

                    // Dark gradient

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.30),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Play button

                    Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFFC5A059),
                          size: 32,
                        ),
                      ),
                    ),

                    // Skill category

                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          video.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF25231F),
                          ),
                        ),
                      ),
                    ),

                    // Video number

                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5A059),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // VIDEO INFORMATION
              // =====================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  13,
                  15,
                  15,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Text(
                            video.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF25231F),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC5A059)
                                .withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            video.xp,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC5A059),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      video.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF777269),
                      ),
                    ),

                    const SizedBox(height: 11),

                    Row(
                      children: [

                        const Icon(
                          Icons.visibility_outlined,
                          size: 15,
                          color: Color(0xFF9B968D),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '${video.views} views',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9B968D),
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: Color(0xFFC5A059),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// SKILL VIDEO MODEL
// ===================================================================

class SkillVideo {
  final String title;
  final String description;
  final String category;
  final String views;
  final String xp;
  final IconData thumbnailIcon;

  const SkillVideo({
    required this.title,
    required this.description,
    required this.category,
    required this.views,
    required this.xp,
    required this.thumbnailIcon,
  });
}
