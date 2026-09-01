import 'package:flutter/material.dart';

class GuildsTab extends StatelessWidget {
  const GuildsTab({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color cream = Color(0xFFF8F5EF);

  // ===============================================================
  // TEMPORARY GUILD DATA
  // ===============================================================

  static const List<Guild> guilds = [
    Guild(
      name: 'Corniche Social Club',
      location: 'Jeddah Corniche',
      description:
      'People who enjoy walks, coffee and sunsets by the Red Sea.',
      members: '248',
      role: 'Member',
      activity: 'Very active',
      icon: Icons.waves_rounded,
    ),
    Guild(
      name: 'Historic Jeddah',
      location: 'Al-Balad',
      description:
      'Explore old Jeddah, hidden cafés and local culture together.',
      members: '186',
      role: 'Member',
      activity: 'Active today',
      icon: Icons.account_balance_rounded,
    ),
    Guild(
      name: 'Jeddah Creators',
      location: 'Various spots',
      description:
      'A community for designers, photographers and creative minds.',
      members: '124',
      role: 'Member',
      activity: 'Active',
      icon: Icons.palette_outlined,
    ),
    Guild(
      name: 'Coffee Explorers',
      location: 'Jeddah',
      description:
      'Discover cafés and meet new people around the city.',
      members: '312',
      role: 'Member',
      activity: 'Very active',
      icon: Icons.local_cafe_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ===========================================================
        // HEADER
        // ===========================================================

        Row(
          children: [

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    'My Guilds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: dark,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Communities and places I belong to.',
                    style: TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),

            // Guild count

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${guilds.length} joined',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: gold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ===========================================================
        // GUILD LIST
        // ===========================================================

        ...guilds
            .asMap()
            .entries
            .map(
              (entry) {
            final index = entry.key;
            final guild = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == guilds.length - 1
                    ? 0
                    : 12,
              ),
              child: _GuildCard(
                guild: guild,
                onTap: () {
                  _openGuild(context, guild);
                },
              ),
            );
          },
        ),

        const SizedBox(height: 4),

        // ===========================================================
        // DISCOVER MORE
        // ===========================================================

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _discoverGuilds(context);
            },
            icon: const Icon(
              Icons.explore_outlined,
              size: 19,
            ),
            label: const Text(
              'Discover More Guilds',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: gold,
              side: BorderSide(
                color: gold.withValues(alpha: 0.35),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =================================================================
  // OPEN GUILD
  // =================================================================

  void _openGuild(BuildContext context,
      Guild guild,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            22,
            14,
            22,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Handle

              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 22),

              // Guild icon

              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  guild.icon,
                  color: gold,
                  size: 30,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                guild.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: dark,
                ),
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: gold,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    guild.location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                guild.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: muted,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: _GuildStat(
                      icon: Icons.people_outline_rounded,
                      value: guild.members,
                      label: 'Members',
                    ),
                  ),

                  Expanded(
                    child: _GuildStat(
                      icon: Icons.badge_outlined,
                      value: guild.role,
                      label: 'Your role',
                    ),
                  ),

                  Expanded(
                    child: _GuildStat(
                      icon: Icons.bolt_rounded,
                      value: guild.activity,
                      label: 'Activity',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Enter Guild',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =================================================================
  // DISCOVER GUILDS
  // =================================================================

  void _discoverGuilds(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Guild discovery is coming soon ✨',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ===================================================================
// GUILD CARD
// ===================================================================

class _GuildCard extends StatelessWidget {
  final Guild guild;
  final VoidCallback onTap;

  const _GuildCard({
    required this.guild,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFC5A059).withValues(alpha: 0.13),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [

              // =====================================================
              // GUILD ICON
              // =====================================================

              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A059)
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  guild.icon,
                  color: const Color(0xFFC5A059),
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              // =====================================================
              // INFORMATION
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      guild.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF25231F),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [

                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Color(0xFFC5A059),
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            guild.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF777269),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [

                        const Icon(
                          Icons.people_outline_rounded,
                          size: 14,
                          color: Color(0xFF9B968D),
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${guild.members} members',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9B968D),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5A059),
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Flexible(
                          child: Text(
                            guild.activity,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9B968D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // ROLE + ARROW
              // =====================================================

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5A059)
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      guild.role,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC5A059),
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFF9B968D),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// GUILD STAT
// ===================================================================

class _GuildStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _GuildStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Icon(
          icon,
          size: 20,
          color: const Color(0xFFC5A059),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF25231F),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF777269),
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// GUILD MODEL
// ===================================================================

class Guild {
  final String name;
  final String location;
  final String description;
  final String members;
  final String role;
  final String activity;
  final IconData icon;

  const Guild({
    required this.name,
    required this.location,
    required this.description,
    required this.members,
    required this.role,
    required this.activity,
    required this.icon,
  });
}