import 'package:flutter/material.dart';

class VerificationModal extends StatelessWidget {
  const VerificationModal({super.key});

  /// Simple static helper method to trigger the popup sheet from your main button
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevents closing by accident without verification
      enableDrag: false,
      backgroundColor: const Color(0xFF16171A), // Pure dark midnight charcoal canvas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const VerificationModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Luxury branding visual header
          const Icon(
            Icons.mark_email_read_rounded,
            color: Color(0xFFC5A059), // Warm luxury gold highlight
            size: 64,
          ),
          const SizedBox(height: 24),

          // 2. Clear transactional instructional text
          const Text(
            'VERIFY YOUR CAMPUS EMAIL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}
