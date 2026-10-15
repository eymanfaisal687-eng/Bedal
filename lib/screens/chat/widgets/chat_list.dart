import 'package:flutter/material.dart';
import 'chat_categories.dart';
import 'chat_tile.dart';

// ============================================================================
// 📄 FILE: chat_list.dart
// PURPOSE: Primary content section of Bedal Chat screen. Displays filtered
//          conversations with uniform card styling across all chats.
// ============================================================================

class ChatConversationModel {
  final String id;
  final String name;
  final String? avatarAsset;
  final bool isVerified;
  final UserStatus status;
  final String skillExchange;
  final String? customMessage;
  final String time;
  final int unreadCount;
  final String? hoursIndicator;
  final ChatCategory category;

  const ChatConversationModel({
    required this.id,
    required this.name,
    this.avatarAsset,
    this.isVerified = false,
    this.status = UserStatus.active,
    required this.skillExchange,
    this.customMessage,
    required this.time,
    this.unreadCount = 0,
    this.hoursIndicator,
    required this.category,
  });
}

class ChatList extends StatelessWidget {
  final ChatCategory selectedCategory;
  final String searchQuery;
  final Function(ChatConversationModel)? onChatTap;

  const ChatList({
    super.key,
    required this.selectedCategory,
    this.searchQuery = '',
    this.onChatTap,
  });

  static const Color charcoal = Color(0xFF25231F);
  static const Color gold = Color(0xFFC5A059);

  // Sample data with uniform card styling matching Omar K. across all chats
  static const List<ChatConversationModel> _sampleChats = [
    // MENTORS
    ChatConversationModel(
      id: '1',
      name: 'Sara Ali',
      avatarAsset: null, // Renders beige 'S' avatar with green dot
      isVerified: true,
      status: UserStatus.active,
      skillExchange: 'UI/UX ↔ Figma',
      customMessage: 'Thanks for the great teaching session today!',
      time: '12:15 PM',
      hoursIndicator: '1.5h',
      category: ChatCategory.mentors,
    ),
    ChatConversationModel(
      id: '2',
      name: 'Omar K.',
      avatarAsset: 'assets/images/character_images/omar.png',
      isVerified: true,
      status: UserStatus.active,
      skillExchange: 'Flutter ↔ Architecture',
      customMessage: 'Thank you for guiding me through the widget tree architecture.',
      time: 'Yesterday',
      hoursIndicator: '2.0h',
      category: ChatCategory.mentors,
    ),
    ChatConversationModel(
      id: '3',
      name: 'Reem A.',
      avatarAsset: 'assets/images/character_images/reem.png',
      isVerified: true,
      status: UserStatus.active,
      skillExchange: 'Flutter ↔ UI Design',
      customMessage: 'Hey! Are you free for the UI Design swap tomorrow?',
      time: '7:00 AM',
      hoursIndicator: '1.0h',
      category: ChatCategory.mentors,
    ),

    // HOBBYISTS
    ChatConversationModel(
      id: '4',
      name: 'Sara Ali',
      avatarAsset: 'assets/images/character_images/sara.png',
      isVerified: true,
      status: UserStatus.active,
      skillExchange: 'Cooking ↔ Photography',
      customMessage: 'Hey! Are you free for the photography swap this weekend?',
      time: '11:25 PM',
      hoursIndicator: '2.5h',
      category: ChatCategory.hobbyists,
    ),
    ChatConversationModel(
      id: '5',
      name: 'Khalid Q.',
      avatarAsset: 'assets/images/profile/character_profile/male_characters/saudi_man.png',
      isVerified: false,
      status: UserStatus.away,
      skillExchange: 'Calligraphy ↔ Design',
      customMessage: 'I sent you the digital brush set for calligraphy!',
      time: '2:30 AM',
      hoursIndicator: '1.0h',
      category: ChatCategory.hobbyists,
    ),

    // LEARNERS
    ChatConversationModel(
      id: '6',
      name: 'Reem A.',
      avatarAsset: 'assets/images/character_images/reem.png',
      isVerified: false,
      status: UserStatus.active,
      skillExchange: 'UI Design ↔ Dart',
      customMessage: "Thanks for the great teaching session today!",
      time: '10:00 AM',
      hoursIndicator: '1.5h',
      category: ChatCategory.learners,
    ),
    ChatConversationModel(
      id: '7',
      name: 'Lama',
      avatarAsset: null,
      isVerified: false,
      status: UserStatus.offline,
      skillExchange: 'Python ↔ Data Science',
      customMessage: 'I practiced the exercises you sent! Free for our next lesson?',
      time: '9:30 AM',
      hoursIndicator: '2.0h',
      category: ChatCategory.learners,
    ),

    // GROUPS
    ChatConversationModel(
      id: '8',
      name: 'Jeddah Design Guild',
      avatarAsset: 'assets/images/logo/bedal_icon.png',
      isVerified: true,
      status: UserStatus.active,
      skillExchange: 'UI/UX ↔ Design',
      customMessage: 'Faisal: Workshop this Saturday at Rowad Cafe!',
      time: '8:45 AM',
      hoursIndicator: '3.0h',
      category: ChatCategory.groups,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter by selected category
    final categoryFiltered = _sampleChats
        .where((chat) => chat.category == selectedCategory)
        .toList();

    final activeChats =
        categoryFiltered.isNotEmpty ? categoryFiltered : _sampleChats;

    // Filter by search query
    final filteredChats = activeChats.where((chat) {
      if (searchQuery.trim().isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return chat.name.toLowerCase().contains(q) ||
          chat.skillExchange.toLowerCase().contains(q) ||
          (chat.customMessage != null &&
              chat.customMessage!.toLowerCase().contains(q));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------------------
        // CHATS SECTION HEADING
        // --------------------------------------------------------------------
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Chats',
            style: TextStyle(
              color: charcoal,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),

        const SizedBox(height: 10),

        if (filteredChats.isEmpty)
          _buildEmptyState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredChats.length,
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return ChatTile(
                name: chat.name,
                avatarAsset: chat.avatarAsset,
                isVerified: chat.isVerified,
                status: chat.status,
                skillExchange: chat.skillExchange,
                customMessage: chat.customMessage,
                category: chat.category,
                time: chat.time,
                unreadCount: chat.unreadCount,
                hoursIndicator: chat.hoursIndicator,
                onTap: () => onChatTap?.call(chat),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: gold,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            searchQuery.trim().isNotEmpty
                ? 'No chats matching "$searchQuery"'
                : 'No conversations in ${selectedCategory.label}',
            style: const TextStyle(
              color: charcoal,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}
