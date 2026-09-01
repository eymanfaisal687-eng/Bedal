import 'package:flutter/material.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_hero.dart';
import 'widgets/bedal_token.dart';
import 'widgets/profile_info.dart';
import 'widgets/profile_actions.dart';
import 'widgets/daily_quests.dart';
import 'widgets/profile_progress.dart';

import 'tabs/profile_tabs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color cream = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // =======================================================
            // TOP HEADER
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileHeader(),
            ),

            // =======================================================
            // HERO
            // 3D CHARACTER + BACKGROUND + EDIT BUTTON
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileHero(),
            ),

            // =======================================================
            // PROFILE INFORMATION
            // NAME / AGE / AREA / STATUS
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileInfo(),
            ),

            // =======================================================
            // ACTION BUTTONS
            // INVITE / ENTER MY CAFE / FOLLOW
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileActions(),
            ),

            // =======================================================
            // DAILY QUESTS
            // =======================================================

            const SliverToBoxAdapter(
              child: DailyQuests(),
            ),

            // =======================================================
            // BEDAL TIME TOKENS
            // =======================================================

            const SliverToBoxAdapter(
              child: BedalToken(),
            ),
            // =======================================================
            // XP / LEVEL PROGRESS
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileProgress(),
            ),

            // =======================================================
            // SKILLS / CAFÉ WALL / GUILDS
            // =======================================================

            const SliverToBoxAdapter(
              child: ProfileTabs(),
            ),

            // =======================================================
            // BOTTOM SPACING
            // =======================================================

            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}
