import 'package:flutter/material.dart';
import 'workshop_hub_sheet.dart'; // 🟢 Links directly to your popup file!

// ========================================================================
// 📄 FILE: workshop_card.dart
// PURPOSE: Creates a single workshop card.
//
// CURRENT FEATURES:
// • Displays a workshop card design used in the Explore screen.
// • Shows a workshop icon with a glowing background effect.
// • Displays the workshop title and details.
// • Prevents text from overflowing the card.
// • Shows the number of available seats.
// • Makes the entire card clickable to open the workshop details sheet.
//
// FUTURE UPDATES:
// • TODO: Connect this card to a Workshop data model instead of fixed text.
// • TODO: Pass real workshop information when opening the Workshop Hub Sheet.
// • TODO: Load workshop details from the database in the future.
// ========================================================================

class WorkshopCard extends StatelessWidget {
  final String title;
  final String scheduleLine;
  final String seatsTag;
  final IconData cardIcon;
  final Color iconGlowColor;

  const WorkshopCard({
    super.key,
    required this.title,
    required this.scheduleLine,
    required this.seatsTag,
    required this.cardIcon,
    required this.iconGlowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E22), // Sleek high-contrast template block
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 🟢 SLIDES UP YOUR CLEAN EXTERNAL DRAWERS FILE
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF111214),
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (BuildContext context) => WorkshopHubSheet(title: title),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconGlowColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        cardIcon,
                        color: const Color(0xFFE5A93C),
                        size: 20,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withValues(alpha: 0.2),
                      size: 14,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  scheduleLine,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5A93C).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    seatsTag,
                    style: const TextStyle(
                      color: Color(0xFFE5A93C),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
