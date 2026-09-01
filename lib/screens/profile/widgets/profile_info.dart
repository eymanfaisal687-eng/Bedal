import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(
        22,
        0,
        22,
        18,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: gold.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Row(
          children: [

            // -------------------------------------------------------
            // AGE
            // -------------------------------------------------------

            Expanded(
              child: _InfoItem(
                icon: Icons.calendar_month_outlined,
                value: '24',
                label: 'Years Old',
              ),
            ),

            _Divider(),

            // -------------------------------------------------------
            // AREA
            // -------------------------------------------------------

            Expanded(
              child: _InfoItem(
                icon: Icons.location_on_outlined,
                value: 'Al Rawdah',
                label: 'Jeddah',
              ),
            ),

            _Divider(),

            // -------------------------------------------------------
            // COMMUNITY
            // -------------------------------------------------------

            Expanded(
              child: _InfoItem(
                icon: Icons.school_outlined,
                value: 'Student',
                label: 'in Jeddah',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// INFO ITEM
// ===================================================================

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Icon

        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFC5A059).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFC5A059),
          ),
        ),

        const SizedBox(height: 8),

        // Main value

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF25231F),
          ),
        ),

        const SizedBox(height: 2),

        // Label

        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF777269),
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// DIVIDER
// ===================================================================

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFC5A059).withValues(alpha: 0.18),
    );
  }
}