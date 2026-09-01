import 'package:flutter/material.dart';
import 'skill_card.dart';

// ========================================================================
// 📄 FILE: trending_skills_section.dart
// PURPOSE: Displays the trending skills grid with a premium Bedal header.
// ========================================================================

class TrendingSkillsSection extends StatelessWidget {
  const TrendingSkillsSection({super.key});

  static const Color primaryDark = Color(0xFF1A1B1E);
  static const Color secondaryMuted = Color(0xFF777269);
  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SECTION HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: gold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Trending Skills',
                        style: TextStyle(
                          color: primaryDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Popular right now in Jeddah',
                    style: TextStyle(
                      color: secondaryMuted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exploring all trending skills...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    const Text(
                      'See all',
                      style: TextStyle(
                        color: primaryDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: gold,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2. ACTIVITY INDICATOR STRIP
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primaryDark.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primaryDark.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: gold,
                  size: 16,
                ),
                const SizedBox(width: 10),
                const Text(
                  '1,240+ people are learning skills today',
                  style: TextStyle(
                    color: secondaryMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF49C774),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3. SKILLS GRID
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: const [
              SkillCard(
                icon: Icons.code_rounded,
                title: 'Python',
                activeCount: '128 active',
                rank: 1,
              ),
              SkillCard(
                icon: Icons.sports_tennis_rounded,
                title: 'Padel Tips',
                activeCount: '96 active',
                rank: 2,
              ),
              SkillCard(
                icon: Icons.design_services_rounded,
                title: 'Figma UI',
                activeCount: '87 active',
                rank: 3,
              ),
              SkillCard(
                icon: Icons.business_center_rounded,
                title: 'CV & Interview Prep',
                activeCount: '112 active',
                rank: 4,
              ),
              SkillCard(
                icon: Icons.extension_rounded,
                title: 'Chess Strategy',
                activeCount: '74 active',
                rank: 5,
              ),
              SkillCard(
                icon: Icons.restaurant_rounded,
                title: 'Local Culinary Arts',
                activeCount: '64 active',
                rank: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
