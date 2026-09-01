import 'package:flutter/material.dart';
import '../auth/step_1/signup_account_screen.dart';
import '../auth/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;

  final List<String> images = [
    "assets/images/onboarding/onboarding_pg1.png",
    "assets/images/onboarding/onboarding_pg2.png",
    "assets/images/onboarding/onboarding_pg3.png",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage == images.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupAccountScreen()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EBDD),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ============================================================
          // FULL-SCREEN ONBOARDING IMAGES
          // ============================================================
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              // Background Image
              return Image.asset(
                images[index],
                key: ValueKey(images[index]),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),

          // ============================================================
          // BOTTOM NAVIGATION
          // ============================================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: SafeArea(
              top: false,

              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),

                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ==================================================
                      // PAGE INDICATORS
                      // ==================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: List.generate(images.length, (index) {
                          final bool isActive = currentPage == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 350),

                            curve: Curves.easeOutCubic,

                            margin: const EdgeInsets.symmetric(horizontal: 4),

                            width: isActive ? 24 : 8,
                            height: 8,

                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFC9971A)
                                  : Colors.white.withValues(alpha: 0.85),

                              borderRadius: BorderRadius.circular(20),

                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFC9971A,
                                        ).withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 14),

                      // ==================================================
                      // NEXT / GET STARTED BUTTON
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.05, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },

                          child: ElevatedButton(
                            key: ValueKey(currentPage),

                            onPressed: _nextPage,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC9971A),

                              foregroundColor: Colors.white,

                              elevation: 4,

                              shadowColor: const Color(
                                0xFFC9971A,
                              ).withValues(alpha: 0.25),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),

                              padding: EdgeInsets.zero,
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text(
                                  currentPage == images.length - 1
                                      ? "Get Started"
                                      : "Next",

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                AnimatedRotation(
                                  turns: currentPage == images.length - 1
                                      ? 0.0
                                      : 0.0,

                                  duration: const Duration(milliseconds: 250),

                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ==================================================
                      // LOGIN — ONLY ON FINAL PAGE
                      // ==================================================
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),

                        child: currentPage == images.length - 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),

                                child: SizedBox(
                                  height: 30,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      const Text(
                                        "Already a member? ",
                                        style: TextStyle(
                                          color: Color(0xFF3B2A1F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: _goToLogin,

                                        child: const Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Color(0xFFC9971A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(height: 40),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
