import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';
import '../auth/step_1/signup_account_screen.dart';
import 'edit_profile_screen.dart';
import 'blocked_users_screen.dart';

// =========================================================================
// 📄 FILE: settings_screen.dart
// PURPOSE: Dedicated Settings Screen organized into clean sections (Account, Privacy, Preferences, Logout, Recovery)
// =========================================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Log Out', style: TextStyle(color: charcoal, fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to sign out of your Bedal account?', style: TextStyle(color: Color(0xFF7A7368))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A7368))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                await context.read<SignupProvider>().logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupAccountScreen()),
                  (route) => false,
                );
              },
              child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // ACCOUNT SECTION
          // =====================================================
          const Text('ACCOUNT', style: TextStyle(color: Color(0xFF7A7368), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E0D5)),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update username, gender, age, and location',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                  },
                ),
                const Divider(height: 1, indent: 56, color: Color(0xFFF2EFE9)),
                _SettingsTile(
                  icon: Icons.block_rounded,
                  title: 'Blocked Users',
                  subtitle: '${signupProvider.blockedUsers.length} users blocked',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BlockedUsersScreen()));
                  },
                ),
                const Divider(height: 1, indent: 56, color: Color(0xFFF2EFE9)),
                _SettingsTile(
                  icon: Icons.vpn_key_outlined,
                  title: 'Account Recovery',
                  subtitle: 'Security questions & passphrase backup',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account recovery passphrase is secure.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // =====================================================
          // PRIVACY SECTION
          // =====================================================
          const Text('PRIVACY CONTROLS', style: TextStyle(color: Color(0xFF7A7368), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E0D5)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show my age', style: TextStyle(color: charcoal, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: const Text('Display your age on your public profile', style: TextStyle(color: Color(0xFF7A7368), fontSize: 12)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.cake_rounded, color: gold, size: 20),
                  ),
                  value: signupProvider.showAge,
                  activeThumbColor: gold,
                  onChanged: (val) => signupProvider.toggleShowAge(val),
                ),
                const Divider(height: 1, indent: 56, color: Color(0xFFF2EFE9)),
                SwitchListTile(
                  title: const Text('Show my location', style: TextStyle(color: charcoal, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: const Text('Display your campus location publicly', style: TextStyle(color: Color(0xFF7A7368), fontSize: 12)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.location_on_rounded, color: gold, size: 20),
                  ),
                  value: signupProvider.showLocation,
                  activeThumbColor: gold,
                  onChanged: (val) => signupProvider.toggleShowLocation(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // =====================================================
          // PREFERENCES SECTION
          // =====================================================
          const Text('PREFERENCES', style: TextStyle(color: Color(0xFF7A7368), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E0D5)),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Push alerts & meetup requests',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, color: Color(0xFFF2EFE9)),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language / اللغة',
                  subtitle: 'English / العربية',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // =====================================================
          // LOG OUT BUTTON
          // =====================================================
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.red.shade200),
                ),
              ),
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Log Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans')),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFC5A059).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFC5A059), size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Color(0xFF16171A), fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF7A7368), fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9B968D)),
    );
  }
}
