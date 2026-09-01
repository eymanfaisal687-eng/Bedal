// =========================================================================
// 🏢 FILE: venue_notice_board.dart
// ROLE: Layer 2 Section Structural Block - Managing Cafe Deck Data Matrix
// =========================================================================

import 'package:flutter/material.dart';
import 'venue_card.dart';

class VenueNoticeBoard extends StatelessWidget {
  const VenueNoticeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Heading matching your premium design weights
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16, top: 8),
            child: Text(
              "VERIFIED SAFE-ZONE HUBS",
              style: TextStyle(
                color: Color(0xFF7B5900),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),

          // Card Node 1: Draft Café Setup (Al Rawdah)
          const VenueCard(
            title: "Draft Café",
            address: "Al Rawdah, Jeddah",
            activeSwapsCount: "12",
            // 🟢 FIXED: High-fidelity direct placeholder to bypass 401 exception gates
            imageUrl: "https://picsum.photos",
            activeNotices: [
              {
                'icon': 'coding',
                'text':
                    'Coding Buddy: Sitting at Table 4 right now working on Flutter.',
                'time': '2m ago',
              },
              {
                'icon': 'shopping',
                // 🛍️ Added your brand-new shopping companion tag!
                'text':
                    'Shopping Partner: Heading to Red Sea Mall. Pull up here first.',
                'time': '12m ago',
              },
              {
                'icon': 'padel',
                'text':
                    'Padel Match: Need +1 player for Corniche courts at 9 PM.',
                'time': '15m ago',
              },
            ],
          ),
          const SizedBox(height: 8),

          // Card Node 2: Medd Café Setup (Al Balad)
          const VenueCard(
            title: "Medd Café",
            address: "Al Balad, Jeddah",
            activeSwapsCount: "5",
            // 🟢 FIXED: High-fidelity direct placeholder to bypass 401 exception gates
            imageUrl: "https://picsum.photos",
            activeNotices: [
              {
                'icon': 'walking',
                // 🚶‍♂️ Added your brand-new walking companion tag!
                'text':
                    'Walking Partner: Historic Al-Balad architectural photography stroll.',
                'time': '5m ago',
              },
              {
                'icon': 'design',
                'text':
                    'Design Hangout: Working on Figma UI kit. Come pull up a chair.',
                'time': '21m ago',
              },
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
