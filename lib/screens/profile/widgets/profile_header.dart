import 'package:flutter/material.dart';
import '../settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onChangeCharacter;
  final VoidCallback? onChangeBackground;

  const ProfileHeader({
    super.key,
    this.onChangeCharacter,
    this.onChangeBackground,
  });

  static const Color goldColor = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: cream,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ---------------------------------------------------------
          // LEFT BACK BUTTON
          // ---------------------------------------------------------
          _HeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),

          // ---------------------------------------------------------
          // BEDAL ARABIC LOGO
          // ---------------------------------------------------------
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/logo/bedal_ar.png',
                height: 43,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ---------------------------------------------------------
          // RIGHT MENU BUTTON -> Opens SettingsScreen
          // ---------------------------------------------------------
          _HeaderButton(
            icon: Icons.menu_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// HEADER BUTTON
// ===================================================================

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: ProfileHeader.goldColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ProfileHeader.goldColor.withValues(alpha: 0.2)),
          ),
          child: Icon(
            icon,
            size: 20,
            color: ProfileHeader.charcoal,
          ),
        ),
      ),
    );
  }
}
