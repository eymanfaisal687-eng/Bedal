import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/auth/database_seed_service.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseSeedService _seedService = DatabaseSeedService();

  @override
  void initState() {
    super.initState();
    _initializeAppRunner();
  }

  /// Sets up a 3-second visual timer, attempts to seed Firestore with a safe timeout,
  /// and guarantees transition onto the Onboarding screen without hanging.
  Future<void> _initializeAppRunner() async {
    // 1. Give luxury gold branding animation 3 seconds to render on screen
    await Future.delayed(const Duration(seconds: 3));

    // 2. Attempt to seed Firestore with a strict 2-second timeout so network offline state never hangs the app
    try {
      await _seedService.seedTestProfiles().timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('Seeder timeout or offline notice (bypassed safely): $e');
    }

    // 3. Always move forward safely onto OnboardingScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            'assets/images/onboarding/splash_screen.png',
            fit: BoxFit.cover,
          ),
          // 2. Centered Logo on top
          Center(
            child: Image.asset(
              'assets/images/logo/bedal_logo2.png',
              width: 220,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
