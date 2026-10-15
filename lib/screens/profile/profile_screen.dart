import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_hero.dart';
import 'widgets/bedal_token.dart';
import 'widgets/profile_info.dart';
import 'widgets/profile_actions.dart';
import 'widgets/daily_quests.dart';
import 'widgets/profile_progress.dart';

import 'tabs/profile_tabs.dart';

class ProfileScreen extends StatefulWidget {
  final bool isMyProfile;
  final String viewedUserId;
  final String viewedUserName;

  const ProfileScreen({
    super.key,
    this.isMyProfile = true,
    this.viewedUserId = 'current_user',
    this.viewedUserName = '',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _customCharacterAsset;
  String _currentCharacterAsset = 'assets/images/profile/character_profile/male_characters/saudi_man.png';
  String _currentBackgroundAsset = 'assets/images/profile/background_profile/background_profile.png';

  static const Color cream = Color(0xFFF8F5EF);

  String _getCharacterAsset(SignupProvider provider) {
    final gender = provider.gender.toLowerCase();
    final nationality = provider.nationality.toLowerCase();

    if (gender.contains('woman') || gender.contains('female')) {
      if (nationality.contains('pakistani')) {
        return 'assets/images/profile/character_profile/female_characters/pakistani_women.png';
      } else {
        return 'assets/images/profile/character_profile/female_characters/saudi_women.png';
      }
    } else {
      if (nationality.contains('pakistani')) {
        return 'assets/images/profile/character_profile/male_characters/pakistani_man.png';
      } else {
        return 'assets/images/profile/character_profile/male_characters/saudi_man.png';
      }
    }
  }

  void _showCharacterSelector(BuildContext context, SignupProvider signupProvider) {
    final isWoman = signupProvider.gender.toLowerCase().contains('woman') || signupProvider.gender.toLowerCase().contains('female');
    final saudiAsset = isWoman
        ? 'assets/images/profile/character_profile/female_characters/saudi_women.png'
        : 'assets/images/profile/character_profile/male_characters/saudi_man.png';
    final pakistaniAsset = isWoman
        ? 'assets/images/profile/character_profile/female_characters/pakistani_women.png'
        : 'assets/images/profile/character_profile/male_characters/pakistani_man.png';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Your 3D Character',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16171A),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select your avatar style for your profile backdrop.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF7A7368),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _characterCard(
                      context,
                      name: 'Saudi',
                      asset: saudiAsset,
                      isSelected: _currentCharacterAsset == saudiAsset,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _characterCard(
                      context,
                      name: 'Pakistani',
                      asset: pakistaniAsset,
                      isSelected: _currentCharacterAsset == pakistaniAsset,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showBackgroundSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Profile Background',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16171A),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select your Jeddah background environment.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF7A7368),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _backgroundCard(
                      context,
                      name: 'Jeddah Daylight',
                      asset: 'assets/images/profile/background_profile/background_profile.png',
                      isSelected: _currentBackgroundAsset.contains('background_profile.png'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _backgroundCard(
                      context,
                      name: 'Jeddah Under Moonlight',
                      asset: 'assets/images/profile/background_profile/Jeddah_Under_Moonlight.png',
                      isSelected: _currentBackgroundAsset.contains('Jeddah_Under_Moonlight.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _characterCard(
    BuildContext context, {
    required String name,
    required String asset,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _customCharacterAsset = asset;
          _currentCharacterAsset = asset;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF16171A),
            content: Text(
              '👑 Character updated to $name!',
              style: const TextStyle(
                color: Color(0xFFC5A059),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFC5A059) : const Color(0xFFE5E0D5),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5EF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.person, size: 50, color: Colors.black26),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16171A),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCard(
    BuildContext context, {
    required String name,
    required String asset,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentBackgroundAsset = asset;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF16171A),
            content: Text(
              '🌅 Profile background updated to $name!',
              style: const TextStyle(
                color: Color(0xFFC5A059),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFC5A059) : const Color(0xFFE5E0D5),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.black26),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16171A),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();
    final profileName = widget.isMyProfile
        ? (signupProvider.fullName.trim().isNotEmpty ? signupProvider.fullName.trim() : 'Ahmed')
        : (widget.viewedUserName.isNotEmpty ? widget.viewedUserName : 'Sara Ali');

    // Automatically set character based on user gender and nationality selection if not custom selected
    final defaultAsset = _getCharacterAsset(signupProvider);
    _currentCharacterAsset = _customCharacterAsset ?? defaultAsset;

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // =======================================================
            // TOP HEADER
            // =======================================================

            SliverToBoxAdapter(
              child: ProfileHeader(
                onChangeCharacter: widget.isMyProfile ? () => _showCharacterSelector(context, signupProvider) : null,
                onChangeBackground: widget.isMyProfile ? () => _showBackgroundSelector(context) : null,
              ),
            ),

            // =======================================================
            // HERO
            // =======================================================

            SliverToBoxAdapter(
              child: ProfileHero(
                characterAsset: _currentCharacterAsset,
                backgroundAsset: _currentBackgroundAsset,
                profileName: profileName,
                onChangeCharacter: widget.isMyProfile ? () => _showCharacterSelector(context, signupProvider) : null,
                onChangeBackground: widget.isMyProfile ? () => _showBackgroundSelector(context) : null,
              ),
            ),

            // =======================================================
            // PROFILE INFORMATION
            // =======================================================

            SliverToBoxAdapter(
              child: ProfileInfo(userName: profileName),
            ),

            // =======================================================
            // ACTION BUTTONS (Ownership aware)
            // =======================================================

            SliverToBoxAdapter(
              child: ProfileActions(
                isMyProfile: widget.isMyProfile,
                userId: widget.viewedUserId,
                userName: profileName,
              ),
            ),

            // =======================================================
            // DAILY QUESTS (My Profile Only)
            // =======================================================

            if (widget.isMyProfile)
              const SliverToBoxAdapter(
                child: DailyQuests(),
              ),

            // =======================================================
            // BEDAL TIME TOKENS (My Profile Only)
            // =======================================================

            if (widget.isMyProfile)
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
