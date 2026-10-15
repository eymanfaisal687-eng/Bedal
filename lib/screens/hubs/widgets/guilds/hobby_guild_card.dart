import 'package:flutter/material.dart';
import '../../models/hub_models.dart';

class HobbyGuildCard extends StatelessWidget {
  final HobbyGuild guild;

  const HobbyGuildCard({
    super.key,
    required this.guild,
  });

  static const Color primaryGold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color mutedText = Color(0xFF7A7368);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE3E0D6);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(guild.userAvatar),
                  ),
                  if (guild.isUserOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60),
                          shape: BoxShape.circle,
                          border: Border.all(color: cardBg, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          guild.userName,
                          style: const TextStyle(
                            color: charcoal,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_user_rounded, color: primaryGold, size: 15),
                        if (guild.userAge != null || guild.communityType != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${guild.userAge ?? ''}${guild.userAge != null && guild.communityType != null ? ' · ' : ''}${guild.communityType ?? ''}',
                              style: const TextStyle(
                                color: primaryGold,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: primaryGold, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${guild.locationName} · ${guild.neighborhood}',
                          style: const TextStyle(
                            color: mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                guild.timeAgo,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          Text(
            guild.title,
            style: const TextStyle(
              color: charcoal,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            guild.description,
            style: const TextStyle(
              color: mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 20),
          // Actions
          Row(
            children: [
              // Participants peeking
              SizedBox(
                width: 70,
                height: 28,
                child: Stack(
                  children: List.generate(guild.participantAvatars.length, (index) {
                    return Positioned(
                      left: index * 18.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cardBg, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(guild.participantAvatars[index]),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (guild.participantCount > guild.participantAvatars.length)
                Text(
                  '+${guild.participantCount - guild.participantAvatars.length}',
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: charcoal,
                      content: Text(
                        '✉️ Invite sent to ${guild.userName}!',
                        style: const TextStyle(color: primaryGold, fontFamily: 'Plus Jakarta Sans'),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGold,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send_rounded, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Send Invite',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: kWarmIvory,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group_rounded, color: primaryGold, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${guild.participantCount}',
                      style: const TextStyle(
                        color: charcoal,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const Color kWarmIvory = Color(0xFFF8F5EC);
}
