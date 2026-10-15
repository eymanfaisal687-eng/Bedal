import 'package:flutter/material.dart';

import 'package:bedal/models/swap_session_model.dart';
import 'package:bedal/screens/chat/swap/coordination_chat_view.dart';
import '../explore/widgets/workshops/workshop_chat_screen.dart';
import 'widgets/active_schedules.dart';
import 'widgets/chat_categories.dart';
import 'widgets/chat_list.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_stories.dart';

// ============================================================================
// 📄 FILE: chat_screen.dart
// PURPOSE: Refined Bedal Chat Screen with full-screen horizontal swipe sensitivity
//          allowing users to swipe anywhere left/right to switch chat categories.
// ============================================================================

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatCategory _selectedCategory = ChatCategory.mentors;
  String _searchQuery = '';
  double _dragExtent = 0.0;

  static const Color exploreBackground = Color(0xFFF8F5EF);
  static const Color charcoal = Color(0xFF25231F);
  static const Color dividerColor = Color(0xFFE5DDCC);

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final currentIndex = ChatCategory.values.indexOf(_selectedCategory);

    if (_dragExtent < -40 || details.velocity.pixelsPerSecond.dx < -300) {
      if (currentIndex < ChatCategory.values.length - 1) {
        setState(() {
          _selectedCategory = ChatCategory.values[currentIndex + 1];
        });
      }
    } else if (_dragExtent > 40 || details.velocity.pixelsPerSecond.dx > 300) {
      if (currentIndex > 0) {
        setState(() {
          _selectedCategory = ChatCategory.values[currentIndex - 1];
        });
      }
    }

    setState(() {
      _dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleHorizontalDragUpdate,
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      child: Scaffold(
        backgroundColor: exploreBackground,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: exploreBackground,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  // ------------------------------------------------------------
                  // 1. ACTIVE STORIES ROW ON TOP
                  // ------------------------------------------------------------
                  ChatStories(
                    onAddStoryTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📸 Add to your Bedal Story'),
                          backgroundColor: charcoal,
                        ),
                      );
                    },
                    onStoryTap: (story) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing story by ${story.name}'),
                          backgroundColor: charcoal,
                        ),
                      );
                    },
                    onMoreTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing all community stories'),
                          backgroundColor: charcoal,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // LIGHT GRAY DIVIDER LINE
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: dividerColor,
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------------------
                  // 2. ACTIVE SCHEDULES SUMMARY CARD
                  // ------------------------------------------------------------
                  ActiveSchedules(
                    onViewAllTap: () {
                      _showAllSchedulesSheet(context);
                    },
                    onUpcomingTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing 2 upcoming scheduled sessions'),
                          backgroundColor: charcoal,
                        ),
                      );
                    },
                    onCompletedTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing 5 completed sessions'),
                          backgroundColor: charcoal,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // LIGHT GRAY DIVIDER LINE
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: dividerColor,
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------------------
                  // 3. SEARCH BAR
                  // ------------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ChatSearchBar(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // LIGHT GRAY DIVIDER LINE BETWEEN SEARCH AND TOGGLE
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: dividerColor,
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------------------
                  // 4. CATEGORY FILTER TOGGLE (Supports full-screen horizontal swipe)
                  // ------------------------------------------------------------
                  ChatCategories(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // ------------------------------------------------------------
                  // 5. CONVERSATION LIST WITH ROUTING HANDSHAKE TO CoordinationChatView
                  // ------------------------------------------------------------
                  ChatList(
                    selectedCategory: _selectedCategory,
                    searchQuery: _searchQuery,
                    onChatTap: (chat) {
                      if (chat.category == ChatCategory.groups) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WorkshopChatScreen(
                              workshopTitle: chat.name,
                            ),
                          ),
                        );
                      } else {
                        final swapSession = SwapSession(
                          sessionId: chat.id,
                          peerName: chat.name,
                          peerAvatarUrl: chat.avatarAsset ??
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                          targetSkill: chat.skillExchange,
                          durationHours: 1.0,
                          activeStatus: SwapStatus.chatting,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CoordinationChatView(session: swapSession),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // ALL SCHEDULES SHEET
  // ============================================================================

  void _showAllSchedulesSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: charcoal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFFC59D56)),
                  SizedBox(width: 8),
                  Text(
                    'Active Scheduled Sessions',
                    style: TextStyle(
                      color: charcoal,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '• 2 Upcoming sessions scheduled\n• 5 Completed sessions verified',
                style: TextStyle(
                  color: charcoal,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
