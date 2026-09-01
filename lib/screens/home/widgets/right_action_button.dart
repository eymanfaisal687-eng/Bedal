// =========================================================================
// 📄 FILE: right_action_button.dart
// ROLE: Right-side interaction rail for the Bedal discovery feed
// =========================================================================
//
// BEDAL UX CONCEPT
// • Invite       → Send a skill-exchange invitation
// • Schedule     → View / discuss available exchange times
// • Favorite     → Save this person
// • Bedal Hours  → Exchange-value tag, NOT a button
//
// IMPORTANT:
// Bedal Hours represent the amount of Bedal's internal exchange currency
// the user is willing to spend/offer in a skill exchange.
//
// Example:
// "1.2 Bedal Hours" means the user is willing to exchange up to 1.2 hours.
// =========================================================================

// =========================================================================
// 📄 FILE: right_action_button.dart
// ROLE: Premium floating action rail for the Bedal discovery feed
// =========================================================================

import 'package:flutter/material.dart';

class RightActionButtons extends StatelessWidget {
  const RightActionButtons({super.key});

  // -------------------------------------------------------------------------
  // BEDAL BRAND COLORS
  // -------------------------------------------------------------------------

  static const Color premiumGold = Color(0xFFC5A059);
  static const Color goldBright = Color(0xFFE6C878);

  static const Color silverLight = Color(0xFFF1F1F3);
  static const Color silverMid = Color(0xFFC7C7CC);
  static const Color silverDark = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ================================================================
        // 1. INVITE
        // ================================================================

        _ActionButton(
          icon: Icons.handshake_rounded,
          label: 'Invite',
          type: _ActionButtonType.invite,
          onTap: () {
            _triggerActionFeedback(
              context,
              'Send a 1-on-1 skill exchange invite.',
            );
          },
        ),

        const SizedBox(height: 12),

        // ================================================================
        // 2. SCHEDULE
        // ================================================================

        _ActionButton(
          icon: Icons.event_available_rounded,
          label: 'Schedule',
          type: _ActionButtonType.schedule,
          onTap: () {
            _triggerActionFeedback(
              context,
              'Opening your skill exchange schedule.',
            );
          },
        ),

        const SizedBox(height: 17),

        // ================================================================
        // 3. BEDAL HOURS
        // ================================================================

        const _BedalHoursBadge(
          balanceValue: '1.2',
        ),

        const SizedBox(height: 15),

        // ================================================================
        // 4. REPORT
        // ================================================================

        _ReportButton(
          onTap: () {
            _triggerActionFeedback(
              context,
              'Report options opened.',
            );
          },
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // SNACKBAR
  // -------------------------------------------------------------------------

  static void _triggerActionFeedback(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 92),
          duration: const Duration(seconds: 2),
          elevation: 0,
          backgroundColor: const Color(0xFF202020),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
        ),
      );
  }
}

// ============================================================================
// ACTION BUTTON TYPES
// ============================================================================

enum _ActionButtonType {
  invite,
  schedule,
}

// ============================================================================
// PREMIUM ACTION BUTTON
// ============================================================================

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final _ActionButtonType type;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.type,
    required this.onTap,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color goldBright = Color(0xFFE6C878);

  @override
  Widget build(BuildContext context) {
    final bool isInvite = type == _ActionButtonType.invite;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isInvite
                ? const Color(0xFF171511).withValues(alpha: 0.94)
                : const Color(0xFF111111).withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(18),

            // Gold highlight for Invite,
            // elegant warm border for Schedule.
            border: Border.all(
              color: isInvite
                  ? gold.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.30),
              width: isInvite ? 1.4 : 1.0,
            ),

            boxShadow: [
              BoxShadow(
                color: isInvite
                    ? gold.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.28),
                blurRadius: isInvite ? 14 : 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ----------------------------------------------------------
              // ICON
              // ----------------------------------------------------------

              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: isInvite
                      ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      goldBright.withValues(alpha: 0.95),
                      gold.withValues(alpha: 0.72),
                    ],
                  )
                      : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.white.withValues(alpha: 0.06),
                    ],
                  ),

                  border: Border.all(
                    color: isInvite
                        ? Colors.white.withValues(alpha: 0.40)
                        : Colors.white.withValues(alpha: 0.18),
                    width: 0.8,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: isInvite
                          ? gold.withValues(alpha: 0.30)
                          : Colors.black.withValues(alpha: 0.20),
                      blurRadius: isInvite ? 9 : 5,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: isInvite
                      ? Colors.white
                      : goldBright.withValues(alpha: 0.95),
                ),
              ),

              const SizedBox(height: 6),

              // ----------------------------------------------------------
              // LABEL
              // ----------------------------------------------------------

              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isInvite
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.88),
                  fontSize: 9.5,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Plus Jakarta Sans',
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BEDAL HOURS — SILVER COIN
// ============================================================================

class _BedalHoursBadge extends StatelessWidget {
  final String balanceValue;

  const _BedalHoursBadge({
    required this.balanceValue,
  });

  static const Color silverLight = Color(0xFFF4F4F6);
  static const Color silverMid = Color(0xFFC7C7CC);
  static const Color silverDark = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.fromLTRB(
        6,
        8,
        6,
        9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: silverLight.withValues(alpha: 0.30),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==============================================================
          // SILVER COIN
          // ==============================================================

          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  silverLight,
                  silverMid,
                  silverDark,
                ],
                stops: [
                  0.0,
                  0.48,
                  1.0,
                ],
              ),

              border: Border.all(
                color: Colors.white.withValues(alpha: 0.70),
                width: 0.8,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.16),
                  blurRadius: 7,
                  offset: const Offset(-1, -1),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ],
            ),

            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.18),
                  width: 0.8,
                ),
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                size: 15,
                color: Colors.black.withValues(alpha: 0.72),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ==============================================================
          // BALANCE
          // ==============================================================

          Text(
            balanceValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),

          const SizedBox(height: 3),

          // ==============================================================
          // LABEL
          // ==============================================================

          Text(
            'Hours',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.60),
              fontSize: 8,
              height: 1,
              fontWeight: FontWeight.w600,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REPORT
// ============================================================================

class _ReportButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ReportButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            splashColor: Colors.white.withValues(alpha: 0.08),
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.42),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.flag_outlined,
                size: 16,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Report',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.58),
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }
}