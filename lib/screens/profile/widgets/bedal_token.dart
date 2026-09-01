import 'package:flutter/material.dart';

class BedalToken extends StatelessWidget {
  const BedalToken({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  // ===============================================================
  // TEMPORARY BALANCE
  // ===============================================================
  //
  // Later this will come from the user's account/database.
  //
  static const double tokenBalance = 4.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(
        22,
        4,
        22,
        18,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: gold.withValues(alpha: 0.16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [

            // =====================================================
            // TOP ROW
            // =====================================================

            Row(
              children: [

                // Token icon

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '🪙',
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 13),

                // Title + balance

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Bedal Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: dark,
                        ),
                      ),

                      const SizedBox(height: 3),

                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: '4.5',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: gold,
                              ),
                            ),
                            TextSpan(
                              text: ' tokens available',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // History button

                GestureDetector(
                  onTap: () {
                    _showHistory(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [

                        Icon(
                          Icons.history_rounded,
                          size: 16,
                          color: dark,
                        ),

                        SizedBox(width: 5),

                        Text(
                          'History',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =====================================================
            // DIVIDER
            // =====================================================

            Container(
              height: 1,
              color: const Color(0xFFEDE9E1),
            ),

            const SizedBox(height: 14),

            // =====================================================
            // INFORMATION
            // =====================================================

            Row(
              children: [

                Expanded(
                  child: _TokenStat(
                    icon: Icons.add_circle_outline_rounded,
                    value: '+2.5',
                    label: 'Earned',
                  ),
                ),

                Container(
                  width: 1,
                  height: 35,
                  color: const Color(0xFFEDE9E1),
                ),

                Expanded(
                  child: _TokenStat(
                    icon: Icons.remove_circle_outline_rounded,
                    value: '-1.0',
                    label: 'Spent',
                  ),
                ),

                Container(
                  width: 1,
                  height: 35,
                  color: const Color(0xFFEDE9E1),
                ),

                Expanded(
                  child: _TokenStat(
                    icon: Icons.schedule_rounded,
                    value: '4.5h',
                    label: 'Available',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // TOKEN HISTORY
  // ===============================================================

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            18,
            22,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Bedal Time History',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 18),

                const _HistoryRow(
                  icon: Icons.person_add_alt_1_rounded,
                  title: 'Hosted a 1:1 Swap',
                  date: 'Today',
                  amount: '+1.0',
                  positive: true,
                ),

                const _HistoryRow(
                  icon: Icons.coffee_rounded,
                  title: 'Entered Ahmed\'s Café',
                  date: 'Yesterday',
                  amount: '-0.5',
                  positive: false,
                ),

                const _HistoryRow(
                  icon: Icons.star_rounded,
                  title: 'Completed Daily Quest',
                  date: 'Yesterday',
                  amount: '+1.5',
                  positive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===================================================================
// TOKEN STAT
// ===================================================================

class _TokenStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _TokenStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Icon(
          icon,
          size: 17,
          color: gold,
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: dark,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: muted,
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// HISTORY ROW
// ===================================================================

class _HistoryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool positive;

  const _HistoryRow({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.positive,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: gold,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: positive ? gold : muted,
            ),
          ),
        ],
      ),
    );
  }
}