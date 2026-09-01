import 'package:flutter/material.dart';
import '../../explore_screen.dart';
import 'leaderboard_card.dart';

// ========================================================================
// 📄 FILE: leaderboard_section.dart
// PURPOSE: Creates the leaderboard section.
// ========================================================================

class LeaderboardUser {
  final String name;
  final String identity;
  final String imagePath;
  final String metric;
  final String rating;
  final String skill;
  final int taughtHours;
  final int learnedHours;
  final int xp;

  const LeaderboardUser({
    required this.name,
    required this.identity,
    required this.imagePath,
    required this.metric,
    required this.rating,
    required this.skill,
    required this.taughtHours,
    required this.learnedHours,
    required this.xp,
  });
}

class LeaderboardSection extends StatefulWidget {
  final ExploreMode selectedMode;

  const LeaderboardSection({
    super.key,
    required this.selectedMode,
  });

  @override
  State<LeaderboardSection> createState() => _LeaderboardSectionState();
}

class _LeaderboardSectionState extends State<LeaderboardSection> {
  bool _isExpanded = false;

  static const Color primaryDark = Color(0xFF1A1B1E);
  static const Color secondaryMuted = Color(0xFF5A5752); // Slightly darker for better readability
  static const Color gold = Color(0xFFC5A059);
  static const Color silver = Color(0xFFB8BCC3);
  static const Color platinum = Color(0xFFD5D0C5);

  final List<LeaderboardUser> _mentors = const [
    LeaderboardUser(
      name: "Reem A.",
      identity: "Effat Univ.",
      imagePath: 'assets/images/character_images/reem.png',
      metric: "42 Hours",
      rating: "5.0",
      skill: "UX/UI Design",
      taughtHours: 42,
      learnedHours: 10,
      xp: 850,
    ),
    LeaderboardUser(
      name: "Sara M.",
      identity: "KAUST",
      imagePath: 'assets/images/character_images/reem.png',
      metric: "38 Hours",
      rating: "4.9",
      skill: "Machine Learning",
      taughtHours: 38,
      learnedHours: 15,
      xp: 720,
    ),
    LeaderboardUser(
      name: "Omar K.",
      identity: "U. of Jeddah",
      imagePath: 'assets/images/character_images/omar.png',
      metric: "34 Hours",
      rating: "4.8",
      skill: "Product Management",
      taughtHours: 34,
      learnedHours: 5,
      xp: 680,
    ),
    LeaderboardUser(
      name: "Faisal T.",
      identity: "KAU",
      imagePath: "",
      metric: "28 Hours",
      rating: "4.9",
      skill: "Software Engineering",
      taughtHours: 28,
      learnedHours: 12,
      xp: 450,
    ),
    LeaderboardUser(
      name: "Layan B.",
      identity: "Dar Al-Hekma",
      imagePath: "",
      metric: "22 Hours",
      rating: "4.7",
      skill: "Graphic Design",
      taughtHours: 22,
      learnedHours: 8,
      xp: 320,
    ),
    LeaderboardUser(
      name: "Ahmed S.",
      identity: "Prince Sultan Univ.",
      imagePath: "",
      metric: "20 Hours",
      rating: "4.6",
      skill: "Cyber Security",
      taughtHours: 20,
      learnedHours: 5,
      xp: 290,
    ),
    LeaderboardUser(
      name: "Nora F.",
      identity: "PNU",
      imagePath: "",
      metric: "18 Hours",
      rating: "4.5",
      skill: "Web Development",
      taughtHours: 18,
      learnedHours: 4,
      xp: 250,
    ),
    LeaderboardUser(
      name: "Khalid R.",
      identity: "KFUPM",
      imagePath: "",
      metric: "16 Hours",
      rating: "4.8",
      skill: "Data Science",
      taughtHours: 16,
      learnedHours: 20,
      xp: 210,
    ),
    LeaderboardUser(
      name: "Mona G.",
      identity: "Alfaisal Univ.",
      imagePath: "",
      metric: "14 Hours",
      rating: "4.4",
      skill: "App Development",
      taughtHours: 14,
      learnedHours: 6,
      xp: 180,
    ),
    LeaderboardUser(
      name: "Zaid W.",
      identity: "Al-Yamamah Univ.",
      imagePath: "",
      metric: "12 Hours",
      rating: "4.3",
      skill: "Blockchain",
      taughtHours: 12,
      learnedHours: 3,
      xp: 150,
    ),
  ];

