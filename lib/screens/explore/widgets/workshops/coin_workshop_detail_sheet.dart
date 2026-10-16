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

  const CoinWorkshopDetailSheet({
    super.key,
    required this.workshop,
  });

  @override
  State<CoinWorkshopDetailSheet> createState() =>
      _CoinWorkshopDetailSheetState();
}

class _CoinWorkshopDetailSheetState
    extends State<CoinWorkshopDetailSheet> {
  bool _isLoading = false;

  static const Color _cream = Color(0xFFF8F5EF);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _charcoal = Color(0xFF25231F);
  static const Color _muted = Color(0xFF817B70);
  static const Color _gold = Color(0xFFC5A059);
  static const Color _border = Color(0xFFEAE3D7);
  static const Color _green = Color(0xFF347653);
  static const Color _red = Color(0xFFB64B43);

  void _showMessage(
      String message, {
        Color backgroundColor = _charcoal,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  Future<void> _handleRedemption(
      SignupProvider signupProvider,
      ) async {
    if (_isLoading) return;

    if (signupProvider.bedalCoins < widget.workshop.coinCost) {
      _showMessage(
        'You need ${widget.workshop.coinCost} Coins, '
            'but you have ${signupProvider.bedalCoins}. '
            'Explore skills to earn more!',
        backgroundColor: _red,
      );
      return;
    }

    if (widget.workshop.isFullyBooked) {
      _showMessage(
        'This workshop is fully booked.',
        backgroundColor: _red,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Preserves the existing redemption flow.
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final success =
      signupProvider.redeemWorkshop(widget.workshop);

      if (!mounted) return;

      if (success) {
        final workshopTitle = widget.workshop.title;
        final coinCost = widget.workshop.coinCost;
        final messenger = ScaffoldMessenger.of(context);

        Navigator.of(context).pop();

        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Successfully redeemed "$workshopTitle" '
                    'for $coinCost Bedal Coins!',
              ),
              backgroundColor: _charcoal,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
      } else {
        setState(() => _isLoading = false);

        _showMessage(
          'Could not redeem this workshop. '
              'You may have already redeemed it or your balance is insufficient.',
          backgroundColor: _red,
        );
      }
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      _showMessage(
        'Something went wrong. Please try again.',
        backgroundColor: _red,
      );
    }
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: _gold,
            size: 21,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: _charcoal,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard({
    required num balance,
    required num cost,
  }) {
    final hasEnough = balance >= cost;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'WORKSHOP REDEMPTION',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Icon(
                Icons.verified_outlined,
                color: _gold,
                size: 17,
              ),
              const SizedBox(width: 5),
              const Text(
                'Partner offer',
                style: TextStyle(
                  color: _gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your cost',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Text(
                          '🪙',
                          style: TextStyle(fontSize: 19),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            '$cost',
                            style: const TextStyle(
                              color: _charcoal,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Flexible(
                          child: Text(
                            'Coins',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: _border,
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your balance',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$balance Coins',
                      style: TextStyle(
                        color: hasEnough ? _green : _red,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasEnough
                          ? 'Ready to redeem'
                          : 'Not enough coins yet',
                      style: TextStyle(
                        color: hasEnough ? _green : _red,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!hasEnough) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF0ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _red,
                    size: 17,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Keep exploring skills to earn more Bedal Coins.',
                      style: TextStyle(
                        color: _red,
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();
    final workshop = widget.workshop;

    final isAlreadyRedeemed = signupProvider.redeemedWorkshops
        .any((item) => item.id == workshop.id);

    final hasEnough =
        signupProvider.bedalCoins >= workshop.coinCost;

    final isFullyBooked = workshop.isFullyBooked;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtle sheet handle.
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8D0C3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header and close button.
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E5CE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            color: _gold,
                            size: 16,
                          ),
                          SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'BEDAL PARTNER WORKSHOP',
                              style: TextStyle(
                                color: _charcoal,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: _white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: _charcoal,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 23),

              // Workshop title.
              Text(
                workshop.title,
                style: const TextStyle(
                  color: _charcoal,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    color: _gold,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      workshop.venueName,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Cost and balance.
              _buildBalanceCard(
                balance: signupProvider.bedalCoins,
                cost: workshop.coinCost,
              ),

              const SizedBox(height: 24),

              const Text(
                'WORKSHOP DETAILS',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              // Workshop information card.
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: _white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      title: 'LOCATION',
                      description: workshop.location,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        height: 1,
                        color: _border,
                      ),
                    ),
                    _buildDetailRow(
                      icon: Icons.calendar_month_outlined,
                      title: 'DATE & SCHEDULE',
                      description: workshop.schedule,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        height: 1,
                        color: _border,
                      ),
                    ),
                    _buildDetailRow(
                      icon: Icons.backpack_outlined,
                      title: 'REQUIREMENTS & MATERIALS',
                      description: workshop.materials,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description.
              const Text(
                'ABOUT THIS WORKSHOP',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                workshop.description,
                style: const TextStyle(
                  color: _charcoal,
                  fontSize: 13.5,
                  height: 1.65,
                ),
              ),

              const SizedBox(height: 24),

              // Redemption status or action.
              if (isAlreadyRedeemed)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFC7DDCA),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: _green,
                        size: 21,
                      ),
                      SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          'Already redeemed & booked',
                          style: TextStyle(
                            color: _green,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isLoading || isFullyBooked)
                        ? null
                        : () => _handleRedemption(signupProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _charcoal,
                      foregroundColor: _white,
                      disabledBackgroundColor:
                      const Color(0xFFD8D2C8),
                      disabledForegroundColor: _muted,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: _gold,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isFullyBooked
                              ? Icons.event_busy_outlined
                              : hasEnough
                              ? Icons.confirmation_number_outlined
                              : Icons.savings_outlined,
                          size: 20,
                          color: isFullyBooked
                              ? _muted
                              : _gold,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            isFullyBooked
                                ? 'Workshop fully booked'
                                : hasEnough
                                ? 'Redeem for ${workshop.coinCost} Coins'
                                : 'Earn more coins to redeem',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'A little skill. A new connection. A Bedal experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
