// ============================================================================
// 📄 FILE: redeem_workshops_section.dart
// PURPOSE: Explore screen section displaying partner-sponsored workshops redeemable with Bedal Coins
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../models/coin_workshop_model.dart';
import 'coin_workshop_card.dart';

class RedeemWorkshopsSection extends StatelessWidget {
  const RedeemWorkshopsSection({super.key});

  static const Color primaryDark = Color(0xFF1A1B1E);
  static const Color secondaryMuted = Color(0xFF777269);
  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    final workshops = CoinWorkshopModel.getSampleWorkshops();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER & SUBTITLE
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
                          const Text('🪙 ', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          const Flexible(
                            child: Text(
                              "Redeem with Bedal Coins",
                              style: TextStyle(
                                color: primaryDark,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: gold.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: gold.withValues(alpha: 0.25)),
                            ),
                            child: const Text(
                              "Partner Seats",
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
                        "Your skills earn you new experiences.",
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
                  onPressed: () {
                    // Show full list or summary message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Showing all redeemable partner workshops.')),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "View all",
                        style: TextStyle(
                          color: primaryDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
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

          // HORIZONTALLY SCROLLABLE CARDS
          SizedBox(
            height: 185,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                return CoinWorkshopCard(workshop: workshops[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
