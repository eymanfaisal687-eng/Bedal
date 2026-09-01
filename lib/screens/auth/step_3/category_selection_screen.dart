import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/screens/auth/wait_for_review/identity_under_review_screen.dart';

// ==========================================
// CONSTANTS & THEME
// ==========================================
const kPrimaryColor = Color(0xFFD4AF37); // Slightly less saturated gold
const kSecondaryColor = Color(0xFFE5C158);
const kTextColor = Color(0xFF1A1B1F);
const kSubtextColor = Color(0xFF636262);
const kHelperTextColor = Color(0xFF8E8E93);
const kBorderColor = Color(0xFFF2F2F7);
const kAccentColor = Color(0xFF7B5900);
const kRecoveryBorderColor = Color(0xFFE8E1D6);
const kRecoveryTextColor = Color(0xFF4E4637);

const kPlusJakartaSans = 'Plus Jakarta Sans';

// ==========================================
// 1. THE CAMPUS CURRICULUM SELECTION SCREEN
// ==========================================
class CategorySelectionScreen extends StatefulWidget {
  final String registeredName;

  const CategorySelectionScreen({super.key, required this.registeredName});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  // Safe runtime memory tracker for multi-select chip allocations
  final Set<String> _selectedSkills = {};

  // Core Track Matrix Configurations
  final List<Map<String, dynamic>> _academicTrack = [
    {'label': 'Python & Coding', 'icon': Icons.code_rounded},
    {'label': 'Figma UI/UX', 'icon': Icons.architecture_rounded},
    {'label': 'Digital Marketing', 'icon': Icons.trending_up_rounded},
    {'label': 'Data Analysis', 'icon': Icons.analytics_outlined},
    {'label': 'Business English', 'icon': Icons.language_rounded},
    {'label': 'Calculus Review', 'icon': Icons.functions_rounded},
  ];

  final List<Map<String, dynamic>> _creativeTrack = [
    {'label': 'Acoustic Guitar', 'icon': Icons.music_note_rounded},
    {'label': 'Photography', 'icon': Icons.camera_alt_outlined},
    {'label': 'Latte Art/Barista', 'icon': Icons.coffee_rounded},
    {'label': 'Creative Pottery', 'icon': Icons.brush_outlined},
    {'label': 'Padel Tennis Tips', 'icon': Icons.sports_tennis_rounded},
    {'label': 'Japanese Language', 'icon': Icons.translate_rounded},
  ];

  void _toggleSkillSelection(String skillLabel) {
    setState(() {
      if (_selectedSkills.contains(skillLabel)) {
        _selectedSkills.remove(skillLabel);
      } else {
        _selectedSkills.add(skillLabel);
      }
    });
  }

  void _handleSaveCurriculum() {
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Please select at least one field of wisdom to build your curriculum.',
          ),
        ),
      );
      return;
    }

    // BLoC Integration Point:
    // Dispatch your active grid choices to your authentication state logic engine here:
    // BlocProvider.of<ProfileBloc>(context).add(SaveUserCurriculumEvent(tags: _selectedSkills.toList()));

    debugPrint(
      "Curriculum submission clean. Selected Category Tokens: $_selectedSkills",
    );

    // Redirect cleanly to the main workspace home view or waiting screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            IdentityUnderReviewScreen(registeredName: widget.registeredName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.white)),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/onboarding/splash_screen.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  _buildHeaderBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntroSection(),
                            const SizedBox(height: 36),
                            const AppSectionTitle(
                              title: '🧠 CAREER & ACADEMIC TRACK (The Study Hall)',
                            ),
                            const SizedBox(height: 16),
                            _buildGridTrack(_academicTrack),
                            const SizedBox(height: 40),
                            const AppSectionTitle(
                              title: '🎨 CREATIVE & LIFESTYLE TRACK (The Courtyard)',
                            ),
                            const SizedBox(height: 16),
                            _buildGridTrack(_creativeTrack),
                            const SizedBox(height: 44),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: kTextColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  'Step 3 of 3',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14,
                    fontFamily: kPlusJakartaSans,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const LinearProgressIndicator(
            value: 1.0,
            backgroundColor: kBorderColor,
            color: kPrimaryColor,
            minHeight: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPrimaryColor, kSecondaryColor],
              ),
              shape: CircleBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Set Your Curriculum',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextColor,
              fontSize: 26,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the precise fields of wisdom you want to share\nor learn within the centralized Jeddah City Campus.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kSubtextColor,
              fontSize: 14,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTrack(List<Map<String, dynamic>> trackItems) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trackItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 64, // Comfortable horizontal button height match
      ),
      itemBuilder: (context, index) {
        final item = trackItems[index];
        final String label = item['label'];
        final IconData icon = item['icon'];
        final bool isSelected = _selectedSkills.contains(label);

        return InkWell(
          onTap: () => _toggleSkillSelection(label),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: ShapeDecoration(
              color: isSelected ? const Color(0xFFFBF7EE) : const Color(0xFFFDFDFD),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: isSelected ? 2 : 1,
                  color: isSelected ? kPrimaryColor : const Color(0xFFE8E8E8),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? kAccentColor : kHelperTextColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: kPlusJakartaSans,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? kAccentColor : kTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                    size: 16,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: _handleSaveCurriculum,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPrimaryColor, kSecondaryColor],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Save My Curriculum (${_selectedSkills.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. REUSABLE COMPONENTS
// ==========================================
class AppSectionTitle extends StatelessWidget {
  final String title;

  const AppSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: kRecoveryTextColor,
              fontSize: 11,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
