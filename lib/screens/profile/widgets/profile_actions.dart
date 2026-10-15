import 'package:flutter/material.dart';
import '../my_schedule_screen.dart';
import '../public_schedule_screen.dart';

class ProfileActions extends StatefulWidget {
  final bool isMyProfile;
  final String userId;
  final String userName;

  const ProfileActions({
    super.key,
    this.isMyProfile = true,
    this.userId = 'other_user',
    this.userName = 'Ahmed',
  });

  @override
  State<ProfileActions> createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color background = Color(0xFFF8F5EF);

  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(
        22,
        0,
        22,
        20,
      ),
      child: widget.isMyProfile
          ? Row(
              children: [
                // =========================================================
                // MY SCHEDULE & CALENDAR (My Profile Only)
                // =========================================================
                Expanded(
                  child: _ActionButton(
                    label: 'My Schedule',
                    icon: Icons.calendar_month_rounded,
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    isPrimary: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyScheduleScreen()),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // =========================================================
                // ENTER MY CAFÉ
                // =========================================================
                Expanded(
                  child: _ActionButton(
                    label: 'Enter My Café',
                    icon: Icons.local_cafe_rounded,
                    backgroundColor: Colors.white,
                    foregroundColor: dark,
                    isPrimary: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening your Café ☕'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Row(
              children: [
                // =========================================================
                // INVITE 1:1
                // =========================================================
                Expanded(
                  child: _ActionButton(
                    label: 'Invite 1:1',
                    icon: Icons.person_add_alt_1_rounded,
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    isPrimary: true,
                    onTap: () {
                      _showInviteSheet(context);
                    },
                  ),
                ),

                const SizedBox(width: 6),

                // =========================================================
                // SCHEDULE MEETUP (Public visitor booking)
                // =========================================================
                Expanded(
                  child: _ActionButton(
                    label: 'Schedule',
                    icon: Icons.event_available_rounded,
                    backgroundColor: Colors.white,
                    foregroundColor: dark,
                    isPrimary: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PublicScheduleScreen(
                            hostUserId: widget.userId,
                            hostUserName: widget.userName,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 6),

                // =========================================================
                // FOLLOW
                // =========================================================
                _FollowButton(
                  isFollowing: isFollowing,
                  onTap: () {
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                  },
                ),
              ],
            ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
          decoration: const BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: gold,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Invite ${widget.userName} for a 1-on-1',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Send a personal invitation to meet, chat and exchange skills.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF777269),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('1-on-1 invitation sent ✨'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Send Invitation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15),
      elevation: isPrimary ? 3 : 0,
      shadowColor: const Color(0xFFC5A059).withValues(alpha: 0.25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: isPrimary
                ? null
                : Border.all(
                    color: const Color(0xFFE5E0D8),
                    width: 1.2,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: foregroundColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
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

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;

  const _FollowButton({
    required this.isFollowing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isFollowing
          ? const Color(0xFFC5A059).withValues(alpha: 0.12)
          : Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isFollowing
                  ? const Color(0xFFC5A059).withValues(alpha: 0.35)
                  : const Color(0xFFE5E0D8),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isFollowing ? Icons.check_rounded : Icons.add_rounded,
                size: 17,
                color: const Color(0xFFC5A059),
              ),
              const SizedBox(width: 4),
              Text(
                isFollowing ? 'Following' : 'Follow',
                style: const TextStyle(
                  color: Color(0xFF25231F),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
