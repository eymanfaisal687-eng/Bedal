import 'package:flutter/material.dart';
import '../../../widgets/main_layout.dart'; // 🟢 Import to access mainLayoutKey
import 'workshop_chat_screen.dart'; // 🟢 Import to access the new screen

// ========================================================================
// 📄 FILE: workshop_hub_sheet.dart
// PURPOSE: Shows the workshop details panel when a user opens a workshop.
//
// CURRENT FEATURES:
// • Displays a draggable bottom sheet with a close button.
// • Shows workshop participants with profile pictures.
// • Displays workshop details like location, time, and materials.
// • Shows a loading animation when joining a workshop.
// • Handles moving the user to the next screen after joining.
//
// FUTURE UPDATES:
// • TODO: Add a workshop ID to connect this screen with real workshop data.
// • TODO: Replace sample text with information from the database.
// • TODO: Connect the Join button with BLoC events.
// • TODO: Update seat numbers in Firebase when a user joins.
// • TODO: Check the user's Bedal Hour balance before allowing them to join.
// ========================================================================

class WorkshopHubSheet extends StatefulWidget {
  final String title;

  const WorkshopHubSheet({super.key, required this.title});

  @override
  State<WorkshopHubSheet> createState() => _WorkshopHubSheetState();
}

class _WorkshopHubSheetState extends State<WorkshopHubSheet> {
  // Tracks loading indicator state status
  bool _isLoading = false;

  void _handleJoinSequence() async {
    setState(() {
      _isLoading = true; // Displays loading spinner layout
    });

    // 🟢 Simulates joining the workshop with a clean 1-second delay
    await Future.delayed(const Duration(seconds: 1));

    // =========================================================================
    // 🧠 BACKEND INTEGRATION PLACEHOLDER HOOKS
    // =========================================================================
    // TODO: Add user to workshop using Firebase.
    // TODO: Update workshop seat count.
    // TODO: Handle workshop full state.
    // TODO: Trigger BLoC event when backend is implemented.
    // =========================================================================

    if (!mounted) return;

    // 1. Close the Workshop Hub Sheet first with native slide-down animation
    Navigator.pop(context);

    // 2. Programmatically flip the root bottom navigation layout tab bar index to 'Chat' (Index 3)
    mainLayoutKey.currentState?.switchTab(3);

    // 3. Instantly slide the new specialized conversation forum interface room overlay on top
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkshopChatScreen(workshopTitle: widget.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CLOSE BUTTON HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Workshop Details",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // CLASSMATES CONTEXT ROW
          Text(
            "YOUR CLASSMATES THIS SESSION",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE5A93C).withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMockAvatar('assets/images/character_images/reem.png'),
              const SizedBox(width: 8),
              _buildMockAvatar('assets/images/character_images/reem.png'),
              const SizedBox(width: 8),
              _buildMockAvatar('assets/images/character_images/omar.png'),
              const SizedBox(width: 12),
              Text(
                "+ Join them inside",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // VENUE INFO BLOCK
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.coffee_outlined,
                color: Color(0xFFE5A93C),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location: Draft Café (Al Rawdah Branch)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Meet at the large community table near the main counter.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // TIME & DATE COORDINATE BLOCK
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFFE5A93C),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Schedule: Saturday, 10:00 AM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "(Starts in 2 days)",
                          style: TextStyle(
                            color: const Color(
                              0xFFE5A93C,
                            ).withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // MATERIALS NOTICE BLOCK
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: Color(0xFFE5A93C),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Curriculum Materials Notice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Requirements: Please bring your laptop with the desktop Figma app installed.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // 🚀 HIGH-UTILITY INTERACTIVE Gradient [JOIN WORKSHOP GROUP] CTA BUTTON
          InkWell(
            onTap: _isLoading ? null : _handleJoinSequence,
            // Disables button clicks while loading simulation runs
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC89B3C), Color(0xFFE1B35C)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      '🚀 JOIN WORKSHOP GROUP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMockAvatar(String path) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1C1E22), width: 2),
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
    );
  }
}
