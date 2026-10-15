// =========================================================================
// 📄 FILE: coordination_chat_view.dart
// ROLE: Café Meeting Table Setup & Real-time Coordination Chat for Bedal Swap
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/models/swap_session_model.dart';
import 'package:bedal/screens/chat/swap/post_session_review_view.dart';
import 'package:bedal/screens/chat/swap/qr_scanner_view.dart';

const kPrimaryColor = Color(0xFFC5A15B); // Muted Bedal gold
const kSecondaryColor = Color(0xFFD4B26E);
const kWarmIvoryBg = Color(0xFFF8F5EC); // Warm ivory background
const kCardBg = Color(0xFFFFFFFF);
const kWarmCharcoal = Color(0xFF302A23); // Warm charcoal text
const kSoftStone = Color(0xFFEDE9DF);
const kMutedText = Color(0xFF7A7368);
const kDividerColor = Color(0xFFE5E0D5);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class CoordinationChatView extends StatefulWidget {
  final SwapSession session;

  const CoordinationChatView({
    super.key,
    required this.session,
  });

  @override
  State<CoordinationChatView> createState() => _CoordinationChatViewState();
}

class _CoordinationChatViewState extends State<CoordinationChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Verification & Workflow State
  bool _isCafeOrderConfirmed = false;
  bool _isCafeQrVerified = false;
  bool _isParticipantQrVerified = false;
  bool _isEscrowTransferred = false;

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: 'Salam! Ready for our skill swap session at Draft Café?',
      isMe: false,
      time: '14:20',
    ),
    const ChatMessage(
      text: 'Wa alaikum assalam! Yes, I brought my laptop. Grabbed a table by the window.',
      isMe: true,
      time: '14:21',
    ),
    const ChatMessage(
      text: 'Awesome! I am arriving in 2 minutes. Looking forward to it!',
      isMe: false,
      time: '14:22',
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          time: '14:25',
        ),
      );
      _messageController.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Workflow Action 1: Confirm Café Order
  void _confirmCafeOrder() {
    setState(() {
      _isCafeOrderConfirmed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: kWarmCharcoal,
        content: Text(
          '☕ Café order confirmed by Draft Café! Café QR scanning is now enabled.',
          style: TextStyle(color: kPrimaryColor, fontFamily: kPlusJakartaSans),
        ),
      ),
    );
  }

  // Workflow Action 2: Scan Café QR
  Future<void> _scanCafeQr() async {
    if (!_isCafeOrderConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kWarmCharcoal,
          content: Text(
            '⚠️ Café order required before scanning café QR code.',
            style: TextStyle(color: Colors.orangeAccent, fontFamily: kPlusJakartaSans),
          ),
        ),
      );
      return;
    }

    final result = await Navigator.push<QrScanTarget>(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerView(
          session: widget.session,
          scanTarget: QrScanTarget.cafe,
        ),
      ),
    );

    if (result == QrScanTarget.cafe && mounted) {
      setState(() {
        _isCafeQrVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kWarmCharcoal,
          content: Text(
            '✅ Café QR Verified! You may now verify participant QR codes.',
            style: TextStyle(color: kPrimaryColor, fontFamily: kPlusJakartaSans),
          ),
        ),
      );
    }
  }

  // Workflow Action 3: Scan Participant QR (Role-based: Mentor <-> Learner)
  Future<void> _scanParticipantQr() async {
    if (!_isCafeQrVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kWarmCharcoal,
          content: Text(
            '⚠️ Please verify the café QR code first.',
            style: TextStyle(color: Colors.orangeAccent, fontFamily: kPlusJakartaSans),
          ),
        ),
      );
      return;
    }

    final result = await Navigator.push<QrScanTarget>(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerView(
          session: widget.session,
          scanTarget: QrScanTarget.participant,
        ),
      ),
    );

    if (result == QrScanTarget.participant && mounted) {
      setState(() {
        _isParticipantQrVerified = true;
        _isEscrowTransferred = true; // Atomic backend idempotent transfer of Bedal Hours
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kWarmCharcoal,
          content: Text(
            '🎉 Participant Verified! ${widget.session.durationHours} Bedal Hour transferred from learner escrow to mentor successfully.',
            style: const TextStyle(color: kPrimaryColor, fontFamily: kPlusJakartaSans),
          ),
        ),
      );

      // Session workflow complete, transition to PostSessionReviewView
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PostSessionReviewView(session: widget.session),
          ),
        );
      });
    }
  }

  Widget _buildPeerAvatar(String avatarUrl, String name) {
    final bool isAsset = avatarUrl.startsWith('assets/');
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.35), width: 1.2),
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackAvatar(name),
              )
            : (avatarUrl.isNotEmpty && avatarUrl.startsWith('http'))
                ? Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackAvatar(name),
                  )
                : _buildFallbackAvatar(name),
      ),
    );
  }

  Widget _buildFallbackAvatar(String name) {
    return Container(
      color: kSoftStone,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'B',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: kPlusJakartaSans,
          ),
        ),
      ),
    );
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
        appBar: _buildCustomAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              _buildVenueAndEscrowStatusRow(context),
              Expanded(child: _buildChatListStream()),
              _buildVerificationProgressCard(),
              _buildBaseInputDock(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    final rawSkill = widget.session.targetSkill;
    final clean = rawSkill.replaceAll('↔', '•').replaceAll('/', '•');
    final parts = clean.split('•').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return AppBar(
      backgroundColor: kCardBg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: kWarmCharcoal, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: InkWell(
        onTap: () {
          _showPeerProfileSheet(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              _buildPeerAvatar(widget.session.peerAvatarUrl, widget.session.peerName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.session.peerName,
                            style: const TextStyle(
                              color: kWarmCharcoal,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: kPlusJakartaSans,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, color: kPrimaryColor, size: 14),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (parts.length >= 2) ...[
                          Text(
                            parts[0],
                            style: const TextStyle(
                              color: kMutedText,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: kPlusJakartaSans,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.swap_horiz_rounded,
                            color: kPrimaryColor,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            parts[1],
                            style: const TextStyle(
                              color: kMutedText,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: kPlusJakartaSans,
                            ),
                          ),
                        ] else ...[
                          const Icon(
                            Icons.swap_horiz_rounded,
                            color: kPrimaryColor,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.session.targetSkill,
                            style: const TextStyle(
                              color: kMutedText,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: kPlusJakartaSans,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: kWarmCharcoal),
          onSelected: (value) {
            if (value == 'profile') {
              _showPeerProfileSheet(context);
            } else if (value == 'report') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session reported to Bedal Support')),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('View Peer Profile'),
            ),
            const PopupMenuItem<String>(
              value: 'report',
              child: Text('Report Issue'),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: kDividerColor, height: 1),
      ),
    );
  }

  Widget _buildVenueAndEscrowStatusRow(BuildContext context) {
    return InkWell(
      onTap: () => _showMeetupDetailsSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFF3EFE6),
          border: Border(bottom: BorderSide(color: kDividerColor, width: 1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.coffee_rounded, color: kPrimaryColor, size: 16),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Draft Café · Al Rawdah',
                style: TextStyle(
                  color: kWarmCharcoal,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: kPlusJakartaSans,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F4),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC8E6D3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isEscrowTransferred ? Icons.check_circle_rounded : Icons.lock_rounded,
                    color: const Color(0xFF27AE60),
                    size: 11,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isEscrowTransferred ? 'Bedal Hour transferred' : 'Bedal Hour secured',
                    style: const TextStyle(
                      color: Color(0xFF1E8449),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMeetupDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: kWarmCharcoal.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.coffee_rounded, color: kPrimaryColor, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your meetup details',
                              style: TextStyle(
                                color: kWarmCharcoal,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                fontFamily: kPlusJakartaSans,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Draft Café (Al Rawdah Branch)',
                              style: TextStyle(
                                color: kMutedText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: kPlusJakartaSans,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: kMutedText),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7F4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFC8E6D3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF27AE60), size: 20),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking confirmed',
                              style: TextStyle(
                                color: Color(0xFF1E8449),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                fontFamily: kPlusJakartaSans,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Reserved mentor seating at partner hub',
                              style: TextStyle(
                                color: Color(0xFF27AE60),
                                fontSize: 11.5,
                                fontFamily: kPlusJakartaSans,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'MEETUP INFORMATION',
                    style: TextStyle(
                      color: kMutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: 'Draft Café, Al Rawdah Branch\nPrince Mohammed Bin Abdulaziz St, Jeddah',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Confirmed Date',
                    value: 'Today (Active Session)',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailTile(
                    icon: Icons.access_time_rounded,
                    label: 'Scheduled Time',
                    value: '2:30 PM – 3:30 PM (${widget.session.durationHours} Hour)',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailTile(
                    icon: Icons.table_bar_outlined,
                    label: 'Table Assignment',
                    value: 'Table 4 (Reserved Mentor Corner)',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailTile(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Booking Reference',
                    value: 'BDL-${widget.session.sessionId.hashCode.abs().toRadixString(16).toUpperCase()}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: kDividerColor, height: 1),
                  ),
                  const Text(
                    'BEDAL HOUR ESCROW',
                    style: TextStyle(
                      color: kMutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kWarmIvoryBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kDividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_rounded, color: kPrimaryColor, size: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isEscrowTransferred ? 'Bedal Hour transferred' : 'Bedal Hour secured',
                                style: const TextStyle(
                                  color: kWarmCharcoal,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: kPlusJakartaSans,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isEscrowTransferred
                                    ? '${widget.session.durationHours} Bedal Hour has been successfully transferred to mentor.'
                                    : '${widget.session.durationHours} Bedal Hour is securely held in peer escrow pending session confirmation via QR scan.',
                                style: const TextStyle(
                                  color: kMutedText,
                                  fontSize: 12,
                                  fontFamily: kPlusJakartaSans,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kWarmCharcoal,
                            side: const BorderSide(color: kDividerColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🗺️ Opening Draft Café location in maps...')),
                            );
                          },
                          child: const Text(
                            'Get Directions',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: kPlusJakartaSans,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showManageBookingDialog(context);
                          },
                          child: const Text(
                            'Manage Booking',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: kPlusJakartaSans,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailTile({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kPrimaryColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: kMutedText,
                  fontSize: 11.5,
                  fontFamily: kPlusJakartaSans,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: kWarmCharcoal,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: kPlusJakartaSans,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showManageBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Manage Booking', style: TextStyle(color: kWarmCharcoal, fontWeight: FontWeight.bold)),
        content: const Text(
          'Would you like to request a reschedule or cancel this meetup session?',
          style: TextStyle(color: kWarmCharcoal, fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📅 Reschedule request sent to peer.')),
              );
            },
            child: const Text('Reschedule', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('❌ Booking cancellation requested.')),
              );
            },
            child: const Text('Cancel Booking', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatListStream() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildChatBubble(msg);
      },
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: msg.isMe ? kPrimaryColor : kCardBg,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: msg.isMe ? const Radius.circular(4) : null,
            bottomLeft: !msg.isMe ? const Radius.circular(4) : null,
          ),
          border: msg.isMe ? null : Border.all(color: kDividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe ? Colors.white : kWarmCharcoal,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                fontFamily: kPlusJakartaSans,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              msg.time,
              style: TextStyle(
                color: msg.isMe
                    ? Colors.white.withValues(alpha: 0.75)
                    : kMutedText,
                fontSize: 9.5,
                fontFamily: kPlusJakartaSans,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Multi-step Café Order & QR Verification Progress Card
  Widget _buildVerificationProgressCard() {
    final bool allDone = _isCafeOrderConfirmed && _isCafeQrVerified && _isParticipantQrVerified;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: allDone ? const Color(0xFFF0F7F4) : const Color(0xFFFBF9F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allDone ? const Color(0xFFC8E6D3) : kDividerColor,
          width: 1,
        ),
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: allDone
                      ? const Color(0xFF27AE60).withValues(alpha: 0.15)
                      : kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  allDone ? Icons.check_circle_rounded : Icons.verified_user_outlined,
                  color: allDone ? const Color(0xFF27AE60) : kPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allDone ? 'Session Verified & Transferred' : 'Meetup & Order Verification',
                      style: TextStyle(
                        color: allDone ? const Color(0xFF1E8449) : kWarmCharcoal,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allDone
                          ? '${widget.session.durationHours} Bedal Hour transferred to mentor ledger.'
                          : 'Complete café order & QR scans to release escrow.',
                      style: TextStyle(
                        color: allDone ? const Color(0xFF27AE60) : kMutedText,
                        fontSize: 11.5,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: kDividerColor, height: 1),
          const SizedBox(height: 10),

          // Step 1: Café Order
          _buildStepRow(
            stepNumber: '1',
            title: 'Café Order',
            statusText: _isCafeOrderConfirmed ? 'Confirmed' : 'Order required',
            isDone: _isCafeOrderConfirmed,
            actionLabel: _isCafeOrderConfirmed ? null : 'Confirm Order',
            onAction: _isCafeOrderConfirmed ? null : _confirmCafeOrder,
          ),
          const SizedBox(height: 8),

          // Step 2: Café QR Verification
          _buildStepRow(
            stepNumber: '2',
            title: 'Café QR Verification',
            statusText: _isCafeQrVerified
                ? 'Verified'
                : (_isCafeOrderConfirmed ? 'Ready to scan' : 'Locked (Order required)'),
            isDone: _isCafeQrVerified,
            actionLabel: (_isCafeOrderConfirmed && !_isCafeQrVerified) ? 'Scan Café' : null,
            onAction: (_isCafeOrderConfirmed && !_isCafeQrVerified) ? _scanCafeQr : null,
          ),
          const SizedBox(height: 8),

          // Step 3: Participant QR Verification (Mentor / Learner)
          _buildStepRow(
            stepNumber: '3',
            title: 'Participant QR Verification',
            statusText: _isParticipantQrVerified
                ? 'Verified'
                : (_isCafeQrVerified ? 'Ready to scan' : 'Locked (Café QR pending)'),
            isDone: _isParticipantQrVerified,
            actionLabel: (_isCafeQrVerified && !_isParticipantQrVerified) ? 'Scan Peer' : null,
            onAction: (_isCafeQrVerified && !_isParticipantQrVerified) ? _scanParticipantQr : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String stepNumber,
    required String title,
    required String statusText,
    required bool isDone,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFF27AE60) : kMutedText.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : Text(
                    stepNumber,
                    style: const TextStyle(
                      color: kWarmCharcoal,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDone ? kWarmCharcoal : kWarmCharcoal.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: kPlusJakartaSans,
            ),
          ),
        ),
        Text(
          statusText,
          style: TextStyle(
            color: isDone ? const Color(0xFF1E8449) : kMutedText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: kPlusJakartaSans,
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(width: 8),
          SizedBox(
            height: 26,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: onAction,
              child: Text(
                actionLabel,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBaseInputDock() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: kCardBg,
        border: Border(top: BorderSide(color: kDividerColor, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file_rounded, color: kPrimaryColor, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📎 Attach sketch, portfolio, or code snippet')),
              );
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kSoftStone,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kDividerColor),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                  color: kWarmCharcoal,
                  fontSize: 13.5,
                  fontFamily: kPlusJakartaSans,
                ),
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: 'Message your peer...',
                  hintStyle: TextStyle(
                    color: kMutedText,
                    fontSize: 13.5,
                    fontFamily: kPlusJakartaSans,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor, kSecondaryColor],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPeerProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: kWarmCharcoal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 64,
                height: 64,
                child: ClipOval(
                  child: widget.session.peerAvatarUrl.startsWith('assets/')
                      ? Image.asset(widget.session.peerAvatarUrl, fit: BoxFit.cover)
                      : _buildFallbackAvatar(widget.session.peerName),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.session.peerName,
                    style: const TextStyle(
                      color: kWarmCharcoal,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded, color: kPrimaryColor, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.session.targetSkill,
                style: const TextStyle(
                  color: kMutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: kPlusJakartaSans,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kWarmIvoryBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kDividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      children: [
                        Text('★ 4.9', style: TextStyle(color: kWarmCharcoal, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Peer Rating', style: TextStyle(color: kMutedText, fontSize: 11)),
                      ],
                    ),
                    Container(height: 24, width: 1, color: kDividerColor),
                    const Column(
                      children: [
                        Text('14 Swaps', style: TextStyle(color: kWarmCharcoal, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Completed', style: TextStyle(color: kMutedText, fontSize: 11)),
                      ],
                    ),
                    Container(height: 24, width: 1, color: kDividerColor),
                    const Column(
                      children: [
                        Text('Jeddah Hub', style: TextStyle(color: kWarmCharcoal, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Base Location', style: TextStyle(color: kMutedText, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close Profile Details',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: kPlusJakartaSans),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
