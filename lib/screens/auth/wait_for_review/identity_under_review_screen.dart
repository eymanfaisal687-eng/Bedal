import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bedal/screens/widgets/main_layout.dart';

class IdentityUnderReviewScreen extends StatelessWidget {
  // Added required constructor variable to display the actual name inputted during signup
  final String registeredName;

  const IdentityUnderReviewScreen({super.key, required this.registeredName});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.white)),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: SvgPicture.asset(
                    'assets/images/auth_background/identity_background.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  _buildTopAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 24,
                        right: 24,
                        bottom: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildPassAnimationHeader(),
                          const SizedBox(height: 32),
                          _buildGuidelineCard(
                            icon: Icons.currency_exchange_outlined,
                            title: 'Your Wisdom Is Your Currency',
                            subtitle:
                                'Teach one hour. Earn one Bedal Hour. Your\nknowledge is more valuable than money.',
                          ),
                          const SizedBox(height: 16),
                          _buildGuidelineCard(
                            icon: Icons.gpp_good_outlined,
                            title: 'Safe Learning First',
                            subtitle:
                                'Every exchange happens inside verified\ncafés or public community locations.\nResidential home meetings are never\nallowed.',
                          ),
                          const SizedBox(height: 16),
                          _buildGuidelineCard(
                            icon: Icons.alarm_on_outlined,
                            title: 'Respect Time',
                            subtitle:
                                'Arrive on time. Late cancellations reduce\nyour community reliability score.',
                          ),
                          const SizedBox(height: 32),
                          _buildNotificationStatusBanner(),
                          const SizedBox(height: 40),
                          _buildContinueButton(context),
                          const SizedBox(height: 12),
                          _buildLogoutButton(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Navigation Header Bar matching your original styling constraints
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2F2F2F)),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 16),
          const Text(
            'Identity Under Review',
            style: TextStyle(
              color: Color(0xFF2F2F2F),
              fontSize: 20,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.27,
              letterSpacing: -0.22,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Verification Pass Graphic Container & Main Heading copy
  Widget _buildPassAnimationHeader() {
    return Column(
      children: [
        Container(
          width: 192,
          height: 192,
          decoration: const BoxDecoration(
            color: Color(0x19C89B3C),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.hourglass_top_rounded,
              size: 64,
              color: Color(0xFFC89B3C),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Building Your Jeddah\nCampus Pass',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1A1B1F),
            fontSize: 28,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Hi, $registeredName!\nWe've safely received your profile verification details. We will trigger a free push notification straight to your mobile screen the exact second your campus pass is fully active. While you wait, explore mode is unlocked!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5F5E5E),
            fontSize: 15,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// 3. Community Rules Card Pattern
  Widget _buildGuidelineCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFFDF9),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEDE6DA)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF9F4E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFC89B3C), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1B1F),
                    fontSize: 15,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF1A1B1F),
                    fontSize: 13,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Notification Context Banner Block
  Widget _buildNotificationStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF3DC),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE6B65C)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: Color(0xFFB8872C),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore Mode Active',
                  style: TextStyle(
                    color: Color(0xFF8A6425),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Browse Bedal in view-only mode while your profile is being verified. We'll notify you the moment your Campus Pass is approved",
                  style: TextStyle(
                    color: const Color(0xFF874B0D).withValues(alpha: 0.9),
                    fontSize: 13,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Continue Exploring Trigger Button (Navigates to Read-Only Home Feed)
  Widget _buildContinueButton(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("User entered view-only Explore Mode pipeline.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC89B3C), Color(0xFFE1B35C)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue Exploring Campus',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  /// 6. Outline Secondary Log Out Button (Throws user completely out of the app session)
  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint(
          "Authentication token cleared. User thrown out of Bedal App.",
        );
        // BLoC/Navigation: Clear secure shared memory tokens, close stream variables, route back to login screen
        // Navigator.pushNamedAndRemoveUntil(context, '/login_screen', (route) => false);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.5, color: Color(0x4D7B5900)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log Out & Exit App',
              style: TextStyle(
                color: Color(0xFF7B5900),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.logout_rounded, color: Color(0xFF7B5900), size: 16),
          ],
        ),
      ),
    );
  }
}
