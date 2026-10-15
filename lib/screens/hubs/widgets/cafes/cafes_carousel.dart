import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hub_state.dart';
import '../../models/hub_data.dart';
import 'cafe_card.dart';
import '../filters/hub_filter_sheet.dart';

class CafesCarousel extends StatelessWidget {
  const CafesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final hubState = context.read<HubState>();
    final selectedVenue = context.watch<HubState>().selectedVenue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.coffee_outlined,
                    color: Color(0xFFC5A059), // Golden color matching bottom nav bar icon
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Cafes Around You',
                    style: TextStyle(
                      color: Color(0xFF16171A),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildMiniFilter(context, 'Al Rehab'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => const HubFilterSheet(),
                      );
                    },
                    child: _buildIconButton(Icons.tune_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HubData.mockVenues.length,
            itemBuilder: (context, index) {
              final venue = HubData.mockVenues[index];
              final isSelected = selectedVenue?.id == venue.id;
              return CafeCard(
                venue: venue,
                isSelected: isSelected,
                onTap: () {
                  hubState.selectVenue(venue, moveMap: true);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Simple Page Indicator peeking
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(HubData.mockVenues.length, (index) {
              return Container(
                width: 30,
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: selectedVenue?.id == HubData.mockVenues[index].id
                      ? const Color(0xFFC5A059)
                      : const Color(0xFFC5A059).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniFilter(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF16171A),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF16171A)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF16171A)),
    );
  }
}
