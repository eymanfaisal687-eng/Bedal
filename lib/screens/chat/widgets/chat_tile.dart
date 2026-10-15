import 'package:flutter/material.dart';
import 'chat_categories.dart';

// ============================================================================
// 📄 FILE: chat_tile.dart
// PURPOSE: Ultra-polished individual WhatsApp-style conversation card for Bedal:
//          - Crisp white/light card container with rounded corners and subtle shadow
//          - Avatar with online status indicator dot
//          - Name + Gold verified badge
//          - Refined skill-exchange pill [ Skill 1 ⇄ Skill 2 ]
//          - Message preview and right-flank time / unread / coin hours badge
// ============================================================================

enum UserStatus {
  active,  // Green dot
  away,    // Yellow dot
  offline, // White dot
}

class ChatTile extends StatelessWidget {
  final String name;
  final String? avatarAsset;
  final bool isVerified;
  final UserStatus status;
  final String skillExchange;
  final String? customMessage;
  final ChatCategory category;
  final String time;
  final int unreadCount;
  final String? hoursIndicator;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.name,
    this.avatarAsset,
    this.isVerified = false,
    this.status = UserStatus.active,
    required this.skillExchange,
    this.customMessage,
    required this.category,
    required this.time,
    this.unreadCount = 0,
    this.hoursIndicator,
    this.onTap,
  });

  static const Color charcoal = Color(0xFF25231F);
  static const Color gold = Color(0xFFC5A059);
  static const Color iconBrown = Color(0xFF9E7B3B);
  static const Color mutedText = Color(0xFF7A7368);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color unreadCardBg = Color(0xFFFAF5EC);
  static const Color softBorder = Color(0xFFE5DDCC);

  // Status Colors
  static const Color statusActive = Color(0xFF2ECC71); // Green
  static const Color statusAway = Color(0xFFF1C40F);   // Yellow
  static const Color statusOffline = Colors.white;     // White

  String get subtextMessage {
    if (customMessage != null && customMessage!.trim().isNotEmpty) {
      return customMessage!;
    }

    final String skill = skillExchange.split('•').first.trim();

    switch (category) {
      case ChatCategory.hobbyists:
        return 'Hey! Are you free for the $skill swap this weekend?';

      case ChatCategory.mentors:
        return "Thanks for the great teaching session today! Let me know when you're free next.";

      case ChatCategory.learners:
        return 'Thanks for the great teaching session today! Let me know when you\'re free next.';

      case ChatCategory.groups:
        return 'Upcoming $skill workshop session details posted in Hubs!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = unreadCount > 0;
    final bool hasHours = hoursIndicator != null && hoursIndicator!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasUnread ? unreadCardBg : cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasUnread ? gold.withValues(alpha: 0.4) : softBorder,
                width: hasUnread ? 1.2 : 0.9,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ------------------------------------------------------------
                // 1. AVATAR WITH USER STATUS DOT
                // ------------------------------------------------------------
                _buildAvatar(),

                const SizedBox(width: 14),

                // ------------------------------------------------------------
                // 2. CONVERSATION DETAILS
                // ------------------------------------------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name + Verified Badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: charcoal,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              color: gold,
                              size: 15,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Single Skill Exchange Pill [ Skill 1  ⇄  Skill 2 ]
                      _buildSkillExchangeTag(),

                      const SizedBox(height: 6),

                      // Snippet Subtext
                      Text(
                        subtextMessage,
                        style: const TextStyle(
                          color: mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Plus Jakarta Sans',
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ------------------------------------------------------------
                // 3. RIGHT-FLANK: TIME + UNREAD BADGE / COIN INDICATOR
                // ------------------------------------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (hasUnread)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: gold,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      )
                    else if (hasHours)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EFE3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFE2D4BD),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/icons/bedal_coin.png',
                              width: 13,
                              height: 13,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.monetization_on_rounded,
                                color: gold,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hoursIndicator!,
                              style: const TextStyle(
                                color: iconBrown,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // AVATAR WIDGET WITH STATUS DOT
  // ============================================================================

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: gold.withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: (avatarAsset != null && avatarAsset!.isNotEmpty)
                ? Image.asset(
                    avatarAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackAvatar(),
                  )
                : _buildFallbackAvatar(),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: _buildStatusDot(),
        ),
      ],
    );
  }

  Widget _buildStatusDot() {
    Color dotColor;
    Color borderColor;

    switch (status) {
      case UserStatus.active:
        dotColor = statusActive;
        borderColor = Colors.white;
        break;
      case UserStatus.away:
        dotColor = statusAway;
        borderColor = Colors.white;
        break;
      case UserStatus.offline:
        dotColor = statusOffline;
        borderColor = const Color(0xFFB0B0B0);
        break;
    }

    return Container(
      width: 13.5,
      height: 13.5,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: const Color(0xFFEFECE4),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'B',
          style: const TextStyle(
            color: iconBrown,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // SKILL EXCHANGE PILL [ Skill 1  ⇄  Skill 2 ]
  // ============================================================================

  Widget _buildSkillExchangeTag() {
    final clean = skillExchange.replaceAll('↔', '•').replaceAll('/', '•');
    final parts =
        clean.split('•').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5D5B8),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (parts.length >= 2) ...[
            Text(
              parts[0],
              style: const TextStyle(
                color: iconBrown,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.swap_horiz_rounded,
              color: gold,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              parts[1],
              style: const TextStyle(
                color: iconBrown,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ] else ...[
            const Icon(
              Icons.swap_horiz_rounded,
              color: gold,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              skillExchange,
              style: const TextStyle(
                color: iconBrown,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
