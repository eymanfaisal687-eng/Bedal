import 'package:flutter/material.dart';

class SkillPreview extends StatefulWidget {
  final String videoPath;

  const SkillPreview({
    super.key,
    required this.videoPath,
  });

  @override
  State<SkillPreview> createState() => _SkillPreviewState();
}

class _SkillPreviewState extends State<SkillPreview> {
  // ================================================================
  // BEDAL COLORS
  // ================================================================

  static const Color gold = Color(0xFFC5A059);
  static const Color dark = Color(0xFF25231F);
  static const Color muted = Color(0xFF777269);
  static const Color background = Color(0xFFF8F5EF);

  // ================================================================
  // FORM VALUES
  // ================================================================

  String offeredSkill = 'Python';
  String wantedSkill = 'Figma';
  String bedalTime = '2 hours';

  String genderPreference = 'Everyone';

  String communityPreference = 'Everyone';

  final TextEditingController descriptionController =
  TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: dark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Preview Skill',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.only(
          bottom: 30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======================================================
            // VIDEO PREVIEW
            // ======================================================

            _buildVideoPreview(),

            const SizedBox(height: 22),

            // ======================================================
            // SECTION TITLE
            // ======================================================

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Tell people what you want to swap',
                style: TextStyle(
                  color: dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Choose what you can teach and what you would like to learn.',
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // SKILL I OFFER
            // ======================================================

            _buildSkillSelector(
              title: 'Skill I Offer',
              icon: Icons.auto_awesome_rounded,
              value: offeredSkill,
              onTap: () {
                _showSkillPicker(
                  title: 'Skill I Offer',
                  currentValue: offeredSkill,
                  onSelected: (value) {
                    setState(() {
                      offeredSkill = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // ======================================================
            // SKILL I WANT
            // ======================================================

            _buildSkillSelector(
              title: 'Skill I Want to Learn',
              icon: Icons.school_outlined,
              value: wantedSkill,
              onTap: () {
                _showSkillPicker(
                  title: 'Skill I Want to Learn',
                  currentValue: wantedSkill,
                  onSelected: (value) {
                    setState(() {
                      wantedSkill = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // BEDAL TIME
            // ======================================================

            _buildSectionLabel('Bedal Time'),

            const SizedBox(height: 9),

            _buildBedalTimeSelector(),

            const SizedBox(height: 24),

            // ======================================================
            // WHO CAN INVITE ME
            // ======================================================

            _buildSectionLabel('Who can send me a swap invite?'),

            const SizedBox(height: 9),

            _buildChoiceGroup(
              options: const [
                'Everyone',
                'Women',
                'Men',
              ],
              selected: genderPreference,
              onChanged: (value) {
                setState(() {
                  genderPreference = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // COMMUNITY
            // ======================================================

            _buildSectionLabel('I am open to'),

            const SizedBox(height: 9),

            _buildChoiceGroup(
              options: const [
                'Everyone',
                'Saudi',
                'Expat',
                'Foreign Student',
              ],
              selected: communityPreference,
              onChanged: (value) {
                setState(() {
                  communityPreference = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // ======================================================
            // SHORT DESCRIPTION
            // ======================================================

            _buildSectionLabel(
              'Add a little about this skill',
            ),

            const SizedBox(height: 9),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: TextField(
                controller: descriptionController,

                maxLines: 4,
                maxLength: 180,

                style: const TextStyle(
                  color: dark,
                  fontSize: 14,
                ),

                decoration: InputDecoration(
                  hintText:
                  'Example: I can teach beginner Python...',
                  hintStyle: const TextStyle(
                    color: muted,
                    fontSize: 13,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  counterStyle: const TextStyle(
                    color: muted,
                    fontSize: 10,
                  ),

                  contentPadding: const EdgeInsets.all(16),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: gold.withValues(alpha: 0.12),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: gold,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ======================================================
            // PUBLISH
            // ======================================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton.icon(
                  onPressed: _publishSkill,

                  icon: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                  ),

                  label: const Text(
                    'Publish Skill',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    elevation: 4,

                    shadowColor: gold.withValues(
                      alpha: 0.25,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // VIDEO PREVIEW
  // ================================================================

  Widget _buildVideoPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        width: double.infinity,
        height: 420,

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

            // ------------------------------------------------------
            // VIDEO PLACEHOLDER
            // ------------------------------------------------------

            Image.asset(
              'assets/images/character_images/sara.png',
              fit: BoxFit.cover,

              errorBuilder: (context,
                  error,
                  stackTrace,) {
                return const ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                );
              },
            ),

            // ------------------------------------------------------
            // PLAY
            // ------------------------------------------------------

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

            // ------------------------------------------------------
            // 15 SECOND BADGE
            // ------------------------------------------------------

            Positioned(
              top: 14,
              right: 14,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(9),
                ),

                child: const Text(
                  '15 sec',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // ------------------------------------------------------
            // RETAKE
            // ------------------------------------------------------

            Positioned(
              left: 14,
              bottom: 14,

              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 17,
                      ),

                      SizedBox(width: 5),

                      Text(
                        'Retake',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // SECTION LABEL
  // ================================================================

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Text(
        text,
        style: const TextStyle(
          color: dark,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ================================================================
  // SKILL SELECTOR
  // ================================================================

  Widget _buildSkillSelector({
    required String title,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),

            border: Border.all(
              color: gold.withValues(alpha: 0.14),
            ),
          ),

          child: Row(
            children: [

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  icon,
                  color: gold,
                  size: 20,
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
                        color: muted,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      value,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // BEDAL TIME SELECTOR
  // ================================================================

  Widget _buildBedalTimeSelector() {
    final options = [
      '30 min',
      '1 hour',
      '2 hours',
      '3 hours',
      '5 hours',
    ];

    return SizedBox(
      height: 43,

      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22),

        scrollDirection: Axis.horizontal,

        itemCount: options.length,

        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },

        itemBuilder: (context, index) {
          final option = options[index];

          final selected = option == bedalTime;

          return GestureDetector(
            onTap: () {
              setState(() {
                bedalTime = option;
              });
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: selected
                    ? gold
                    : Colors.white,

                borderRadius: BorderRadius.circular(13),

                border: Border.all(
                  color: selected
                      ? gold
                      : gold.withValues(alpha: 0.15),
                ),
              ),

              child: Text(
                option,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : dark,

                  fontSize: 12,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // CHOICE GROUP
  // ================================================================

  Widget _buildChoiceGroup({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        children: options.map((option) {
          final isSelected = option == selected;

          return GestureDetector(
            onTap: () {
              onChanged(option);
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: isSelected
                    ? gold.withValues(alpha: 0.12)
                    : Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(
                  color: isSelected
                      ? gold
                      : gold.withValues(alpha: 0.12),
                ),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  if (isSelected) ...[
                    const Icon(
                      Icons.check_rounded,
                      color: gold,
                      size: 15,
                    ),

                    const SizedBox(width: 5),
                  ],

                  Text(
                    option,
                    style: TextStyle(
                      color: isSelected
                          ? gold
                          : dark,

                      fontSize: 12,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================================================================
  // SKILL PICKER
  // ================================================================

  void _showSkillPicker({
    required String title,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    final skills = [
      'Python',
      'Figma',
      'Arabic',
      'English',
      'Photography',
      'Video Editing',
      'Graphic Design',
      'Cooking',
      'Padel',
      'Football',
      'Public Speaking',
      'Marketing',
    ];

    showModalBottomSheet(
      context: context,

      backgroundColor: background,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20,
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

                const SizedBox(height: 18),

                Text(
                  title,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 15),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,

                    itemCount: skills.length,

                    itemBuilder: (context, index) {
                      final skill = skills[index];

                      final selected =
                          skill == currentValue;

                      return ListTile(
                        onTap: () {
                          onSelected(skill);
                          Navigator.pop(context);
                        },

                        title: Text(
                          skill,
                          style: TextStyle(
                            color: selected
                                ? gold
                                : dark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        trailing: selected
                            ? const Icon(
                          Icons.check_rounded,
                          color: gold,
                        )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // PUBLISH
  // ================================================================

  void _publishSkill() {
    // ============================================================
    // TEMPORARY
    // ============================================================
    //
    // Later this will send:
    //
    // video
    // offeredSkill
    // wantedSkill
    // bedalTime
    // genderPreference
    // communityPreference
    // description
    //
    // to your backend/database.
    // ============================================================

    debugPrint('PUBLISH SKILL');
    debugPrint('Video: ${widget.videoPath}');
    debugPrint('Offer: $offeredSkill');
    debugPrint('Want: $wantedSkill');
    debugPrint('Bedal Time: $bedalTime');
    debugPrint('Gender: $genderPreference');
    debugPrint('Community: $communityPreference');
    debugPrint(
      'Description: ${descriptionController.text}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: dark,
        content: Text(
          '✨ Skill ready to publish!',
        ),
      ),
    );
  }
}