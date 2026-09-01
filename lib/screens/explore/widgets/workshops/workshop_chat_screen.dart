import 'package:flutter/material.dart';

// ========================================================================
// 📄 FILE: workshop_chat_screen.dart
// PURPOSE: Displays the workshop group chat screen.
//
// CURRENT FEATURES:
// • Shows the workshop title at the top.
// • Displays participant avatars.
// • Shows a welcome system message.
// • Displays a scrollable list of chat messages.
// • Includes a message input field and Send button (UI only).
//
// FUTURE UPDATES:
// • TODO: Connect this screen to BLoC for real-time chat updates.
// • TODO: Load chat messages from Firebase.
// • TODO: Send messages to Firebase when the Send button is tapped.
// • TODO: Load participant avatars and names from Firebase instead of using sample data.
// ========================================================================

class WorkshopChatScreen extends StatelessWidget {
  final String workshopTitle;

  const WorkshopChatScreen({super.key, required this.workshopTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111214),
      // Dark premium slate theme canvas

      // ==========================================
      // 1. APP BAR HEADER WITH PARTICIPANTS
      // ==========================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1C1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workshopTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              "Reem, Omar, Sara, You",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          // Stacked Participant Avatars in Header Right Side
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                _buildSmallHeaderAvatar(
                  'assets/images/character_images/reem.png',
                ),
                _buildSmallHeaderAvatar(
                  'assets/images/character_images/reem.png',
                ),
                _buildSmallHeaderAvatar(
                  'assets/images/character_images/omar.png',
                ),
              ],
            ),
          ),
        ],
      ),

      // ==========================================
      // 2. SCROLLABLE MESSAGE STREAM LAYOUT
      // ==========================================
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // System Welcome Notice Box Accent
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1E22),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFE5A93C),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "System Message",
                            style: TextStyle(
                              color: const Color(
                                0xFFE5A93C,
                              ).withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: "Welcome to the "),
                            TextSpan(
                              text: workshopTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(text: " Group Chat!\n\n"),
                            const TextSpan(
                              text: "Reem (Instructor)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE5A93C),
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ", Omar, and Sara are already here. Feel free to chat with your classmates, share design resources, ask questions, and coordinate before Saturday's workshop.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Placeholder for future messages
                Center(
                  child: Text(
                    "No messages yet",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.2),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 3. MESSAGE INPUT PANEL FOOTER
          // ==========================================
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            color: const Color(0xFF1A1C1F),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111214),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message group...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: const Color(0xFFE5A93C),
                  radius: 22,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {
                      // UI Mock only
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallHeaderAvatar(String path) {
    return Align(
      widthFactor: 0.6,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1A1C1F), width: 1.5),
          image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
