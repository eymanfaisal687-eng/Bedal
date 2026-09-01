import 'package:flutter/material.dart';

class DailyQuests extends StatefulWidget {
  const DailyQuests({super.key});

  @override
  State<DailyQuests> createState() => _DailyQuestsState();
}

class _DailyQuestsState extends State<DailyQuests> {
  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  final List<_Quest> quests = [
    _Quest(
      title: 'Watch a Skill Reel',
      description: 'Watch one skill video from the community.',
      xp: 50,
      icon: Icons.play_circle_outline_rounded,
      type: QuestType.normal,
      completed: true,
    ),

    _Quest(
      title: 'Review a Peer',
      description: 'Review someone you recently met on Bedal.',
      xp: 100,
      icon: Icons.star_outline_rounded,
      type: QuestType.normal,
    ),

    _Quest(
      title: 'Attend Friday Prayer',
      description: 'Visit a mosque for Friday prayer and submit live proof.',
      xp: 15,
      icon: Icons.mosque_outlined,
      type: QuestType.verification,
    ),

    _Quest(
      title: 'Send an Invitation',
      description: 'Invite someone to connect with you on Bedal.',
      xp: 200,
      icon: Icons.person_add_alt_1_rounded,
      type: QuestType.normal,
    ),

    _Quest(
      title: 'Visit a Jeddah Spot',
      description: 'Visit a featured Jeddah location and check in.',
      xp: 75,
      icon: Icons.location_on_outlined,
      type: QuestType.verification,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Only 3 quests are shown on the profile.
    final visibleQuests = quests.take(3).toList();

    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(
        22,
        8,
        22,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================================================
          // TITLE
          // =========================================================

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: gold,
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "Today's Daily Quests",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================================================
          // QUEST CARDS
          // =========================================================

          ...visibleQuests.map(
                (quest) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _QuestCard(
                    quest: quest,
                    onTap: () => _handleQuestTap(quest),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // QUEST ACTION
  // ===============================================================

  void _handleQuestTap(_Quest quest) {
    if (quest.completed) {
      return;
    }

    if (quest.type == QuestType.verification) {
      _showVerificationDialog(quest);
      return;
    }

    setState(() {
      quest.completed = true;
    });

    _showXpReward(quest.xp);
  }

  // ===============================================================
  // VERIFICATION DIALOG
  // ===============================================================

  void _showVerificationDialog(_Quest quest) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
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
              children: [

                // Handle

                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: gold,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Submit Live Proof',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  quest.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Take a live photo to prove that you completed this quest. Your submission will be reviewed before your EXP is awarded.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: muted,
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);

                      // Camera integration will be added next.
                      _showPendingMessage(quest);
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Take Live Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===============================================================
  // PENDING VERIFICATION
  // ===============================================================

  void _showPendingMessage(_Quest quest) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${quest.title}: proof submitted for verification.',
        ),
        backgroundColor: dark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ===============================================================
  // XP REWARD
  // ===============================================================

  void _showXpReward(int xp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+$xp XP earned! 🎉',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: gold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ===================================================================
// QUEST CARD
// ===================================================================

class _QuestCard extends StatelessWidget {
  final _Quest quest;
  final VoidCallback onTap;

  const _QuestCard({
    required this.quest,
    required this.onTap,
  });

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);

  @override
  Widget build(BuildContext context) {
    final bool completed = quest.completed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: completed ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: completed
                ? const Color(0xFFF3F1ED)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: completed
                  ? Colors.transparent
                  : gold.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [

              // =====================================================
              // CHECK / ICON
              // =====================================================

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: completed
                      ? gold.withValues(alpha: 0.12)
                      : gold.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : quest.icon,
                  color: gold,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              // =====================================================
              // TEXT
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      quest.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: completed
                            ? muted
                            : dark,
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      quest.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // XP
              // =====================================================

              Text(
                '+${quest.xp} XP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: completed
                      ? muted
                      : gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// QUEST MODEL
// ===================================================================

enum QuestType {
  normal,
  verification,
}

class _Quest {
  final String title;
  final String description;
  final int xp;
  final IconData icon;
  final QuestType type;

  bool completed;

  _Quest({
    required this.title,
    required this.description,
    required this.xp,
    required this.icon,
    required this.type,
    this.completed = false,
  });
}