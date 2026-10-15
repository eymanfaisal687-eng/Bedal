import 'package:flutter/material.dart';

// ============================================================================
// 📄 FILE: active_schedules.dart
// PURPOSE: Clean white/light Active Schedules summary card with subtle gold accent.
// ============================================================================

class ActiveSchedules extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final VoidCallback? onUpcomingTap;
  final VoidCallback? onCompletedTap;

  const ActiveSchedules({
    super.key,
    this.onViewAllTap,
    this.onUpcomingTap,
    this.onCompletedTap,
  });

  static const Color charcoal = Color(0xFF25231F);
  static const Color gold = Color(0xFFC5A059);
  static const Color mutedText = Color(0xFF777269);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE5DDCC);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewAllTap ?? onUpcomingTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // ------------------------------------------------------------
                // 1. CALENDAR ICON BOX WITH GOLD ACCENT
                // ------------------------------------------------------------
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: gold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.event_available_rounded,
                      color: gold,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ------------------------------------------------------------
                // 2. TEXT DETAILS (TITLE + STAT SUBTITLE)
                // ------------------------------------------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Active Schedules',
                        style: TextStyle(
                          color: charcoal,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '2 Upcoming  ·  5 Completed',
                        style: TextStyle(
                          color: mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                ),

                // ------------------------------------------------------------
                // 3. CHEVRON RIGHT ARROW
                // ------------------------------------------------------------
                const Icon(
                  Icons.chevron_right_rounded,
                  color: gold,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
