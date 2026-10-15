import 'package:flutter/material.dart';

// ============================================================================
// 📄 FILE: chat_stories.dart
// PURPOSE: Active Stories row placed at the top of Bedal Chat Screen:
//          - Fully clickable "Your Story" item and community user stories with gold rings.
// ============================================================================

class StoryItemData {
  final String id;
  final String name;
  final String? avatarAsset;

  const StoryItemData({
    required this.id,
    required this.name,
    this.avatarAsset,
  });
}

class ChatStories extends StatelessWidget {
  final VoidCallback? onAddStoryTap;
  final ValueChanged<StoryItemData>? onStoryTap;
  final VoidCallback? onMoreTap;

  const ChatStories({
    super.key,
    this.onAddStoryTap,
    this.onStoryTap,
    this.onMoreTap,
  });

  static const Color charcoal = Color(0xFF25231F);
  static const Color gold = Color(0xFFC5A059);

  static const List<StoryItemData> _sampleStories = [
    StoryItemData(
      id: '1',
      name: 'Sara Ali',
      avatarAsset: 'assets/images/character_images/sara.png',
    ),
    StoryItemData(
      id: '2',
      name: 'Omar K.',
      avatarAsset: 'assets/images/character_images/omar.png',
    ),
    StoryItemData(
      id: '3',
      name: 'Reem A.',
      avatarAsset: 'assets/images/character_images/reem.png',
    ),
    StoryItemData(
      id: '4',
      name: 'Khalid Q.',
      avatarAsset: 'assets/images/profile/character_profile/male_characters/saudi_man.png',
    ),
    StoryItemData(
      id: '5',
      name: 'Lama',
      avatarAsset: null, // Fallback 'L' circle
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _sampleStories.length + 1, // 1 for "Your Story"
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildYourStoryItem(context);
          }

          final story = _sampleStories[index - 1];
          return _buildUserStoryItem(context, story);
        },
      ),
    );
  }

  // ============================================================================
  // YOUR STORY ITEM
  // ============================================================================

  Widget _buildYourStoryItem(BuildContext context) {
    return GestureDetector(
      onTap: onAddStoryTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('📸 Add to your Bedal Story')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: gold,
                width: 1.8,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEFECE4),
                  ),
                  child: Center(
                    child: Text(
                      'Y',
                      style: TextStyle(
                        color: gold.withValues(alpha: 0.95),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: gold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your Story',
            style: TextStyle(
              color: charcoal,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // USER STORY ITEM
  // ============================================================================

  Widget _buildUserStoryItem(BuildContext context, StoryItemData story) {
    return GestureDetector(
      onTap: () {
        if (onStoryTap != null) {
          onStoryTap!(story);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing story by ${story.name}')),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(2.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: gold,
                width: 1.8,
              ),
            ),
            child: ClipOval(
              child: (story.avatarAsset != null &&
                      story.avatarAsset!.isNotEmpty)
                  ? Image.asset(
                      story.avatarAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackAvatar(story.name),
                    )
                  : _buildFallbackAvatar(story.name),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 54,
            child: Text(
              story.name,
              style: const TextStyle(
                color: charcoal,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(String name) {
    return Container(
      color: const Color(0xFFEFECE4),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'B',
          style: const TextStyle(
            color: gold,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
    );
  }
}
