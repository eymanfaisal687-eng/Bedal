import 'package:flutter/material.dart';
import 'skill_detail_screen.dart';

// ========================================================================
// 📄 FILE: skill_card.dart
// PURPOSE: A single premium skill card for the Trending Skills section.
// ========================================================================

class SkillCard extends StatelessWidget {
  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.activeCount,
    this.rank,
  });

  final IconData icon;
  final String title;
  final String activeCount;
  final int? rank;

  static const Color gold = Color(0xFFC5A059);
  static const Color darkCard = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SkillDetailScreen(skillName: title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP-LEFT ICON
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: gold.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: gold,
                        size: 16,
                      ),
                    ),
                    
                    const Spacer(),

                    // 2. MAIN TEXT (TITLE)
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 3. ACTIVITY METRIC
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF49C774),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            activeCount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. RIGHT CHEVRON
              Positioned(
                top: 12,
                right: 8,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 18,
                ),
              ),

              // 5. OPTIONAL RANK
              if (rank != null)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      color: gold.withValues(alpha: 0.2),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
