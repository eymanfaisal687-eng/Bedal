import 'package:flutter/material.dart';
import '../../explore_screen.dart';

class ExploreToggle extends StatelessWidget {
  final ExploreMode selectedMode;
  final ValueChanged<ExploreMode> onChanged;

  const ExploreToggle({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color darkSurface = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    final bool isMentorSelected = selectedMode == ExploreMode.mentor;

    return Column(
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: darkSurface,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. SLIDING BACKGROUND HIGHLIGHT (Fills full half)
              AnimatedAlign(
                alignment: isMentorSelected ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
              ),
              
              // 2. INTERACTIVE BUTTONS
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: _toggleButton(
                        selected: isMentorSelected,
                        icon: Icons.school_rounded,
                        text: 'Find a Mentor',
                        onTap: () => onChanged(ExploreMode.mentor),
                      ),
                    ),
                    Expanded(
                      child: _toggleButton(
                        selected: !isMentorSelected,
                        icon: Icons.group_rounded,
                        text: 'Find a Learner',
                        onTap: () => onChanged(ExploreMode.learner),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            isMentorSelected
                ? 'Find people who can teach you a skill.'
                : 'Discover learners actively looking for help.',
            key: ValueKey(isMentorSelected),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF777269),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleButton({
    required bool selected,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? const Color(0xFF1A1B1E) : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                  color: selected ? const Color(0xFF1A1B1E) : const Color(0xFF9E9E9E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}