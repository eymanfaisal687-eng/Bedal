// =========================================================================
// 🏢 FILE: app_header.dart
// ROLE: Bedal Top Application Header
// =========================================================================
//
// BEHAVIOR:
// • Left + button opens contextual action based on tab.
// • Arabic Bedal logo remains perfectly centered with elegant gold tint.
// • Right side:
//   - Heart Notification button (opens Notifications screen).
// =========================================================================

import 'package:flutter/material.dart';
import 'contextual_plus_button.dart';

class AppHeader extends StatelessWidget {
  final int currentIndex;

  final VoidCallback onOpenCamera;
  final VoidCallback onOpenExploreMenu;
  final VoidCallback onOpenCasualForm;

  final VoidCallback onOpenNotifications;

  const AppHeader({
    super.key,
    required this.currentIndex,
    required this.onOpenCamera,
    required this.onOpenExploreMenu,
    required this.onOpenCasualForm,
    required this.onOpenNotifications,
  });

  static const Color background = Color(0xFF1A1B1E);
  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // =====================================================
              // LEFT — CONTEXTUAL PLUS
              // =====================================================
              ContextualPlusButton(
                currentIndex: currentIndex,
                onOpenCamera: onOpenCamera,
                onOpenExploreMenu: onOpenExploreMenu,
                onOpenCasualForm: onOpenCasualForm,
              ),

              // =====================================================
              // CENTER — ARABIC BEDAL LOGO
              // =====================================================
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo/bedal_ar.png',
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'بدال',
                        style: TextStyle(
                          color: gold,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      );
                    },
                  ),
                ),
              ),

              // =====================================================
              // RIGHT — NOTIFICATIONS
              // =====================================================
              _HeaderButton(
                icon: Icons.favorite_border_rounded,
                onTap: onOpenNotifications,
              ),
            ],
          ),
        ),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            size: 28,
            color: Colors.white,
            weight: 700,
          ),
        ),
      ),
    );
  }
}
