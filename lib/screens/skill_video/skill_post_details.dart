import 'package:flutter/material.dart';

class SkillPostDetails extends StatelessWidget {
  final String videoAsset;

  const SkillPostDetails({
    super.key,
    required this.videoAsset,
  });

  // ================================================================
  // BEDAL COLORS
  // ================================================================

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ============================================================
      // TOP APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark,
            size: 21,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Skill Details',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: dark,
            ),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======================================================
            // VIDEO
            // ======================================================

            _buildVideo(),

            const SizedBox(height: 20),

            // ======================================================
            // CREATOR
            // ======================================================

            _buildCreatorSection(),

            const SizedBox(height: 22),

            // ======================================================
            // SKILL INFORMATION
            // ======================================================

            _buildSkillSection(),

            const SizedBox(height: 18),

            // ======================================================
            // SWAP PREFERENCES
            // ======================================================

            _buildSwapPreferences(),

            const SizedBox(height: 22),

            // ======================================================
            // JEDDAH / COMMUNITY
            // ======================================================

            _buildCommunitySection(),

            const SizedBox(height: 26),

            // ======================================================
            // ACTION BUTTONS
            // ======================================================

            _buildActions(context),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // VIDEO
  // ================================================================

  Widget _buildVideo() {
    return Container(
      width: double.infinity,
      height: 430,

      margin: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Stack(
        fit: StackFit.expand,
        children: [

          // --------------------------------------------------------
          // TEMP VIDEO PLACEHOLDER
          // --------------------------------------------------------

          Image.asset(
            'assets/images/character_images/sara.png',
            fit: BoxFit.cover,

            errorBuilder: (context,
                error,
                stackTrace,) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              );
            },
          ),

          // --------------------------------------------------------
          // PLAY BUTTON
          // --------------------------------------------------------

          Center(
            child: Container(
              width: 62,
              height: 62,

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),

          // --------------------------------------------------------
          // VIDEO LENGTH
          // --------------------------------------------------------

          Positioned(
            right: 12,
            bottom: 12,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),

              child: const Text(
                '0:15',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CREATOR
  // ================================================================

  Widget _buildCreatorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Row(
        children: [

          // --------------------------------------------------------
          // AVATAR
          // --------------------------------------------------------

          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: gold.withValues(alpha: 0.45),
                width: 2,
              ),
            ),

            child: ClipOval(
              child: Image.asset(
                'assets/images/character_images/sara.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 13),

          // --------------------------------------------------------
          // NAME
          // --------------------------------------------------------

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Text(
                      'Sara',
                      style: TextStyle(
                        color: dark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(width: 6),

                    Icon(
                      Icons.verified_rounded,
                      color: gold,
                      size: 17,
                    ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  'Student • Jeddah',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------------
          // FOLLOW
          // --------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 9,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: gold.withValues(alpha: 0.25),
              ),
            ),

            child: const Text(
              'Follow',
              style: TextStyle(
                color: dark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SKILL SECTION
  // ================================================================

  Widget _buildSkillSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            'Skill Swap',
            style: TextStyle(
              color: dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _SkillCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'I Offer',
                  value: 'Python',
                  highlighted: true,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _SkillCard(
                  icon: Icons.school_outlined,
                  title: 'I Want',
                  value: 'Figma',
                  highlighted: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SWAP PREFERENCES
  // ================================================================

  Widget _buildSwapPreferences() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: gold.withValues(alpha: 0.14),
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Swap Preferences',
              style: TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 15),

            _PreferenceRow(
              icon: Icons.access_time_rounded,
              title: 'Bedal Time',
              value: '2 hours',
            ),

            const SizedBox(height: 12),

            _PreferenceRow(
              icon: Icons.people_outline_rounded,
              title: 'Open To',
              value: 'Men & Women',
            ),

            const SizedBox(height: 12),

            _PreferenceRow(
              icon: Icons.public_rounded,
              title: 'Community',
              value: 'Saudi • Expat • Student',
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // COMMUNITY
  // ================================================================

  Widget _buildCommunitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFFEDE7DC),
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [

            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.location_on_outlined,
                color: gold,
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Jeddah',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Al Rawdah • Corniche community',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // ACTIONS
  // ================================================================

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Column(
        children: [

          // --------------------------------------------------------
          // INVITE
          // --------------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 54,

            child: ElevatedButton.icon(
              onPressed: () {
                _showInviteConfirmation(context);
              },

              icon: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
              ),

              label: const Text(
                'Invite for 1-on-1 Swap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                elevation: 4,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 11),

          // --------------------------------------------------------
          // SECONDARY ACTION
          // --------------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 50,

            child: OutlinedButton.icon(
              onPressed: () {},

              icon: const Icon(
                Icons.person_add_alt_1_rounded,
                color: dark,
              ),

              label: const Text(
                'View Profile',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: gold.withValues(alpha: 0.25),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // INVITE CONFIRMATION
  // ================================================================

  void _showInviteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            20,
            22,
            30,
          ),

          decoration: const BoxDecoration(
            color: background,

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.swap_horiz_rounded,
                color: gold,
                size: 34,
              ),

              const SizedBox(height: 10),

              const Text(
                'Send Swap Invite?',
                style: TextStyle(
                  color: dark,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'You are inviting Sara to a 1-on-1 skill swap.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    'Send Invite',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
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

  // ================================================================
  // MORE OPTIONS
  // ================================================================

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,

      backgroundColor: background,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              ListTile(
                leading: const Icon(
                  Icons.share_outlined,
                  color: dark,
                ),

                title: const Text(
                  'Share Skill',
                  style: TextStyle(
                    color: dark,
                  ),
                ),

                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.flag_outlined,
                  color: dark,
                ),

                title: const Text(
                  'Report',
                  style: TextStyle(
                    color: dark,
                  ),
                ),

                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}


// ===================================================================
// SKILL CARD
// ===================================================================

class _SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool highlighted;

  const _SkillCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0xFFC5A059).withValues(alpha: 0.10)
            : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFC5A059)
              .withValues(alpha: highlighted ? 0.30 : 0.14),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: const Color(0xFFC5A059),
            size: 22,
          ),

          const SizedBox(height: 9),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF777269),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF25231F),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}


// ===================================================================
// PREFERENCE ROW
// ===================================================================

class _PreferenceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            color: const Color(0xFFC5A059).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            size: 17,
            color: const Color(0xFFC5A059),
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF777269),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Color(0xFF25231F),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}