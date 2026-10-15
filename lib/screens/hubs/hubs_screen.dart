import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/hub_state.dart';
import 'widgets/map/live_map_radar.dart';
import 'widgets/cafes/cafes_carousel.dart';
import 'widgets/guilds/active_hobby_guilds_list.dart';

class HubsScreen extends StatefulWidget {
  const HubsScreen({super.key});

  @override
  State<HubsScreen> createState() => _HubsScreenState();
}

class _HubsScreenState extends State<HubsScreen> {
  late HubState _hubState;

  @override
  void initState() {
    super.initState();
    _hubState = HubState();
  }

  @override
  void dispose() {
    _hubState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _hubState,
      child: Container(
        color: const Color(0xFFF1EEE7), // Greige background matching Explore screen theme
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HUB HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hub',
                          style: TextStyle(
                            color: Color(0xFF16171A),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        Text(
                          'Connect. Meet. Grow together.',
                          style: TextStyle(
                            color: Color(0xFF7A7368),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    _buildVerifiedBadge(),
                  ],
                ),
              ),

              // 2. LIVE MAP
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LiveMapRadar(),
              ),

              const SizedBox(height: 24),

              // 3. CAFES AROUND YOU
              const CafesCarousel(),

              const SizedBox(height: 32),

              // 4. ACTIVE HOBBY GUILDS
              const ActiveHobbyGuildsList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: Color(0xFFC5A059), size: 16),
          SizedBox(width: 6),
          Text(
            'Verified Hub Zones',
            style: TextStyle(
              color: Color(0xFFC5A059),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
