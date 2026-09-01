import 'package:flutter/material.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key});

  // ===============================================================
  // COLORS
  // ===============================================================

  static const Color gold = Color(0xFFC5A059);
  static const Color cream = Color(0xFFF8F5EF);
  static const Color dark = Color(0xFF25231F);

  // ===============================================================
  // ASSETS
  // ===============================================================

  static const String characterAsset =
      'assets/images/profile/saudi_man.png';

  static const String backgroundAsset =
      'assets/images/profile/background_profile.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 555,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        child: Stack(
          children: [

            // =========================================================
            // JEDDAH BACKGROUND
            // =========================================================

            Positioned.fill(
              child: Image.asset(
                backgroundAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // =========================================================
            // SOFT PREMIUM OVERLAY
            // =========================================================

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                      cream.withValues(alpha: 0.10),
                      cream.withValues(alpha: 0.48),
                    ],
                    stops: const [
                      0.0,
                      0.32,
                      0.72,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),

            // =========================================================
            // SOFT CHARACTER SHADOW
            // =========================================================

            Positioned(
              bottom: 8,
              left: 95,
              right: 95,
              child: Container(
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black.withValues(alpha: 0.14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // 3D CHARACTER
            // =========================================================

            Positioned(
              top: 55,
              bottom: 0,
              left: 62,
              right: 62,
              child: IgnorePointer(
                child: Image.asset(
                  characterAsset,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.black26,
                      ),
                    );
                  },
                ),
              ),
            ),

            // =========================================================
            // PROFILE NAME
            // =========================================================

            Positioned(
              left: 24,
              bottom: 32,
              child: const _ProfileName(),
            ),

            // =========================================================
            // EDIT BUTTON
            // =========================================================

            Positioned(
              top: 90,
              right: 22,
              child: _EditButton(
                onTap: () {
                  _showCustomizationSheet(context);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ===============================================================
  // CUSTOMIZATION SHEET
  // ===============================================================

  void _showCustomizationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            24,
            14,
            24,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Handle
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
                  'Customize Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: dark,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Make your Bedal profile yours.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // =====================================================
              // CHANGE CHARACTER
              // =====================================================

              _CustomizationItem(
                icon: Icons.face_retouching_natural_rounded,
                title: 'Change Character',
                subtitle: 'Choose your 3D character',
                onTap: () {},
              ),

              // =====================================================
              // CHANGE BACKGROUND
              // =====================================================

              _CustomizationItem(
                icon: Icons.wallpaper_rounded,
                title: 'Change Background',
                subtitle: 'Choose your Jeddah environment',
                onTap: () {},
              ),

              // =====================================================
              // CHANGE NAME
              // =====================================================

              _CustomizationItem(
                icon: Icons.edit_rounded,
                title: 'Change Name',
                subtitle: 'Update your display name',
                onTap: () {},
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

// ===================================================================
// PROFILE NAME
// ===================================================================

class _ProfileName extends StatelessWidget {
  const _ProfileName();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.75),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'Ahmed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: ProfileHero.dark,
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                '👑',
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          RichText(
            text: const TextSpan(
              children: [

                TextSpan(
                  text: 'Level 12',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ProfileHero.dark,
                  ),
                ),

                TextSpan(
                  text: '  •  ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9B968D),
                  ),
                ),

                TextSpan(
                  text: '1,240 XP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ProfileHero.gold,
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

// ===================================================================
// EDIT BUTTON
// ===================================================================

class _EditButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EditButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProfileHero.gold,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.edit_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// CUSTOMIZATION ITEM
// ===================================================================

class _CustomizationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CustomizationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A059).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFC5A059),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF25231F),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9B968D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}