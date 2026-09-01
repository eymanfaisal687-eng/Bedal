import 'package:flutter/material.dart';
import '../../explore_screen.dart';
import '../leaderboard/leaderboard_card.dart';

// ========================================================================
// 📄 FILE: search_results.dart
// PURPOSE: Displays filtered local search results for Skills, People, and Places.
// ========================================================================

class SearchResults extends StatelessWidget {
  final String query;
  final ExploreMode mode;

  const SearchResults({
    super.key,
    required this.query,
    required this.mode,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color darkCard = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    final String cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return const SizedBox.shrink();

    // 1. DATASETS
    final List<_SkillData> skills = _getSkills();
    final List<_UserData> users = _getUsers();
    final List<_PlaceData> places = _getPlaces();

    // 2. FILTERING
    final filteredSkills = skills.where((s) => s.title.toLowerCase().contains(cleanQuery)).toList();
    final filteredUsers = users.where((u) => 
      u.name.toLowerCase().contains(cleanQuery) || 
      u.skill.toLowerCase().contains(cleanQuery) || 
      u.identity.toLowerCase().contains(cleanQuery)
    ).toList();
    final filteredPlaces = places.where((p) => p.name.toLowerCase().contains(cleanQuery)).toList();

    final bool hasResults = filteredSkills.isNotEmpty || filteredUsers.isNotEmpty || filteredPlaces.isNotEmpty;

    if (!hasResults) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultsHeader(cleanQuery),
          const SizedBox(height: 24),
          if (filteredSkills.isNotEmpty) ...[
            _buildSectionHeader("SKILLS"),
            ...filteredSkills.map((s) => _buildSkillResultCard(s)),
            const SizedBox(height: 24),
          ],
          if (filteredUsers.isNotEmpty) ...[
            _buildSectionHeader("PEOPLE"),
            ...filteredUsers.map((u) => _buildUserResultCard(u)),
            const SizedBox(height: 24),
          ],
          if (filteredPlaces.isNotEmpty) ...[
            _buildSectionHeader("PLACES"),
            ...filteredPlaces.map((p) => _buildPlaceResultCard(p)),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // UI BUILDERS
  // ==========================================================================

  Widget _buildResultsHeader(String query) {
    return Row(
      children: [
        const Text(
          "Results for ",
          style: TextStyle(
            color: Color(0xFF777269),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        Text(
          "\"$query\"",
          style: const TextStyle(
            color: Color(0xFF1A1B1E),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF777269),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildSkillResultCard(_SkillData skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(skill.icon, color: gold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  skill.activeCount,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildUserResultCard(_UserData user) {
    return LeaderCard(
      rank: 0, // Rank not shown in search usually, or we can just pass a placeholder
      name: user.name,
      identity: user.identity,
      skill: user.skill,
      rating: user.rating,
      taughtHours: user.taughtHours,
      learnedHours: user.learnedHours,
      xp: user.xp,
      imageAsset: user.imagePath,
      mode: mode == ExploreMode.mentor ? LeaderboardMode.mentor : LeaderboardMode.learner,
    );
  }

  Widget _buildPlaceResultCard(_PlaceData place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: gold, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              place.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              color: const Color(0xFF1A1B1E).withValues(alpha: 0.1),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              "No results found",
              style: TextStyle(
                color: Color(0xFF1A1B1E),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Try searching for another skill, person, or place.",
              style: TextStyle(
                color: Color(0xFF777269),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // DEMO DATA
  // ==========================================================================

  List<_SkillData> _getSkills() {
    return const [
      _SkillData(Icons.code_rounded, 'Python', '128 active'),
      _SkillData(Icons.sports_tennis_rounded, 'Padel Tips', '96 active'),
      _SkillData(Icons.design_services_rounded, 'Figma UI', '87 active'),
      _SkillData(Icons.business_center_rounded, 'CV & Interview Prep', '112 active'),
      _SkillData(Icons.extension_rounded, 'Chess Strategy', '74 active'),
      _SkillData(Icons.restaurant_rounded, 'Local Culinary Arts', '64 active'),
    ];
  }

  List<_UserData> _getUsers() {
    // Mentors + Learners combined for search
    return const [
      _UserData("Reem A.", "Effat Univ.", 'assets/images/character_images/reem.png', "5.0", "UX/UI Design", 42, 10, 850),
      _UserData("Sara M.", "KAUST", 'assets/images/character_images/reem.png', "4.9", "Machine Learning", 38, 15, 720),
      _UserData("Omar K.", "U. of Jeddah", 'assets/images/character_images/omar.png', "4.8", "Product Management", 34, 5, 680),
      _UserData("Faisal T.", "KAU", "", "4.9", "Software Engineering", 28, 12, 450),
      _UserData("Layan B.", "Dar Al-Hekma", "", "4.7", "Graphic Design", 22, 8, 320),
      _UserData("Hala W.", "Effat Univ.", "", "5.0", "Design Student", 2, 50, 950),
      _UserData("Majed N.", "KSU", "", "4.9", "Python Beginner", 0, 45, 880),
      _UserData("Lina K.", "KAU", "", "4.8", "Marketing Aspirant", 1, 40, 820),
    ];
  }

  List<_PlaceData> _getPlaces() {
    return const [
      _PlaceData("KAU"),
      _PlaceData("Effat University"),
      _PlaceData("University of Jeddah"),
      _PlaceData("Jeddah Corniche"),
      _PlaceData("KAUST"),
      _PlaceData("Dar Al-Hekma"),
    ];
  }
}

class _SkillData {
  final IconData icon;
  final String title;
  final String activeCount;
  const _SkillData(this.icon, this.title, this.activeCount);
}

class _UserData {
  final String name;
  final String identity;
  final String imagePath;
  final String rating;
  final String skill;
  final int taughtHours;
  final int learnedHours;
  final int xp;
  const _UserData(this.name, this.identity, this.imagePath, this.rating, this.skill, this.taughtHours, this.learnedHours, this.xp);
}

class _PlaceData {
  final String name;
  const _PlaceData(this.name);
}
