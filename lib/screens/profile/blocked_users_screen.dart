import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';

// =========================================================================
// 📄 FILE: blocked_users_screen.dart
// PURPOSE: Dedicated screen for viewing and unblocking blocked users
// =========================================================================

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();
    final blocked = signupProvider.blockedUsers;

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
          'Blocked Users',
          style: TextStyle(
            color: charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      body: blocked.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.block_rounded, size: 64, color: Color(0xFFC5A059)),
                  const SizedBox(height: 16),
                  const Text(
                    'No Blocked Users',
                    style: TextStyle(
                      color: charcoal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'You have not blocked any campus users.',
                    style: TextStyle(color: Color(0xFF7A7368), fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: blocked.length,
              itemBuilder: (context, index) {
                final userId = blocked[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E0D5)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: gold.withValues(alpha: 0.2),
                        child: const Icon(Icons.person, color: gold),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userId,
                              style: const TextStyle(
                                color: charcoal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Restricted from messaging & invites',
                              style: TextStyle(color: Color(0xFF7A7368), fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<SignupProvider>().unblockUser(userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User unblocked successfully.')),
                          );
                        },
                        child: const Text(
                          'Unblock',
                          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
