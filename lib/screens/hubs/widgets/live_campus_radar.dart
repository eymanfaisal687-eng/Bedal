// =========================================================================
// 🗺️ FILE: live_campus_radar.dart
// ROLE: Layer 1 Map Radar - Tracking Partner Cafe Pins & Live Density
// =========================================================================
// ACTIVE FRONT-END FEATURES:
// • Dark themed immersive city baseline map representation background framework.
// • Floating top right status action capsule label: "📍 Near Me".
// • Absolute absolute positioned gold map node pointer circles tracking counts.
// • Custom absolute floating vector navigation compass button matching UI blueprint styles.
//
// 🧠 FUTURE BACKEND / INTEGRATION BLUEPRINT:
// • TODO: Integrate standard Google Maps API / flutter_maps SDK container block.
// • TODO: Wrap with a HubsBloc / BlocBuilder to stream live coordinates from Firestore.
// • TODO: Replace static pin badge number strings with live student counters:
//   cafe.activeSwappersCount.toString()
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // ◄── THE OPENSTREETMAP PLAYER ENGINE
import 'package:latlong2/latlong.dart'; // Handles coordinate math structures safely

class LiveCampusRadar extends StatefulWidget {
  const LiveCampusRadar({super.key});

  @override
  State<LiveCampusRadar> createState() => _LiveCampusRadarState();
}

class _LiveCampusRadarState extends State<LiveCampusRadar> {
  // 1. Anchor coordinates targeted directly to central Jeddah, Saudi Arabia
  final LatLng _jeddahCenter = LatLng(21.5435, 39.1728);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      // Perfect visual balance matching your design system viewport layout
      clipBehavior: Clip.antiAlias,
      // Enforces the rounded design curves perfectly over native layers
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        // Premium capsule curve system match
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _jeddahCenter,
          // Core central Jeddah anchor coordinates
          initialZoom: 14.5,
          // ◄── UPGRADED: Forces the map to zoom straight into specific street/cafe grids
          maxZoom: 18.0,
          minZoom: 12.0,
          // Prevents users from zooming all the way out to a flat planet earth view
          interactionOptions: const InteractionOptions(
            flags:
                InteractiveFlag.all &
                ~InteractiveFlag
                    .rotate, // Enables smooth pinch-to-zoom but locks rotation so the map stays straight
          ),
        ),
        children: [
          // A. The Tile Layer fetching premium dark-themed imagery streams
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            // Enables fast, multi-threaded asset loading
            userAgentPackageName: 'sa.bedal.campusapp.jeddah',
            retinaMode: RetinaMode.isHighDensity(context),
          ),

          // B. The Marker Layer projecting interactive pins over your verified café hubs
          MarkerLayer(
            markers: [
              // Pin 1: Draft Café Al Rawdah
              Marker(
                point: LatLng(21.5584, 39.1681),
                width: 40,
                height: 40,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => _showHubContextAlert(
                    context,
                    'Draft Café',
                    '8 Active Swaps 🟢',
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Outer Pulsing Radar Ring
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // 2. High-Contrast Core Marker Pin
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFC89B3C),
                        // Your signature premium gold accent
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
              // Pin 2: The Hub Workspace Tahlia St.
              Marker(
                point: LatLng(21.5422, 39.1694),
                width: 40,
                height: 40,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => _showHubContextAlert(
                    context,
                    'The Hub Workspace',
                    '5 Active Swaps 🟢',
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFC89B3C),
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Small interactive notification card popping up when they tap a gold map marker pin
  void _showHubContextAlert(BuildContext context, String name, String snippet) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1B1F),
        duration: const Duration(seconds: 3),
        content: Text(
          "$name • $snippet",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
