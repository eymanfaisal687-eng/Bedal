// =========================================================================
// 🎴 FILE: venue_card.dart
// ROLE: Layer 2 Individual Cafe Row Card & Table Booking System
// =========================================================================
// ACTIVE FRONT-END FEATURES:
// • Image cover view header boxes mapping premium interior snapshots.
// • Feature capsule attribute indicators: Fast WiFi, Outlets, Quiet Zone.
// • Live in-room user announcement notice board bullet sub-rows.
// • Material InkWell booking link button: "📅 RESERVE STUDY TABLE (0 SAR)".
//
// 🧠 FUTURE BACKEND / INTEGRATION BLUEPRINT:
// • TODO: Connect the Reservation button to a BookingBloc / Firestore write.
// • TODO: Fetch live notice board announcements under: cafes/{id}/announcements
// =========================================================================

// =========================================================================
// 🎴 FILE: venue_card.dart
// ROLE: Layer 2 Individual Cafe Row Card & Table Booking System
// =========================================================================

import 'package:flutter/material.dart';

class VenueCard extends StatelessWidget {
  final String title;
  final String address;
  final String activeSwapsCount;
  final String imageUrl;
  final List<Map<String, String>> activeNotices;

  const VenueCard({
    super.key,
    required this.title,
    required this.address,
    required this.activeSwapsCount,
    required this.imageUrl,
    required this.activeNotices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16171A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. CAFE PICTURE INFRASTRUCTURE CONTAINER WITH NETWORK ERROR FALLBACKS
            Container(
              width: 90,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF202124), // Fallback dark backing layout
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  // SAFEGUARD LOOP: If an image fails to load or triggers a 401, this blocks the crash
                  // and replaces it with a beautiful, clean local asset icon for 0 SAR!
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF202124),
                      child: const Icon(
                        Icons.coffee_outlined,
                        color: Color(0xFFE5A93C),
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),

            // B. RIGHT INFO STACK DETAIL PANELS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Title & Verification Star Only (Bookmark tag permanently removed)
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFFE5A93C),
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Row 2: Location string & Activity counters mapping metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            address,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 11,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "• $activeSwapsCount active swaps",
                        style: const TextStyle(
                          color: Color(0xFF4BB543),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Row 3: Feature Capsule Indicator lists grid array
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFeatureTag(Icons.bolt, "Fast WiFi"),
                        _buildFeatureTag(Icons.power, "Power Outlets"),
                        _buildFeatureTag(Icons.volume_off, "Quiet Zone"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Row 4: THE LIVE IN-ROOM INTERACTIVE NOTICE BOARD ANNOUNCEMENTS
                  Row(
                    children: [
                      const Text(
                        "Live at Venue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "LIVE",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Loop and output the notice arrays dynamically
                  Column(
                    children: activeNotices
                        .map(
                          (notice) => _buildLiveNoticeRow(
                            notice['icon']!,
                            notice['text']!,
                            notice['time']!,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),

                  // Row 5: 🚀 THE PERSISTENT FREE RESERVE STUDY TABLE CALL-TO-ACTION BUTTON
                  InkWell(
                    onTap: () {
                      debugPrint(
                        "Invoking seat assignment logic pipeline for $title... Initializing free token context pass.",
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC89B3C), Color(0xFFE1B35C)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'RESERVE STUDY TABLE (0 SAR)',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTag(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE5A93C), size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveNoticeRow(String type, String message, String timeStamp) {
    IconData noticeIcon = Icons.chat_bubble_outline;
    // Updated icon mapping hooks supporting your clean lifestyle category tracks!
    if (type == 'coding') {
      noticeIcon = Icons.code_rounded;
    } else if (type == 'shopping') {
      noticeIcon = Icons.shopping_bag_outlined;
    } else if (type == 'walking') {
      noticeIcon = Icons.directions_walk_rounded;
    } else if (type == 'padel' || type == 'tennis') {
      noticeIcon = Icons.sports_tennis_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            noticeIcon,
            color: const Color(0xFFE5A93C).withValues(alpha: 0.6),
            size: 13,
          ),
          // Subtle gold tint icon
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                height: 1.2,
                fontFamily: 'Plus Jakarta Sans',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            timeStamp,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 9,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}
