// ============================================================================
// 📄 FILE: coin_workshop_detail_sheet.dart
// PURPOSE: Bottom sheet for viewing partner workshop details and redeeming with Bedal Coins
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/coin_workshop_model.dart';
import '../../../../providers/signup_provider.dart';

class CoinWorkshopDetailSheet extends StatefulWidget {
  final CoinWorkshopModel workshop;

  const CoinWorkshopDetailSheet({super.key, required this.workshop});

  @override
  State<CoinWorkshopDetailSheet> createState() => _CoinWorkshopDetailSheetState();
}

class _CoinWorkshopDetailSheetState extends State<CoinWorkshopDetailSheet> {
  bool _isLoading = false;

  void _handleRedemption(SignupProvider signupProvider) async {
    if (signupProvider.bedalCoins < widget.workshop.coinCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade800,
          content: Text(
            '⚠️ You need ${widget.workshop.coinCost} Coins (You have ${signupProvider.bedalCoins}). Explore skills to earn more coins!',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    if (widget.workshop.isFullyBooked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This workshop is fully booked.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final success = signupProvider.redeemWorkshop(widget.workshop);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF16171A),
          content: Text(
            '🎉 Successfully redeemed "${widget.workshop.title}" for ${widget.workshop.coinCost} Bedal Coins!',
            style: const TextStyle(color: Color(0xFFC5A059), fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not redeem workshop. You may have already redeemed it or insufficient balance.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();
    final hasEnough = signupProvider.bedalCoins >= widget.workshop.coinCost;
    final isAlreadyRedeemed = signupProvider.redeemedWorkshops.any((w) => w.id == widget.workshop.id);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A059).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✨ PARTNER-SPONSORED COMPLIMENTARY SEAT',
                  style: TextStyle(
                    color: Color(0xFFC5A059),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // TITLE
          Text(
            widget.workshop.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.workshop.venueName,
            style: const TextStyle(
              color: Color(0xFFC5A059),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // USER BALANCE & COST INFO BOX
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1E22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Redemption Cost',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Text('🪙 ', style: TextStyle(fontSize: 14)),
                        Text(
                          '${widget.workshop.coinCost} Bedal Coins',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Your Balance',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${signupProvider.bedalCoins} Coins',
                      style: TextStyle(
                        color: hasEnough ? const Color(0xFFC5A059) : Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // VENUE LOCATION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFFC5A059), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.workshop.location,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Partner venue complimentary seat access.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // SCHEDULE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_today_outlined, color: Color(0xFFC5A059), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.workshop.schedule,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // DESCRIPTION
          Text(
            widget.workshop.description,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),

          // MATERIALS NOTICE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.backpack_outlined, color: Color(0xFFC5A059), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requirements & Materials', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(widget.workshop.materials, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // REDEMPTION BUTTON / STATUS
          if (isAlreadyRedeemed)
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green),
              ),
              alignment: Alignment.center,
              child: const Text(
                '✅ Already Redeemed & Booked',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            )
          else
            InkWell(
              onTap: (_isLoading || widget.workshop.isFullyBooked) ? null : () => _handleRedemption(signupProvider),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: widget.workshop.isFullyBooked
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFFC89B3C), Color(0xFFE1B35C)],
                        ),
                  color: widget.workshop.isFullyBooked ? Colors.grey.shade800 : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!widget.workshop.isFullyBooked)
                      BoxShadow(
                        color: const Color(0xFFC89B3C).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(
                        widget.workshop.isFullyBooked
                            ? 'Fully Booked'
                            : '🪙 Redeem for ${widget.workshop.coinCost} Bedal Coins',
                        style: TextStyle(
                          color: widget.workshop.isFullyBooked ? Colors.white54 : Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
