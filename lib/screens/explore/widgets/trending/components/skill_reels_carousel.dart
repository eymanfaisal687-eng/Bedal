import 'package:flutter/material.dart';

// ========================================================================
// 📄 FILE: skill_reels_carousel.dart
// PURPOSE: A premium horizontal carousel showing active reels for a skill.
// ========================================================================

class SkillReelsCarousel extends StatelessWidget {
  const SkillReelsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Active Skill Reels',
            style: TextStyle(
              color: Color(0xFF1A1B1E),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return _ReelCard(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _ReelCard extends StatelessWidget {
  final int index;
  const _ReelCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/seed/${index + 40}/300/500',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          // User Info
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/${index + 10}/100/100',
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '@creator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Play Icon
          const Center(
            child: Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.white70,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
