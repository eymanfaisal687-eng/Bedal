import 'package:flutter/material.dart';

// ============================================================================
// 📄 FILE: chat_categories.dart
// PURPOSE: Filter Control for Bedal chats with gold sliding pill and white inner text when active.
// ============================================================================

enum ChatCategory {
  mentors,
  learners,
  hobbyists,
  groups,
}

extension ChatCategoryExtension on ChatCategory {
  String get label {
    switch (this) {
      case ChatCategory.mentors:
        return 'Mentors';
      case ChatCategory.learners:
        return 'Learners';
      case ChatCategory.hobbyists:
        return 'Hobbyists';
      case ChatCategory.groups:
        return 'Groups';
    }
  }

  IconData get icon {
    switch (this) {
      case ChatCategory.mentors:
        return Icons.person_outline_rounded;
      case ChatCategory.learners:
        return Icons.school_outlined;
      case ChatCategory.hobbyists:
        return Icons.groups_outlined;
      case ChatCategory.groups:
        return Icons.forum_outlined;
    }
  }
}

class ChatCategories extends StatefulWidget {
  final ChatCategory selectedCategory;
  final ValueChanged<ChatCategory> onCategorySelected;

  const ChatCategories({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<ChatCategories> createState() => _ChatCategoriesState();
}

class _ChatCategoriesState extends State<ChatCategories> {
  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF25231F);
  static const Color toggleBorder = Color(0xFFE5DDCC);
  static const Color containerBg = Color(0xFFF1EEE7);

  double _dragExtent = 0.0;

  void _handleHorizontalDragUpdate(DragUpdateDetails details, double totalWidth) {
    if (totalWidth <= 0) return;
    setState(() {
      _dragExtent += details.delta.dx;
      final currentIndex = ChatCategory.values.indexOf(widget.selectedCategory);
      final sectionWidth = totalWidth / 4;
      final minExtent = -currentIndex * sectionWidth;
      final maxExtent = (ChatCategory.values.length - 1 - currentIndex) * sectionWidth;
      _dragExtent = _dragExtent.clamp(minExtent, maxExtent);
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details, double totalWidth) {
    if (totalWidth <= 0) return;
    final currentIndex = ChatCategory.values.indexOf(widget.selectedCategory);
    final sectionWidth = totalWidth / 4;

    final deltaIndex = (_dragExtent / sectionWidth).round();
    final newIndex = (currentIndex + deltaIndex).clamp(0, ChatCategory.values.length - 1);

    widget.onCategorySelected(ChatCategory.values[newIndex]);
    setState(() {
      _dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ChatCategory.values.indexOf(widget.selectedCategory);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final sectionWidth = totalWidth / 4;

        double baseAlignment = -1.0 + (selectedIndex * (2.0 / 3.0));
        double dragOffset = (totalWidth > 0) ? (_dragExtent / sectionWidth) * (2.0 / 3.0) : 0.0;
        double finalAlignment = (baseAlignment + dragOffset).clamp(-1.0, 1.0);

        return GestureDetector(
          onHorizontalDragUpdate: (details) => _handleHorizontalDragUpdate(details, totalWidth),
          onHorizontalDragEnd: (details) => _handleHorizontalDragEnd(details, totalWidth),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: containerBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: toggleBorder,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // 1. SLIDING GOLD HIGHLIGHT
                Align(
                  alignment: Alignment(finalAlignment, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.25,
                    heightFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),

                // 2. INTERACTIVE CATEGORY BUTTONS
                Positioned.fill(
                  child: Row(
                    children: ChatCategory.values.map((category) {
                      final isSelected = category == widget.selectedCategory;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onCategorySelected(category),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 15,
                                  color: isSelected
                                      ? Colors.white
                                      : charcoal.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    category.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: isSelected
                                          ? Colors.white
                                          : charcoal.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
