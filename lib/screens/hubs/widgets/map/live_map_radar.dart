import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../models/hub_state.dart';
import '../../models/hub_data.dart';
import 'map_markers.dart';
import 'selected_venue_overlay.dart';

class LiveMapRadar extends StatelessWidget {
  const LiveMapRadar({super.key});

  @override
  Widget build(BuildContext context) {
    final hubState = context.read<HubState>();
    final selectedVenue = context.watch<HubState>().selectedVenue;

    return Container(
      width: double.infinity,
      height: 380, // Larger, more immersive map
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            FlutterMap(
              mapController: hubState.mapController,
              options: MapOptions(
                initialCenter: LatLng(21.5435, 39.1728),
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'sa.bedal.campusapp.jeddah',
                ),
                // Venue Markers
                MarkerLayer(
                  markers: HubData.mockVenues.map((venue) {
                    final isSelected = selectedVenue?.id == venue.id;
                    return Marker(
                      point: venue.location,
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      child: CafeMapMarker(
                        venue: venue,
                        isSelected: isSelected,
                        onTap: () {
                          hubState.selectVenue(venue, moveMap: true);
                        },
                      ),
                    );
                  }).toList(),
                ),
                // User Markers
                MarkerLayer(
                  markers: HubData.mockActiveUsers.map((user) {
                    return Marker(
                      point: user.location,
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: UserMapMarker(user: user),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Top Left Status
            Positioned(
              top: 16,
              left: 16,
              child: _buildLiveStatus(),
            ),

            // Neighborhood Labels
            Positioned(
              top: 100,
              left: 40,
              child: _buildNeighborhoodLabel(
                selectedVenue?.neighborhood.toUpperCase() ?? 'AL REHAB',
                selectedVenue?.neighborhood == 'Al Rawdah' ? 'الروضة' : 'الرحاب',
              ),
            ),
            Positioned(
              top: 160,
              right: 40,
              child: _buildNeighborhoodLabel('AL RAWDAH', 'الروضة'),
            ),

            // Selected Venue Overlay
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(child: SelectedVenueOverlay()),
            ),

            // Map Controls
            Positioned(
              right: 16,
              bottom: 80,
              child: _buildMapControl(Icons.my_location_rounded),
            ),
            Positioned(
              right: 16,
              bottom: 20,
              child: _buildMapControl(Icons.near_me_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1E).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sensors_rounded, color: Color(0xFFC89B3C), size: 14),
          const SizedBox(width: 8),
          const Text(
            'Live Map',
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Color(0xFF49C774), shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          const Text(
            '23 active now',
            style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNeighborhoodLabel(String en, String ar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          en,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        Text(
          ar,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFC89B3C),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
