// =========================================================================
// ➕ FILE: contextual_plus_button.dart
// ROLE: Contextual Action Trigger Widget for Main Navigation Header Icons
// =========================================================================

import 'package:flutter/material.dart';
import 'package:bedal/models/swap_session_model.dart';
import 'package:bedal/screens/chat/swap/escrow_start_view.dart';
import 'package:bedal/screens/chat/swap/create_workshop_form.dart';
import 'package:bedal/screens/hubs/widgets/notice_board_sheet.dart';
import 'header_action_sheets.dart';

class ContextualPlusButton extends StatelessWidget {
  final int currentIndex;

  // HOME: Open camera / Creator studio menu
  final VoidCallback onOpenCamera;

  // EXPLORE: Open explore actions / Create workshop
  final VoidCallback onOpenExploreMenu;

  // HUBS: Open notice board sheet
  final VoidCallback onOpenCasualForm;

  const ContextualPlusButton({
    super.key,
    required this.currentIndex,
    required this.onOpenCamera,
    required this.onOpenExploreMenu,
    required this.onOpenCasualForm,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color darkCard = Color(0xFF1A1B1E);

  @override
  Widget build(BuildContext context) {
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
      case 3:
      default:
        contextualIcon = Icons.swap_horiz_rounded;
        break;
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
              color: Colors.white.withValues(alpha: 0.9),
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
              color: gold,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // CONTEXTUAL ROUTER FOR ALL 4 TAB HEADER ICONS
  // =========================================================================

  void _handlePlusTap(BuildContext context) {
    switch (currentIndex) {
      case 0:
        // 1. HOME TAB HEADER: CAMERA ICON OVERHAUL (Skill Reel & Café Wall)
        HeaderActionSheets.showHomeCameraMenu(context);
        break;

      case 1:
        // 2. EXPLORE TAB HEADER 1: HOST A GROUP WORKSHOP
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateWorkshopForm()),
        );
        break;

      case 2:
        // 3. EXPLORE TAB HEADER 2 / HUBS: NOTICE BOARD ICON
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const NoticeBoardSheet(activeCity: 'Islamabad'),
        );
        break;

      case 3:
      default:
        // 4. CHAT TAB HEADER: SKILL SWAP SPEED ICON (EscrowStartView)
        final sampleSession = SwapSession(
          sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
          peerName: 'Sara Ali',
          peerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
          targetSkill: 'UI/UX ↔ Figma',
          durationHours: 1.0,
          activeStatus: SwapStatus.initial,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EscrowStartView(session: sampleSession)),
        );
        break;
    }
  }
}
