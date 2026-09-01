import 'package:flutter/material.dart';

import 'widgets/discovery/explore_toggle.dart';
import 'widgets/leaderboard/leaderboard_section.dart';
import 'widgets/search/search_bar.dart';
import 'widgets/search/search_results.dart';
import 'widgets/trending/trending_skills_section.dart';
import 'widgets/workshops/group_workshops_section.dart';

enum ExploreMode {
  mentor,
  learner,
}

// ============================================================================
// BEDAL — EXPLORE SCREEN
// ============================================================================
//
// Purpose:
// Premium discovery space for finding people, skills, and workshops.
//
// Visual direction:
// • Bedal Gold        #C5A059
// • Deep Charcoal     #16171A
// • Warm Surface      #25231F
// • Soft Cream        #F8F5EF
// • White typography
//
// Structure:
// 1. Search
// 2. Mentor / Learner discovery switch
// 3. Contextual discovery message
// 4. People
// 5. Trending skills
// 6. Workshops & guilds
// ============================================================================

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ExploreMode _exploreMode = ExploreMode.mentor;
  String _searchQuery = '';

  // ==========================================================================
  // BEDAL COLORS
  // ==========================================================================

  static const Color darkHeader = Color(0xFFF1EEE7);
  static const Color greigeBg = Color(0xFFF1EEE7);

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greigeBg,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------------------
            // TOP HEADER STRIP (Matches App Header)
            // ----------------------------------------------------------------
            Container(
              height: 12,
              color: darkHeader,
              width: double.infinity,
            ),

            const SizedBox(height: 16),

            // ----------------------------------------------------------------
            // 1. SEARCH (Now on Greige background)
            // ----------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ExploreSearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 18),

            // ----------------------------------------------------------------
            // 2. DISCOVERY MODE & HINT
            // ----------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ExploreToggle(
                selectedMode: _exploreMode,
                onChanged: (mode) {
                  setState(() {
                    _exploreMode = mode;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------------
            // 4. PEOPLE / LEADERBOARD / SEARCH RESULTS
            // ----------------------------------------------------------------

            if (_searchQuery.trim().isEmpty) ...[
              LeaderboardSection(selectedMode: _exploreMode),
              _buildSectionDivider(),
              const TrendingSkillsSection(),
              _buildSectionDivider(),
              const GroupWorkshopsSection(),
            ] else
              SearchResults(query: _searchQuery, mode: _exploreMode),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Divider(
        color: const Color(0xFF1A1B1E).withValues(alpha: 0.05),
        thickness: 1,
      ),
    );
  }
}
