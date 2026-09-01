import 'package:flutter/material.dart';

import 'skills_tab.dart';
import 'cafe_wall_tab.dart';
import 'guilds_tab.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  int selectedTab = 0;

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color cream = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cream,
      padding: const EdgeInsets.fromLTRB(
        22,
        0,
        22,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================================================
          // SECTION TITLE
          // =========================================================

          const Padding(
            padding: EdgeInsets.only(
              bottom: 14,
            ),
            child: Text(
              'My World',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: dark,
              ),
            ),
          ),

          // =========================================================
          // TAB SWITCHER
          // =========================================================

          Container(
            height: 56,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: gold.withValues(alpha: 0.13),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: _TabButton(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Skills',
                    selected: selectedTab == 0,
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: _TabButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Café Wall',
                    selected: selectedTab == 1,
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: _TabButton(
                    icon: Icons.groups_outlined,
                    label: 'Guilds',
                    selected: selectedTab == 2,
                    onTap: () {
                      setState(() {
                        selectedTab = 2;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // =========================================================
          // SELECTED TAB CONTENT
          // =========================================================

          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 250,
            ),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _buildSelectedTab(),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // TAB CONTENT
  // =================================================================

  Widget _buildSelectedTab() {
    switch (selectedTab) {
      case 0:
        return const SkillsTab(
          key: ValueKey('skills'),
        );

      case 1:
        return const CafeWallsTab(
          key: ValueKey('cafe_wall'),
        );

      case 2:
        return const GuildsTab(
          key: ValueKey('guilds'),
        );

      default:
        return const SkillsTab(
          key: ValueKey('skills'),
        );
    }
  }
}

// ===================================================================
// TAB BUTTON
// ===================================================================

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFC5A059)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 18,
              color: selected
                  ? Colors.white
                  : const Color(0xFF777269),
            ),

            const SizedBox(width: 5),

            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF777269),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}