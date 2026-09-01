import 'package:flutter/material.dart';

class CafeWallsTab extends StatelessWidget {
  const CafeWallsTab({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color cream = Color(0xFFF8F5EF);

  // ===============================================================
  // TEMPORARY MEMORY DATA
  // ===============================================================

  static const List<CafeMemory> memories = [
    CafeMemory(
      type: MemoryType.photo,
      title: 'A beautiful evening in Jeddah',
      location: 'Jeddah Corniche',
      date: '2 days ago',
      caption: 'Golden hour by the Red Sea 🌅',
      icon: Icons.waves_rounded,
    ),
    CafeMemory(
      type: MemoryType.photo,
      title: 'Balad weekend',
      location: 'Al-Balad',
      date: '1 week ago',
      caption: 'Exploring old Jeddah with friends.',
      icon: Icons.account_balance_rounded,
    ),
    CafeMemory(
      type: MemoryType.video,
      title: 'Coffee meetup',
      location: 'Al Rawdah',
      date: '2 weeks ago',
      caption: 'Met some amazing people through Bedal ☕',
      icon: Icons.play_arrow_rounded,
    ),
    CafeMemory(
      type: MemoryType.photo,
      title: 'First Bedal meetup',
      location: 'Jeddah',
      date: '3 weeks ago',
      caption: 'Some memories are worth keeping.',
      icon: Icons.people_alt_outlined,
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
                    'Café Wall',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: dark,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Memories from your Bedal journey.',
                    style: TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),

            // Add memory button

            Material(
              color: gold,
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                onTap: () {
                  _showAddMemorySheet(context);
                },
                borderRadius: BorderRadius.circular(13),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ===========================================================
        // MEMORY FEED
        // ===========================================================

        ...memories
            .asMap()
            .entries
            .map(
              (entry) {
            final index = entry.key;
            final memory = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == memories.length - 1
                    ? 0
                    : 16,
              ),
              child: _MemoryCard(
                memory: memory,
                onTap: () {
                  _openMemory(context, memory);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // =================================================================
  // OPEN MEMORY
  // =================================================================

  void _openMemory(BuildContext context,
      CafeMemory memory,) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF34322E),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Icon(
                        memory.type == MemoryType.video
                            ? Icons.play_circle_fill_rounded
                            : memory.icon,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  memory.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  memory.caption,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFFC5A059),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      memory.location,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFC5A059),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =================================================================
  // ADD MEMORY SHEET
  // =================================================================

  void _showAddMemorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            24,
            14,
            24,
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

              const SizedBox(height: 24),

              const Text(
                'Add to Café Wall',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: dark,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Save a moment from your Bedal journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: muted,
                ),
              ),

              const SizedBox(height: 22),

              _AddMemoryOption(
                icon: Icons.photo_library_outlined,
                title: 'Add Photos',
                subtitle: 'Share personal or meetup photos',
                onTap: () {},
              ),

              _AddMemoryOption(
                icon: Icons.video_library_outlined,
                title: 'Add Video',
                subtitle: 'Share a short memory',
                onTap: () {},
              ),

              _AddMemoryOption(
                icon: Icons.camera_alt_outlined,
                title: 'Take a Photo',
                subtitle: 'Capture a new memory',
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===================================================================
// MEMORY CARD
// ===================================================================

class _MemoryCard extends StatelessWidget {
  final CafeMemory memory;
  final VoidCallback onTap;

  const _MemoryCard({
    required this.memory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFC5A059).withValues(alpha: 0.13),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================================
              // MEDIA
              // =====================================================

              AspectRatio(
                aspectRatio: 4 / 5,
                child: Stack(
                  children: [

                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE8DCC6),
                              Color(0xFFF7F3EB),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            memory.icon,
                            size: 62,
                            color: const Color(0xFFC5A059)
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),

                    // Video play button

                    if (memory.type == MemoryType.video)
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFFC5A059),
                            size: 34,
                          ),
                        ),
                      ),

                    // Memory type

                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(
                              memory.type == MemoryType.video
                                  ? Icons.videocam_outlined
                                  : Icons.photo_outlined,
                              size: 13,
                              color: const Color(0xFF25231F),
                            ),

                            const SizedBox(width: 5),

                            Text(
                              memory.type == MemoryType.video
                                  ? 'Video'
                                  : 'Photo',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF25231F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Location

                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.48),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: Colors.white,
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  memory.location,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // MEMORY INFORMATION
              // =====================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  14,
                  15,
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Text(
                            memory.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF25231F),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          memory.date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9B968D),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      memory.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF777269),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [

                        const Icon(
                          Icons.favorite_border_rounded,
                          size: 17,
                          color: Color(0xFF9B968D),
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          'Memory',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9B968D),
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.more_horiz_rounded,
                          size: 20,
                          color: Color(0xFF9B968D),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// ADD MEMORY OPTION
// ===================================================================

class _AddMemoryOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddMemoryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [

                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A059)
                        .withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFC5A059),
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF25231F),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777269),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9B968D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// MEMORY TYPE
// ===================================================================

enum MemoryType {
  photo,
  video,
}

// ===================================================================
// MEMORY MODEL
// ===================================================================

class CafeMemory {
  final MemoryType type;
  final String title;
  final String location;
  final String date;
  final String caption;
  final IconData icon;

  const CafeMemory({
    required this.type,
    required this.title,
    required this.location,
    required this.date,
    required this.caption,
    required this.icon,
  });
}