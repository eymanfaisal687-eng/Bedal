import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ===============================================================
  // BEDAL Nav COLOR PALETTE
  // ===============================================================

  static const Color background = Color(0xFF1A1B1E);
  static const Color gold = Color(0xFFB88A32);
  static const Color activeBackground = Color(0xFFFFFFFF);
  static const Color inactive = Color(0xFF9A958C);
  static const Color border = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: background,

        // Very subtle separation from the page
        border: Border(
          top: BorderSide(
            color: border,
            width: 1,
          ),
        ),
      ),

      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),

      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // =======================================================
            // HOME
            // =======================================================

            _buildAnimatedNavItem(
              0,
              Icons.home_outlined,
              Icons.home,
              'Home',
            ),

            // =======================================================
            // EXPLORE
            // =======================================================

            _buildAnimatedNavItem(
              1,
              Icons.explore_outlined,
              Icons.explore,
              'Explore',
            ),

            // =======================================================
            // HUBS
            // =======================================================

            _buildAnimatedNavItem(
              2,
              Icons.coffee_outlined,
              Icons.coffee,
              'Hubs',
            ),

            // =======================================================
            // CHAT
            // =======================================================

            _buildAnimatedNavItem(
              3,
              Icons.chat_bubble_outline,
              Icons.chat_bubble,
              'Chat',
            ),

            // =======================================================
            // PROFILE
            // =======================================================

            _buildAnimatedNavItem(
              4,
              Icons.person_outline,
              Icons.person,
              'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // ANIMATED NAVIGATION ITEM
  // ===============================================================

  Widget _buildAnimatedNavItem(int index,
      IconData inactiveIcon,
      IconData activeIcon,
      String label,) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),

        curve: Curves.easeInOut,

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          // =========================================================
          // ACTIVE CAPSULE
          // =========================================================

          color: isActive
              ? activeBackground
              : Colors.transparent,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            // =======================================================
            // ICON
            // =======================================================

            Icon(
              isActive
                  ? activeIcon
                  : inactiveIcon,

              color: isActive
                  ? gold
                  : inactive,

              size: 22,
            ),

            // =======================================================
            // ANIMATED LABEL
            // =======================================================

            AnimatedCrossFade(
              duration: const Duration(
                milliseconds: 250,
              ),

              firstChild: Row(
                children: [
                  const SizedBox(width: 6),

                  Text(
                    label,

                    style: const TextStyle(
                      color: gold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),

              secondChild: const SizedBox.shrink(),

              crossFadeState: isActive
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ],
        ),
      ),
    );
  }
}
