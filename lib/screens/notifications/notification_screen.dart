import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // ================================================================
  // BEDAL COLORS
  // ================================================================

  static const Color background = Color(0xFFF8F5EF);
  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ================================================================
      // HEADER
      // ================================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,

        // --------------------------------------------------------------
        // BACK BUTTON
        // --------------------------------------------------------------

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark,
            size: 20,
          ),

          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        // --------------------------------------------------------------
        // TITLE
        // --------------------------------------------------------------

        title: const Text(
          'Notifications',
          style: TextStyle(
            color: dark,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,

        // --------------------------------------------------------------
        // NO DEAD BUTTONS HERE
        // --------------------------------------------------------------

        actions: const [
          SizedBox(width: 48),
        ],
      ),

      // ================================================================
      // NOTIFICATION LIST
      // ================================================================

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          30,
        ),

        children: [

          // ============================================================
          // TODAY
          // ============================================================

          const _SectionTitle(
            title: 'Today',
          ),

          const SizedBox(height: 8),

          // ------------------------------------------------------------
          // FOLLOW
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.follow,
            title: 'Sara Ali followed you',
            subtitle:
            'You can now see each other’s updates.',
            time: '2m',
            isUnread: true,
            avatarAsset:
            'assets/images/character_images/sara.png',
            onTap: () {
              // TODO:
              // Open Sara's profile
            },
          ),

          // ------------------------------------------------------------
          // NEW VIDEO
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.video,
            title: 'Omar posted a new skill video',
            subtitle: 'Figma • UI Design',
            time: '8m',
            isUnread: true,
            avatarAsset:
            'assets/images/character_images/sara.png',
            onTap: () {
              // TODO:
              // Open Omar's skill video
            },
          ),

          // ------------------------------------------------------------
          // COMMENT
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.comment,
            title: 'Reem commented on your video',
            subtitle:
            '"This is actually so useful!"',
            time: '15m',
            isUnread: true,
            avatarAsset:
            'assets/images/character_images/sara.png',
            onTap: () {
              // TODO:
              // Open commented video
            },
          ),

          // ------------------------------------------------------------
          // CHAT
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.chat,
            title: 'New message from Ahmed',
            subtitle:
            'Hey! Are you free for a skill swap?',
            time: '24m',
            isUnread: true,
            avatarAsset:
            'assets/images/character_images/sara.png',
            onTap: () {
              // TODO:
              // Open chat
            },
          ),

          const SizedBox(height: 22),

          // ============================================================
          // EARLIER
          // ============================================================

          const _SectionTitle(
            title: 'Earlier',
          ),

          const SizedBox(height: 8),

          // ------------------------------------------------------------
          // COMMUNITY
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.community,
            title:
            'New activity in Jeddah Photography',
            subtitle:
            '3 people joined the community this week.',
            time: '2h',
            isUnread: false,
            onTap: () {
              // TODO:
              // Open community
            },
          ),

          // ------------------------------------------------------------
          // VIDEO
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.video,
            title:
            'Faisal posted a new skill video',
            subtitle: 'Cooking • Kabsa',
            time: '5h',
            isUnread: false,
            onTap: () {
              // TODO:
              // Open video
            },
          ),

          // ------------------------------------------------------------
          // FOLLOW
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.follow,
            title: 'You have a new follower',
            subtitle:
            'Someone discovered your profile.',
            time: 'Yesterday',
            isUnread: false,
            onTap: () {
              // TODO:
              // Open profile
            },
          ),

          // ------------------------------------------------------------
          // CAFE WALL COMMENT
          // ------------------------------------------------------------

          _NotificationTile(
            type: NotificationType.comment,
            title:
            'Sara commented on your Cafe Wall',
            subtitle:
            '"Love this place!"',
            time: 'Yesterday',
            isUnread: false,
            onTap: () {
              // TODO:
              // Open Cafe Wall post
            },
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// SECTION TITLE
// ===================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: NotificationScreen.dark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ===================================================================
// NOTIFICATION TYPE
// ===================================================================

enum NotificationType {
  follow,
  video,
  chat,
  comment,
  community,
}

// ===================================================================
// NOTIFICATION TILE
// ===================================================================

class _NotificationTile extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
  final String? avatarAsset;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
    this.avatarAsset,
    required this.onTap,
  });

  // ================================================================
  // ICON
  // ================================================================

  IconData get _icon {
    switch (type) {
      case NotificationType.follow:
        return Icons.person_add_alt_1_rounded;

      case NotificationType.video:
        return Icons.play_circle_outline_rounded;

      case NotificationType.chat:
        return Icons.chat_bubble_outline_rounded;

      case NotificationType.comment:
        return Icons.mode_comment_outlined;

      case NotificationType.community:
        return Icons.groups_outlined;
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Material(
        color: isUnread
            ? Colors.white
            : Colors.white.withValues(
          alpha: 0.70,
        ),
        borderRadius: BorderRadius.circular(18),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),

          child: Padding(
            padding: const EdgeInsets.all(14),

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,

              children: [

                // ======================================================
                // AVATAR + TYPE BADGE
                // ======================================================

                Stack(
                  clipBehavior: Clip.none,
                  children: [

                    _buildAvatar(),

                    Positioned(
                      right: -4,
                      bottom: -3,

                      child: Container(
                        width: 22,
                        height: 22,

                        decoration: BoxDecoration(
                          color:
                          NotificationScreen.gold,
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),

                        child: Icon(
                          _icon,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 13),

                // ======================================================
                // TEXT
                // ======================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,

                              style: TextStyle(
                                color:
                                NotificationScreen.dark,
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            time,
                            style: const TextStyle(
                              color:
                              NotificationScreen.muted,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,

                        style: const TextStyle(
                          color:
                          NotificationScreen.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                // ======================================================
                // UNREAD DOT
                // ======================================================

                if (isUnread) ...[
                  const SizedBox(width: 8),

                  Container(
                    width: 7,
                    height: 7,

                    decoration:
                    const BoxDecoration(
                      color:
                      NotificationScreen.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // AVATAR
  // ================================================================

  Widget _buildAvatar() {
    if (avatarAsset != null) {
      return Container(
        width: 52,
        height: 52,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          border: Border.all(
            color:
            NotificationScreen.gold.withValues(
              alpha: 0.22,
            ),
            width: 1.5,
          ),
        ),

        child: ClipOval(
          child: Image.asset(
            avatarAsset!,
            fit: BoxFit.cover,

            errorBuilder: (context,
                error,
                stackTrace,) {
              return _buildIconAvatar();
            },
          ),
        ),
      );
    }

    return _buildIconAvatar();
  }

  // ================================================================
  // FALLBACK ICON AVATAR
  // ================================================================

  Widget _buildIconAvatar() {
    return Container(
      width: 52,
      height: 52,

      decoration: BoxDecoration(
        color:
        NotificationScreen.gold.withValues(
          alpha: 0.10,
        ),
        shape: BoxShape.circle,
      ),

      child: Icon(
        _icon,
        color: NotificationScreen.gold,
        size: 23,
      ),
    );
  }
}