import 'package:flutter/material.dart';
import '../../explore_screen.dart';

// ============================================================================
// 📄 FILE: explore_toggle.dart
// PURPOSE: Explore Mode Toggle with borderless gold highlight and real-time smooth finger dragging
// ============================================================================

class ExploreToggle extends StatefulWidget {
  final ExploreMode selectedMode;
  final ValueChanged<ExploreMode> onChanged;

  const ExploreToggle({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  State<ExploreToggle> createState() => _ExploreToggleState();
}

class _ExploreToggleState extends State<ExploreToggle> {
  static const Color gold = Color(0xFFC5A059);
  static const Color darkSurface = Color(0xFF16171A);

  double _dragExtent = 0.0;

  void _handleHorizontalDragUpdate(DragUpdateDetails details, double halfWidth) {
    if (halfWidth <= 0) return;
    setState(() {
      _dragExtent += details.delta.dx;
      _dragExtent = _dragExtent.clamp(-halfWidth, halfWidth);
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details, double halfWidth) {
    if (halfWidth <= 0) return;
    final threshold = halfWidth * 0.3;
    if (_dragExtent > threshold || details.velocity.pixelsPerSecond.dx < -300) {
      widget.onChanged(ExploreMode.learner);
    } else if (_dragExtent < -threshold || details.velocity.pixelsPerSecond.dx > 300) {
      widget.onChanged(ExploreMode.mentor);
    }
    setState(() {
      _dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMentorSelected = widget.selectedMode == ExploreMode.mentor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final halfWidth = totalWidth / 2;

        // Calculate visual alignment offset based on drag
        double baseAlignment = isMentorSelected ? -1.0 : 1.0;
        double dragOffset = (_dragExtent / halfWidth);
        double finalAlignment = (baseAlignment + dragOffset).clamp(-1.0, 1.0);

        return GestureDetector(
          onHorizontalDragUpdate: (details) => _handleHorizontalDragUpdate(details, halfWidth),
          onHorizontalDragEnd: (details) => _handleHorizontalDragEnd(details, halfWidth),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: darkSurface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 1. SLIDING GOLD HIGHLIGHT (Borderless, smooth real-time drag)
                    Align(
                      alignment: Alignment(finalAlignment, 0),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(24),
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
                              onTap: () => widget.onChanged(ExploreMode.mentor),
                            ),
                          ),
                          Expanded(
                            child: _toggleButton(
                              selected: !isMentorSelected,
                              icon: Icons.group_rounded,
                              text: 'Find a Learner',
                              onTap: () => widget.onChanged(ExploreMode.learner),
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
                    color: Color(0xFF7A7368),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              color: selected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Plus Jakarta Sans',
                  color: selected ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