  final List<LeaderboardUser> _learners = const [
    LeaderboardUser(
      name: "Hala W.",
      identity: "Effat Univ.",
      imagePath: "",
      metric: "950 XP",
      rating: "5.0",
      skill: "Design Student",
      taughtHours: 2,
      learnedHours: 50,
      xp: 950,
    ),
    LeaderboardUser(
      name: "Majed N.",
      identity: "KSU",
      imagePath: "",
      metric: "880 XP",
      rating: "4.9",
      skill: "Python Beginner",
      taughtHours: 0,
      learnedHours: 45,
      xp: 880,
    ),
    LeaderboardUser(
      name: "Lina K.",
      identity: "KAU",
      imagePath: "",
      metric: "820 XP",
      rating: "4.8",
      skill: "Marketing Aspirant",
      taughtHours: 1,
      learnedHours: 40,
      xp: 820,
    ),
    LeaderboardUser(
      name: "Sultan A.",
      identity: "KAUST",
      imagePath: "",
      metric: "750 XP",
      rating: "4.7",
      skill: "AI Enthusiast",
      taughtHours: 0,
      learnedHours: 35,
      xp: 750,
    ),
    LeaderboardUser(
      name: "Amal M.",
      identity: "U. of Jeddah",
      imagePath: "",
      metric: "710 XP",
      rating: "4.6",
      skill: "Product Design",
      taughtHours: 0,
      learnedHours: 32,
      xp: 710,
    ),
    LeaderboardUser(
      name: "Saleh J.",
      identity: "KFUPM",
      imagePath: "",
      metric: "680 XP",
      rating: "4.8",
      skill: "C++ Learner",
      taughtHours: 0,
      learnedHours: 30,
      xp: 680,
    ),
    LeaderboardUser(
      name: "Rana B.",
      identity: "PNU",
      imagePath: "",
      metric: "640 XP",
      rating: "4.5",
      skill: "Flutter Developer",
      taughtHours: 0,
      learnedHours: 28,
      xp: 640,
    ),
    LeaderboardUser(
      name: "Yazeed Q.",
      identity: "KSU",
      imagePath: "",
      metric: "610 XP",
      rating: "4.4",
      skill: "React Student",
      taughtHours: 0,
      learnedHours: 25,
      xp: 610,
    ),
    LeaderboardUser(
      name: "Huda E.",
      identity: "Dar Al-Hekma",
      imagePath: "",
      metric: "580 XP",
      rating: "4.3",
      skill: "Video Editing",
      taughtHours: 0,
      learnedHours: 22,
      xp: 580,
    ),
    LeaderboardUser(
      name: "Tariq V.",
      identity: "Prince Sultan Univ.",
      imagePath: "",
      metric: "550 XP",
      rating: "4.2",
      skill: "Public Speaking",
      taughtHours: 0,
      learnedHours: 20,
      xp: 550,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<LeaderboardUser> currentList =
        widget.selectedMode == ExploreMode.mentor ? _mentors : _learners;

    final LeaderboardUser firstPlace = currentList[0];
    final LeaderboardUser secondPlace = currentList[1];
    final LeaderboardUser thirdPlace = currentList[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SECTION TITLE HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: gold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Jeddah's Dean's List",
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
                    "Top Knowledge Contributors This Week",
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
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      _isExpanded ? "Show less" : "See all",
                      style: const TextStyle(
                        color: primaryDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.5),
                      child: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.chevron_right_rounded,
                        color: gold,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // 2. PODIUM GRID ROW (2nd Place, 1st Place, 3rd Place)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rank 2 Card (Silver)
              Expanded(
                child: _buildPodiumCard(
                  rank: 2,
                  user: secondPlace,
                  badgeColor: silver,
                  glowColor: silver.withValues(alpha: 0.10),
                  borderColor: silver.withValues(alpha: 0.5),
                  isFirstPlace: false,
                ),
              ),
              const SizedBox(width: 12),

              // Rank 1 Card (Gold)
              Expanded(
                child: _buildPodiumCard(
                  rank: 1,
                  user: firstPlace,
                  badgeColor: gold,
                  glowColor: gold.withValues(alpha: 0.20),
                  borderColor: gold,
                  isFirstPlace: true,
                ),
              ),
              const SizedBox(width: 12),

              // Rank 3 Card (Platinum)
              Expanded(
                child: _buildPodiumCard(
                  rank: 3,
                  user: thirdPlace,
                  badgeColor: platinum,
                  glowColor: platinum.withValues(alpha: 0.08),
                  borderColor: platinum.withValues(alpha: 0.45),
                  isFirstPlace: false,
                ),
              ),
            ],
          ),

          // 3. CONDITIONAL LOWER LIST ROWS (Ranks 4-10)
          if (_isExpanded) ...[
            const SizedBox(height: 20),
            ...currentList.sublist(3).asMap().entries.map((entry) {
              final int index = entry.key;
              final LeaderboardUser user = entry.value;
              return LeaderCard(
                rank: index + 4,
                name: user.name,
                identity: user.identity,
                skill: user.skill,
                rating: user.rating,
                taughtHours: user.taughtHours,
                learnedHours: user.learnedHours,
                xp: user.xp,
                imageAsset: user.imagePath,
                mode: widget.selectedMode == ExploreMode.mentor
                    ? LeaderboardMode.mentor
                    : LeaderboardMode.learner,
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPodiumCard({
    required int rank,
    required LeaderboardUser user,
    required Color badgeColor,
    required Color glowColor,
    required Color borderColor,
    required bool isFirstPlace,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isFirstPlace ? 20 : 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 24,
            spreadRadius: isFirstPlace ? 5 : 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: isFirstPlace ? 2.5 : 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: isFirstPlace ? 70 : 60,
                height: isFirstPlace ? 70 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.5),
                    width: 2.0,
                  ),
                  image: user.imagePath.isNotEmpty
                      ? DecorationImage(
                          image: AssetImage(user.imagePath),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: user.imagePath.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        size: isFirstPlace ? 38 : 30,
                        color: Colors.white.withValues(alpha: 0.2),
                      )
                    : null,
              ),
              Positioned(
                top: -14,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1B1E),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Color(0xFF1A1B1E),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              fontFamily: 'Plus Jakarta Sans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            user.identity,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Plus Jakarta Sans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_rounded,
                color: gold,
                size: 12,
              ),
              const SizedBox(width: 3),
              Text(
                user.rating,
                style: const TextStyle(
                  color: gold,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.selectedMode == ExploreMode.mentor
                          ? Icons.schedule_rounded
                          : Icons.bolt_rounded,
                      color: gold,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.metric.split(' ')[0], // Just the number
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.selectedMode == ExploreMode.mentor ? "hrs Taught" : "XP",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
