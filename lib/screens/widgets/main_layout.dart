// =========================================================================
// 🌐 FILE: main_layout.dart
// ROLE: Master Root Core Shell & Contextual Navigation Coordinator
// =========================================================================

import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';
import '../hubs/hubs_screen.dart';
import '../notifications/notification_screen.dart';

import 'bottom_nav_bar.dart';
import 'app_header.dart';

// =========================================================================
// GLOBAL MAIN LAYOUT KEY
// =========================================================================

final GlobalKey<MainLayoutState> mainLayoutKey =
GlobalKey<MainLayoutState>();

// =========================================================================
// MAIN LAYOUT
// =========================================================================

class MainLayout extends StatefulWidget {
  MainLayout({Key? key}) : super(key: mainLayoutKey);

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // =========================================================================
  // MAIN APP SCREENS
  // =========================================================================

  List<Widget> _buildScreens() {
    return [
      HomeScreen(isActive: _currentIndex == 0), // 0
      const ExploreScreen(), // 1
      const HubsScreen(), // 2

      const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Chat Screen Space',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ), // 3

      const ProfileScreen(), // 4
    ];
  }

  // =========================================================================
  // SWITCH TAB
  // =========================================================================

  void switchTab(int index) {
    if (index < 0 || index >= 5) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // =========================================================================
  // OPEN NOTIFICATIONS
  // =========================================================================

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NotificationScreen(),
      ),
    );
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final bool showHeader =
        _currentIndex == 0 ||
            _currentIndex == 1 ||
            _currentIndex == 2;

    return Scaffold(
      backgroundColor: Colors.black,

      body: Column(
        children: [

          // ================================================================
          // APP HEADER
          // ================================================================

          if (showHeader)
            AppHeader(
              currentIndex: _currentIndex,

              // ------------------------------------------------------------
              // HOME → CAMERA
              // ------------------------------------------------------------

              onOpenCamera: () {
                debugPrint(
                  'Launching in-app video recorder...',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF151515),
                    content: Text(
                      '🎥 Launching Bedal camera...',
                    ),
                  ),
                );
              },

              // ------------------------------------------------------------
              // EXPLORE
              // ------------------------------------------------------------

              onOpenExploreMenu: () {
                debugPrint(
                  'Opening Explore menu...',
                );
              },

              // ------------------------------------------------------------
              // HUBS
              // ------------------------------------------------------------

              onOpenCasualForm: () {
                debugPrint(
                  'Opening Casual Activity form...',
                );
              },

              // ------------------------------------------------------------
              // NOTIFICATIONS
              // ------------------------------------------------------------

              onOpenNotifications: _openNotifications,
            ),

          // ================================================================
          // MAIN CONTENT
          // ================================================================

          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _buildScreens(),
            ),
          ),
        ],
      ),

      // ================================================================
      // BOTTOM NAVIGATION
      // ================================================================

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          switchTab(index);
        },
      ),
    );
  }
}