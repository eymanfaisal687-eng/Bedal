// =========================================================================
// 📄 FILE: user_info_overlay.dart
// ROLE: Profile + Skill information overlay on the Bedal discovery feed
// =========================================================================

import 'package:flutter/material.dart';

class UserInfoOverlay extends StatelessWidget {
  const UserInfoOverlay({
    super.key,
  });

  // =========================================================================
  // BEDAL COLORS
  // =========================================================================

  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ================================================================
        // PROFILE HEADER
        // ================================================================

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ------------------------------------------------------------
            // PROFILE AVATAR
            // ------------------------------------------------------------

            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/character_images/reem.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black26,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 23,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 9),

            // ------------------------------------------------------------
            // NAME + STATUS
            // ------------------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NAME
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Flexible(
                        child: Text(
                          'Sara Ali',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Icon(
                        Icons.verified_rounded,
                        color: gold,
                        size: 16,
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // SMALL STATUS
                  const Text(
                    'Skill exchange · Jeddah',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        // ================================================================
        // TEACHING
        // ================================================================

        _SkillRow(
          label: 'Teaching',
          icon: Icons.restaurant_rounded,
          value: 'Home Cooking',
        ),

        const SizedBox(height: 6),

        // ================================================================
        // LOOKING FOR
        // ================================================================

        _SkillRow(
          label: 'Looking for',
          icon: Icons.camera_alt_rounded,
          value: 'Photography',
        ),

        const SizedBox(height: 12),

        // ================================================================
        // INTEREST / SKILL TAGS
        // ================================================================

        Wrap(
          spacing: 7,
          runSpacing: 6,
          children: const [
            _SkillTag(text: 'Cooking'),
            _SkillTag(text: 'Photography'),
            _SkillTag(text: 'Lifestyle'),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// SKILL ROW
// ============================================================================

class _SkillRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;

  const _SkillRow({
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ------------------------------------------------------------
        // LABEL
        // ------------------------------------------------------------

        Text(
          '$label  ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),

        // ------------------------------------------------------------
        // ICON
        // ------------------------------------------------------------

        Icon(
          icon,
          color: Colors.white,
          size: 14,
        ),

        const SizedBox(width: 5),

        // ------------------------------------------------------------
        // SKILL
        // ------------------------------------------------------------

        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SKILL TAG
// ============================================================================

class _SkillTag extends StatelessWidget {
  final String text;

  const _SkillTag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1,
        ),
      ),

      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black54,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
