// ============================================================================
// 📄 FILE: coin_workshop_card.dart
// PURPOSE: Displays a partner-sponsored workshop card for Bedal Coin redemption (Hub Screen style)
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../models/coin_workshop_model.dart';
import 'coin_workshop_detail_sheet.dart';

class CoinWorkshopCard extends StatelessWidget {
  final CoinWorkshopModel workshop;

  const CoinWorkshopCard({super.key, required this.workshop});

  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color mutedText = Color(0xFF7A7368);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE3E0D6);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFFF1EEE7),
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              builder: (context) => CoinWorkshopDetailSheet(workshop: workshop),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW: Coin Cost & Complimentary Seat Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪙 ', style: TextStyle(fontSize: 11)),
                          Text(
                            '${workshop.coinCost} Coins',
                            style: const TextStyle(
                              color: gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: charcoal.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Complimentary',
                        style: TextStyle(
                          color: charcoal,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // WORKSHOP TITLE
                Text(
                  workshop.title,
                  style: const TextStyle(
                    color: charcoal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    height: 1.25,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // VENUE NAME
                Text(
                  workshop.venueName,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // SCHEDULE
                Text(
                  workshop.schedule,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 11,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // BOTTOM ROW: Remaining Seats & View Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      workshop.isFullyBooked
                          ? 'Fully Booked'
                          : '👥 ${workshop.remainingSeats} seats left',
                      style: TextStyle(
                        color: workshop.isFullyBooked ? Colors.red.shade700 : gold,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: const [
                        Text(
                          'View Workshop',
                          style: TextStyle(
                            color: charcoal,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, color: gold, size: 14),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
