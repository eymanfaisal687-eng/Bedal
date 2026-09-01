import 'package:flutter/material.dart';
import 'components/skill_reels_carousel.dart';
import 'components/skill_member_card.dart';

// ========================================================================
// 📄 FILE: skill_detail_screen.dart
// PURPOSE: Displays detailed community information for a specific skill.
// ========================================================================

class SkillDetailScreen extends StatelessWidget {
  final String skillName;

  const SkillDetailScreen({
    super.key,
    required this.skillName,
  });

  // Bedal Brand Palette
  static const Color primaryDark = Color(0xFF1A1B1E);
  static const Color warmGreige = Color(0xFFF1EEE7);
  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmGreige,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          skillName.toUpperCase(),
          style: const TextStyle(
            color: gold,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // 1. ACTIVE SKILL REELS
            const SkillReelsCarousel(),

            const SizedBox(height: 32),

            // 2. PEOPLE OFFERING THIS SKILL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(
                title: 'People Offering This Skill',
                subtitle: 'Learn from local masters in Jeddah',
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return SkillMemberCard(
                  name: 'Master ${index + 1}',
                  imageUrl: 'https://picsum.photos/seed/offer$index/200/200',
                  location: 'Al Rawdah, Jeddah',
                  rating: 4.9,
                  bedalHours: 12 + index * 5,
                  actionLabel: 'Learn / Connect',
                  onAction: () {},
                );
              },
            ),

            const SizedBox(height: 32),

            // 3. PEOPLE LOOKING TO LEARN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(
                title: 'People Looking to Learn',
                subtitle: 'Connect and share your knowledge',
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return SkillMemberCard(
                  name: 'Learner ${index + 1}',
                  imageUrl: 'https://picsum.photos/seed/learn$index/200/200',
                  location: 'Al Hamra, Jeddah',
                  subtitle: 'Looking for intermediate $skillName tips',
                  actionLabel: 'Connect / Offer Skill',
                  onAction: () {},
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: primaryDark.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }
}
