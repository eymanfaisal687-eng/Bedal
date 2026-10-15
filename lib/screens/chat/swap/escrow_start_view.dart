// =========================================================================
// 📄 FILE: escrow_start_view.dart
// ROLE: Gold-Gilded Initial Escrow Landing View for Bedal Skill Barters
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/models/swap_session_model.dart';
import 'package:bedal/screens/chat/swap/coordination_chat_view.dart';

const kPrimaryColor = Color(0xFFC5A059); // Luxury brand signature gold
const kSecondaryColor = Color(0xFFE5A93C);
const kCanvasColor = Color(0xFF16171A); // Dark charcoal midnight canvas
const kCardBgColor = Color(0xFF2C2C2E);
const kTextColor = Color(0xFFFFFFFF);
const kSubtextColor = Color(0xFF98989F);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class EscrowStartView extends StatelessWidget {
  final SwapSession session;

  const EscrowStartView({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kCanvasColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: kTextColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Secure Token Escrow',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: kPlusJakartaSans,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                _buildHeaderShield(),
                const SizedBox(height: 32),
                _buildTransactionSummaryCard(),
                const SizedBox(height: 24),
                _buildSecurityGuaranteeBox(),
                const Spacer(flex: 2),
                _buildActivateChatButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShield() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: kPrimaryColor, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.lock_rounded,
              color: kPrimaryColor,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '🔒 INITIALIZING SECURE TOKEN ESCROW',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontFamily: kPlusJakartaSans,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Bedal Hour is securely held in peer escrow until session completion is verified at your partner café venue.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kSubtextColor,
            fontSize: 13.5,
            height: 1.5,
            fontFamily: kPlusJakartaSans,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(session.peerAvatarUrl),
                backgroundColor: kPrimaryColor.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.peerName,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Verified Campus Mentor',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '★ 4.9',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.white12, height: 1),
          ),
          const Text(
            'TRADING SUMMARY',
            style: TextStyle(
              color: kSubtextColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontFamily: kPlusJakartaSans,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Trading: ${session.durationHours} Bedal Hour (${session.targetSkill})',
            style: const TextStyle(
              color: kTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: kPlusJakartaSans,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityGuaranteeBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: kPrimaryColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Zero-risk guarantee: Tokens are released only after scanning your mentor\'s official café venue sticker.',
              style: TextStyle(
                color: kSubtextColor,
                fontSize: 12,
                height: 1.4,
                fontFamily: kPlusJakartaSans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivateChatButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CoordinationChatView(session: session),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kSecondaryColor],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          '[ 🚀 LOCK HOUR & ACTIVATE CHAT ]',
          style: TextStyle(
            color: kTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            fontFamily: kPlusJakartaSans,
          ),
        ),
      ),
    );
  }
}
