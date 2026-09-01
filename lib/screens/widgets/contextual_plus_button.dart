// =========================================================================
// ➕ FILE: contextual_plus_button.dart
// ROLE: Contextual Action Trigger Widget
// =========================================================================
// BEDAL BEHAVIOR:
//
// HOME  → Open camera → Record skill video
// EXPLORE → Open explore creation/actions
// HUBS → Open activity creation (Level 2+)
//
// IMPORTANT:
// This widget ONLY routes the action.
// Camera recording and form logic belong to their own screens.
// =========================================================================

import 'package:flutter/material.dart';

class ContextualPlusButton extends StatelessWidget {
  final int currentIndex;

  // HOME: Open camera → Record skill video
  final VoidCallback onOpenCamera;

  // EXPLORE: Open explore actions → Start group skill meetup
  final VoidCallback onOpenExploreMenu;

  // HUBS: Open activity creation → Community notice board
  final VoidCallback onOpenCasualForm;

  const ContextualPlusButton({
    super.key,
    required this.currentIndex,
    required this.onOpenCamera,
    required this.onOpenExploreMenu,
    required this.onOpenCasualForm,
  });

  // =========================================================================
  // BEDAL COLORS
  // =========================================================================

  static const Color gold = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
    // Determine context-specific icon
    IconData contextualIcon;
    switch (currentIndex) {
      case 0:
        contextualIcon = Icons.video_call_rounded;
        break;
      case 1:
        contextualIcon = Icons.groups_rounded;
        break;
      case 2:
        contextualIcon = Icons.campaign_rounded;
        break;
      default:
        contextualIcon = Icons.add_rounded;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handlePlusTap(context),
        borderRadius: BorderRadius.circular(12),
        splashColor: gold.withValues(alpha: 0.12),
        highlightColor: gold.withValues(alpha: 0.06),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9), // Thick white
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              contextualIcon,
              size: 26,
              color: Color(0xFFB88A32) // Sharp pure white for better visibility
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // CONTEXTUAL ROUTER
  // =========================================================================

  void _handlePlusTap(BuildContext context) {
    switch (currentIndex) {
    // =====================================================================
    // HOME
    // =====================================================================
    //
    // The Home + button has ONE purpose:
    //
    //     Open Camera
    //
    // No gallery.
    // No explore menu.
    // No swap menu.
    // No additional popup.
    //
    // The camera screen will handle the 15-second recording.
    // =====================================================================

      case 0:
        onOpenCamera();
        break;

    // =====================================================================
    // EXPLORE
    // =====================================================================

      case 1:
        onOpenExploreMenu();
        break;

    // =====================================================================
    // HUBS
    // =====================================================================

      case 2:
        _handleHubsAction(context);
        break;

    // =====================================================================
    // OTHER
    // =====================================================================

      default:
        debugPrint(
          'Bedal: Plus button disabled on dashboard index $currentIndex.',
        );
    }
  }

  // =========================================================================
  // HUB LEVEL CHECK
  // =========================================================================

  void _handleHubsAction(BuildContext context) {
    // Temporary value.
    //
    // Later this should come from the user's actual profile/account state.
    const int userLevel = 2;

    if (userLevel >= 2) {
      onOpenCasualForm();
      return;
    }

    _showLevelLockAlert(context);
  }

  // =========================================================================
  // LEVEL LOCK
  // =========================================================================

  void _showLevelLockAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: gold,
                size: 22,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Level 2 Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Reach Senior Pass (Level 2) to create and post activities in Hubs.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
