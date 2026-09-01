import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  static const Color goldColor = Color(0xFFC5A059);
  static const Color iconColor = Color(0xFF4A4740);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F5EF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // ---------------------------------------------------------
          // LEFT SIDE
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
          // MENU BUTTON
          // ---------------------------------------------------------

          _HeaderButton(
            icon: Icons.menu_rounded,
            onTap: () {
              _showMenu(context);
            },
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F5EF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
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

              // Small handle
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
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16171A),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _MenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.face_retouching_natural_rounded,
                title: 'Change Character',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.wallpaper_rounded,
                title: 'Change Background',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.edit_rounded,
                title: 'Change Name',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                onTap: () {},
              ),

              _MenuItem(
                icon: Icons.settings_outlined,
                title: 'Account Settings',
                onTap: () {},
              ),
            ],
          ),
        );
      },
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
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(
            icon,
            size: 25,
            color: const Color(0xFF4A4740),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// SETTINGS MENU ITEM
// ===================================================================

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              children: [

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A059).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFFC5A059),
                  ),
                ),

                const SizedBox(width: 14),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF16171A),
                  ),
                ),

                const Spacer(),

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