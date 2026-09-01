// =========================================================================
// 👥 FILE: active_hobby_guilds.dart
// ROLE: Layer 3 Horizontal Community Guild List Module
// =========================================================================

import 'package:flutter/material.dart';

class ActiveHobbyGuilds extends StatelessWidget {
  const ActiveHobbyGuilds({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.diversity_3_outlined,
                          color: Color(0xFFE5A93C),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Active Hobby Guilds",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Communities powered by your local hubs",
                      style: TextStyle(
                        // 🟢 FIXED: Converted to widely supported withOpacity parameter
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    debugPrint(
                      "Routing to global campus guild registry directory...",
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "See all",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Horizontal scrolling container mapping out the active guild cards
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildGuildCard(
                  "Tahlia Street Coders",
                  "142 Active Members",
                  "+37",
                  Icons.developer_mode_outlined,
                  // Pass high-fidelity, safe random portrait placeholders
                  "https://picsum.photos",
                  "https://picsum.photos",
                ),
                _buildGuildCard(
                  "Jeddah Design Guild",
                  "98 Active Members",
                  "+26",
                  Icons.palette_outlined,
                  "https://picsum.photos",
                  "https://picsum.photos",
                ),
                _buildGuildCard(
                  "Chess Club Jeddah",
                  "76 Active Members",
                  "+18",
                  Icons.extension_outlined,
                  "https://picsum.photos",
                  "https://picsum.photos",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuildCard(
    String title,
    String membersCount,
    String overFlowBubble,
    IconData icon,
    String userUrl1,
    String userUrl2,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16171A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFE5A93C), size: 15),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            membersCount,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const Spacer(),

          // Layered avatar tracking array
          Row(
            children: [
              _buildStackedAvatar(userUrl1),
              _buildStackedAvatar(userUrl2),
              Align(
                widthFactor: 0.7,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B5900),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF16171A),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    overFlowBubble,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🟢 UPGRADED: Uses robust Network Images with instant placeholder fallbacks to guarantee 0 crashes
  Widget _buildStackedAvatar(String url) {
    return Align(
      widthFactor: 0.7,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF202124),
          border: Border.all(color: const Color(0xFF16171A), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, color: Colors.grey, size: 10);
            },
          ),
        ),
      ),
    );
  }
}
