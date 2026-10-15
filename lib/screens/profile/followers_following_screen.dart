import 'package:flutter/material.dart';

// =========================================================================
// 📄 FILE: followers_following_screen.dart
// PURPOSE: Dedicated screen for viewing Followers and Following lists
// =========================================================================

class FollowersFollowingScreen extends StatefulWidget {
  final int initialTabIndex; // 0 for Followers, 1 for Following
  final String userName;

  const FollowersFollowingScreen({
    super.key,
    this.initialTabIndex = 0,
    required this.userName,
  });

  @override
  State<FollowersFollowingScreen> createState() => _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  final List<_UserItem> _followers = [
    _UserItem(name: 'Reem Al-Harbi', handle: '@reem_h', avatar: 'assets/images/character_images/reem.png', isFollowing: true),
    _UserItem(name: 'Omar Khan', handle: '@omar_k', avatar: 'assets/images/character_images/omar.png', isFollowing: false),
    _UserItem(name: 'Sara Ali', handle: '@sara_a', avatar: 'assets/images/character_images/sara.png', isFollowing: true),
  ];

  final List<_UserItem> _following = [
    _UserItem(name: 'Sara Ali', handle: '@sara_a', avatar: 'assets/images/character_images/sara.png', isFollowing: true),
    _UserItem(name: 'Zaid M.', handle: '@zaid_m', avatar: 'assets/images/character_images/omar.png', isFollowing: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userName,
          style: const TextStyle(
            color: charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: gold,
          unselectedLabelColor: const Color(0xFF7A7368),
          indicatorColor: gold,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans'),
          tabs: const [
            Tab(text: '3 Followers'),
            Tab(text: '2 Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(_followers),
          _buildUserList(_following),
        ],
      ),
    );
  }

  Widget _buildUserList(List<_UserItem> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E0D5)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(user.avatar),
                onBackgroundImageError: (_, __) {},
                backgroundColor: gold.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: charcoal,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.handle,
                      style: const TextStyle(
                        color: Color(0xFF7A7368),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    user.isFollowing = !user.isFollowing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: user.isFollowing ? gold.withValues(alpha: 0.15) : gold,
                  foregroundColor: user.isFollowing ? charcoal : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  user.isFollowing ? 'Following' : 'Follow',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Plus Jakarta Sans',
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

class _UserItem {
  final String name;
  final String handle;
  final String avatar;
  bool isFollowing;

  _UserItem({
    required this.name,
    required this.handle,
    required this.avatar,
    required this.isFollowing,
  });
}
