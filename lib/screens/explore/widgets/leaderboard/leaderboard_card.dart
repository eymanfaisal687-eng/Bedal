import 'package:flutter/material.dart';

// ========================================================================
// 📄 FILE: leader_card.dart
// PURPOSE: Creates the premium Bedal leaderboard user card.
// ========================================================================

enum LeaderboardMode {
  mentor,
  learner,
}

class LeaderCard extends StatelessWidget {
  const LeaderCard({
    super.key,
    required this.rank,
    required this.name,
    required this.identity,
    required this.skill,
    required this.rating,
    required this.taughtHours,
    required this.learnedHours,
    required this.xp,
    required this.imageAsset,
    required this.mode,
    this.isPodium = false,
  });

  final int rank;
  final String name;
  final String identity;
  final String skill;
  final String rating;
  final int taughtHours;
  final int learnedHours;
  final int xp;
  final String imageAsset;
  final LeaderboardMode mode;
  final bool isPodium;

  static const Color gold = Color(0xFFC5A059);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color darkCard = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    final bool isMentor = mode == LeaderboardMode.mentor;

    // Dynamic Metric Data
    final String metricValue = isMentor ? '${taughtHours} hrs' : '${_formatXP(xp)} XP';
    final String metricLabel = isMentor ? 'Taught' : 'Knowledge Gained';
    final IconData metricIcon =
        isMentor ? Icons.schedule_rounded : Icons.bolt_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: gold.withValues(alpha: 0.05),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. RANK BADGE
          _buildRankBadge(),

          const SizedBox(width: 12),

          // 2. PROFILE PHOTO
          _buildAvatar(),

          const SizedBox(width: 14),

          // 3. IDENTITY + SKILL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  identity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                const SizedBox(height: 10),
                _buildSkillTag(),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // 4. METRIC + REPUTATION
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReputation(),
              const SizedBox(height: 10),
              _buildMetric(metricIcon, metricValue, metricLabel),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // HELPERS
  // ================================================================

  Widget _buildRankBadge() {
    Color badgeColor;
    switch (rank) {
      case 1:
        badgeColor = gold;
        break;
      case 2:
        badgeColor = silver;
        break;
      case 3:
        badgeColor = bronze;
        break;
      default:
        badgeColor = Colors.white.withValues(alpha: 0.15);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        rank.toString(),
        style: TextStyle(
          color: rank <= 3 ? badgeColor : Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: gold.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: imageAsset.isNotEmpty
            ? Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackAvatar(),
              )
            : _fallbackAvatar(),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: gold.withValues(alpha: 0.05),
      child: const Icon(
        Icons.person_rounded,
        color: gold,
        size: 24,
      ),
    );
  }

  Widget _buildSkillTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: gold.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          color: gold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildReputation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star_rounded,
          color: gold,
          size: 15,
        ),
        const SizedBox(width: 4),
        Text(
          rating,
          style: const TextStyle(
            color: gold,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: gold, size: 14),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }

  String _formatXP(int xp) {
    return xp.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
