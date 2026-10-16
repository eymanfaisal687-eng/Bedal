import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bedal/providers/profile_provider.dart';
import '../followers_following_screen.dart';

class ProfileInfo extends StatelessWidget {
  final String userName;

  const ProfileInfo({super.key, this.userName = 'Ahmed'});

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    final showAge = profile?.showAge ?? true;
    final showLocation = profile?.showLocation ?? true;
    final age = profile?.age ?? '24';
    final location = profile?.location ?? 'Al Rawdah, Jeddah';
    final occupation = profile?.occupation ?? 'Student';

    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(
        22,
        0,
        22,
        18,
      ),
      child: Column(
        children: [
          // 1. Core Info (Age, Area, Community - respecting privacy toggles)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: gold.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                if (showAge) ...[
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_month_outlined,
                      value: age,
                      label: 'Years Old',
                    ),
                  ),
                  const _Divider(),
                ],
                if (showLocation) ...[
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.location_on_outlined,
                      value: location,
                      label: 'Location',
                    ),
                  ),
                  const _Divider(),
                ],
                Expanded(
                  child: _InfoItem(
                    icon: Icons.school_outlined,
                    value: occupation,
                    label: 'Occupation',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Followers & Following Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FollowersFollowingScreen(
                          initialTabIndex: 0,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E0D5)),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_rounded, color: gold, size: 16),
                        SizedBox(width: 6),
                        Text(
                          '3 Followers',
                          style: TextStyle(
                            color: dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FollowersFollowingScreen(
                          initialTabIndex: 1,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E0D5)),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_rounded, color: gold, size: 16),
                        SizedBox(width: 6),
                        Text(
                          '2 Following',
                          style: TextStyle(
                            color: dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFC5A059).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFC5A059),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF25231F),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF777269),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFC5A059).withValues(alpha: 0.18),
    );
  }
}
