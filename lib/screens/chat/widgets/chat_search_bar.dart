import 'package:flutter/material.dart';

// ============================================================================
// 📄 FILE: chat_search_bar.dart
// PURPOSE: Black Search Bar matching the Bedal Explore Screen styling.
// ============================================================================

class ChatSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  const ChatSearchBar({
    super.key,
    required this.onChanged,
    this.onFilterTap,
  });

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final TextEditingController _controller = TextEditingController();

  static const Color darkBackground = Color(0xFF16171A);
  static const Color gold = Color(0xFFC5A059);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: darkBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Plus Jakarta Sans',
        ),
        cursorColor: gold,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search chats, people or skills...',
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            fontFamily: 'Plus Jakarta Sans',
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 14, right: 8),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 42,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white54,
                    size: 16,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : (widget.onFilterTap != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                      onPressed: widget.onFilterTap,
                    )
                  : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
