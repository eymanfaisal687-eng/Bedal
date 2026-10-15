import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hub_state.dart';

class SelectedVenueOverlay extends StatelessWidget {
  const SelectedVenueOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final hubState = context.watch<HubState>();
    final venue = hubState.selectedVenue;

    if (venue == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              venue.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venue.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              Text(
                venue.neighborhood,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFFC89B3C),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFFC89B3C),
                    size: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
