// ========================================================================
// 📄 FILE: group_workshops_section.dart
// PURPOSE: Builds the Group Workshops section.
//
// CURRENT FEATURES:
// • Displays the "Group Workshops & Guilds" title.
// • Shows the "Scheduled Events" badge.
// • Displays a short description.
// • Shows a horizontally scrollable list of workshop cards.
//
// FUTURE UPDATES:
// • TODO: Connect this section to BLoC to load workshops automatically.
// • TODO: Replace the sample workshop cards with data from Firebase.
// • TODO: Generate workshop cards from a workshop list instead of hardcoding them.
// ========================================================================

import 'package:flutter/material.dart';
import 'workshop_card.dart'; // // 🟢 Imports the card template

class GroupWorkshopsSection extends StatelessWidget {
  const GroupWorkshopsSection({super.key});

  static const Color primaryDark = Color(0xFF1A1B1E);
  static const Color secondaryMuted = Color(0xFF777269);
  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Badge Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            color: gold,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Group Workshops",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: gold.withValues(alpha: 0.2)),
                            ),
                            child: const Text(
                              "Scheduled",
                              style: TextStyle(
                                color: gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Join structured, multi-peer learning sessions this week.",
                        style: TextStyle(
                          color: secondaryMuted,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "See all",
                        style: TextStyle(
                          color: primaryDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: gold,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 🟢 2. CLEAN CALLING ARRAYS (Using your new decoupled cards file!)
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                const WorkshopCard(
                  title: "Figma UI Masterclass",
                  scheduleLine: "📅 Saturday • 10:00 AM @ Draft Café",
                  seatsTag: "👥 4/5 Seats Filled",
                  cardIcon: Icons.palette_outlined,
                  iconGlowColor: Color(0x269C27B0),
                ),
                const WorkshopCard(
                  title: "Corporate CV &\nInterview Prep",
                  scheduleLine: "📅 Wednesday • 6:00 PM @ The Hub",
                  seatsTag: "👥 2/5 Seats Filled",
                  cardIcon: Icons.business_center_outlined,
                  iconGlowColor: Color(0x337D5A50),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
