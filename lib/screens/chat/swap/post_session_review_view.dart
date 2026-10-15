// =========================================================================
// 📄 FILE: post_session_review_view.dart
// ROLE: Post-Session Review, Rating Ledger Release & XP Reward Screen for Bedal
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/models/swap_session_model.dart';

const kPrimaryColor = Color(0xFFC5A15B); // Muted Bedal gold
const kSecondaryColor = Color(0xFFD4B26E);
const kWarmIvoryBg = Color(0xFFF8F5EC); // Warm ivory background
const kCardBg = Color(0xFFFFFFFF);
const kWarmCharcoal = Color(0xFF302A23); // Warm charcoal text
const kSoftStone = Color(0xFFEDE9DF);
const kMutedText = Color(0xFF7A7368);
const kDividerColor = Color(0xFFE5E0D5);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class PostSessionReviewView extends StatefulWidget {
  final SwapSession session;

  const PostSessionReviewView({
    super.key,
    required this.session,
  });

  @override
  State<PostSessionReviewView> createState() => _PostSessionReviewViewState();
}

class _PostSessionReviewViewState extends State<PostSessionReviewView> {
  int _rating = 4;
  final TextEditingController _reviewController = TextEditingController();
  bool _isReleasingEscrow = false;

  final List<String> _topics = [
    'Figma UI Basics',
    'Auto-Layout Components',
    'Design Systems',
    'Prototyping'
  ];
  final Set<String> _selectedTopics = {
    'Figma UI Basics',
    'Auto-Layout Components'
  };

  void _releaseEscrowAndClaimXP() async {
    setState(() => _isReleasingEscrow = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: kWarmCharcoal,
        content: Text(
          '🎉 Escrow Released! +100 XP added to your campus ledger.',
          style: TextStyle(color: kPrimaryColor, fontFamily: kPlusJakartaSans),
        ),
      ),
    );

    // Pop back to root / dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWarmIvoryBg,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kWarmIvoryBg,
        appBar: AppBar(
          backgroundColor: kCardBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: kWarmCharcoal, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Session Verification Complete',
            style: TextStyle(
              color: kWarmCharcoal,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: kPlusJakartaSans,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: kDividerColor, height: 1),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 28),
                _buildRatingCard(),
                const SizedBox(height: 24),
                _buildTopicCapsuleArray(),
                const SizedBox(height: 24),
                _buildReviewInputBox(),
                const SizedBox(height: 36),
                _buildMasterReleaseButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: kPrimaryColor, width: 2),
          ),
          child: const Center(
            child: Text(
              '👑',
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'SWAP SESSION COMPLETE',
          style: TextStyle(
            color: kWarmCharcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            fontFamily: kPlusJakartaSans,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rate your experience with ${widget.session.peerName} to finalize the transaction ledger and claim your campus XP rewards.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kMutedText,
            fontSize: 13.5,
            height: 1.5,
            fontFamily: kPlusJakartaSans,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'MENTOR RATING',
            style: TextStyle(
              color: kMutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontFamily: kPlusJakartaSans,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.star_rounded,
                    color: index < _rating ? kPrimaryColor : kDividerColor,
                    size: 36,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '$_rating.0 / 5.0 Stars',
            style: const TextStyle(
              color: kWarmCharcoal,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: kPlusJakartaSans,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCapsuleArray() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VERIFIED SKILLS COVERED',
            style: TextStyle(
              color: kMutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontFamily: kPlusJakartaSans,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics.map((topic) {
              final isSelected = _selectedTopics.contains(topic);
              return FilterChip(
                selected: isSelected,
                label: Text(
                  isSelected ? '[✓] $topic' : topic,
                  style: TextStyle(
                    color: isSelected ? Colors.white : kWarmCharcoal,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
                backgroundColor: kSoftStone,
                selectedColor: kPrimaryColor,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? kPrimaryColor : kDividerColor,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTopics.add(topic);
                    } else {
                      _selectedTopics.remove(topic);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewInputBox() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _reviewController,
        maxLines: 4,
        style: const TextStyle(
          color: kWarmCharcoal,
          fontSize: 14,
          fontFamily: kPlusJakartaSans,
        ),
        cursorColor: kPrimaryColor,
        decoration: const InputDecoration(
          hintText: 'Leave a word of local campus clout for your peer\'s profile wall...',
          hintStyle: TextStyle(
            color: kMutedText,
            fontSize: 13.5,
            fontFamily: kPlusJakartaSans,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildMasterReleaseButton() {
    return InkWell(
      onTap: _isReleasingEscrow ? null : _releaseEscrowAndClaimXP,
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
        child: _isReleasingEscrow
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                '[ 💰 RELEASE ESCROW & CLAIM +100 XP ]',
                style: TextStyle(
                  color: Colors.white,
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
