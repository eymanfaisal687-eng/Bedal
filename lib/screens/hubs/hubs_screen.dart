// =========================================================================
// 🌐 FILE: hubs_screen.dart
// ROLE: Master Main Layer Screen Shell Coordinator for the Hubs Tab
// =========================================================================
// ACTIVE FRONT-END FEATURES:
// • SingleChildScrollView wrapping the structural sub-modules smoothly.
// • Clean explicit spacing cushion divider offsets separating layers.
// =========================================================================

// =========================================================================
// 🌐 FILE: hubs_screen.dart
// ROLE: Master Main Layer Screen Shell Coordinator for the Hubs Tab
// =========================================================================

import 'package:flutter/material.dart';
import 'widgets/live_campus_radar.dart';
import 'widgets/venue_notice_board.dart';
import 'widgets/active_hobby_guilds.dart';

class HubsScreen extends StatelessWidget {
  const HubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layer 1: Live Campus Radar Map View Section
          const LiveCampusRadar(),
          const SizedBox(height: 20),

          // Layer 2: Venue Card Deck Boards Notice Section
          const VenueNoticeBoard(),
          // 🟢 Removed implicit const errors conflict
          const SizedBox(height: 14),

          // Layer 3: Horizontal Campus Clubs Base Section
          const ActiveHobbyGuilds(),

          // 🟢 Removed implicit const errors conflict
          const SizedBox(height: 40),
          // Safe scroll layout buffer
        ],
      ),
    );
  }
}
