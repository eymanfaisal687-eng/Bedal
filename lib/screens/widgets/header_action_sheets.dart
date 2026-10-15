// =========================================================================
// 📄 FILE: header_action_sheets.dart
// ROLE: Pop-up Sheets and Forms for Skill Reels and Café Wall Posts with 30s Camera & Exchange Flow
// =========================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:bedal/controllers/community_backend_controller.dart';
import 'package:bedal/screens/skill_video/skill_camera_screen.dart';
import 'package:bedal/providers/schedule_provider.dart';

const kPrimaryColor = Color(0xFFC5A059);
const kExploreBg = Color(0xFFF1EEE7);
const kCardBgColor = Color(0xFFFFFFFF);
const kCharcoal = Color(0xFF16171A);
const kMutedText = Color(0xFF7A7368);
const kDividerColor = Color(0xFFE3E0D6);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class HeaderActionSheets {
  // 1. Home Camera Icon: BottomSheet opening 30s Camera
  static void showHomeCameraMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kExploreBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kCharcoal.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '👑 Bedal Creator Studio',
                style: TextStyle(
                  color: kCharcoal,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: kPlusJakartaSans,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.video_call_rounded, color: kPrimaryColor, size: 28),
                title: const Text('Post 30s Skill Reel', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold)),
                subtitle: const Text('Record 30s reel, set exchange terms & select meetup cafés', style: TextStyle(color: kMutedText, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  // Open 30s Camera Screen first
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SkillCameraScreen(),
                    ),
                  ).then((recordedVideo) {
                    if (recordedVideo != null && recordedVideo is XFile && context.mounted) {
                      _showSkillReelExchangeForm(context, recordedVideo: recordedVideo);
                    }
                  });
                },
              ),
              const Divider(color: kDividerColor),
              ListTile(
                leading: const Icon(Icons.local_cafe_rounded, color: kPrimaryColor, size: 28),
                title: const Text('Post to Café Wall', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold)),
                subtitle: const Text('Share thoughts, updates, or campus questions', style: TextStyle(color: kMutedText, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _showCafeWallForm(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // Detailed Skill Reel Exchange Form with DraggableScrollableSheet ensuring caption & post button are always visible
  static void _showSkillReelExchangeForm(BuildContext context, {XFile? recordedVideo}) {
    final TextEditingController teachingController = TextEditingController();
    final TextEditingController captionController = TextEditingController();
    final TextEditingController desiredSkillController = TextEditingController();
    String exchangeChoice = 'Skill'; // 'Skill' or 'Bedal Hours'
    final List<String> availableCafes = ['Draft Café (Al Rawdah)', 'Medd Café (Al Rehab)', 'Brew92 (Al Rehab)', '1/2 M (Al Shati)'];
    final List<String> selectedCafes = ['Draft Café (Al Rawdah)'];
    final CommunityBackendController controller = CommunityBackendController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kExploreBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final scheduleProvider = context.watch<ScheduleProvider>();
                final userSlots = scheduleProvider.getSlotsForUser('current_user');

                return Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: kCharcoal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('🎬 30s Skill Reel & Exchange Terms', style: TextStyle(color: kCharcoal, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      if (recordedVideo != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: kPrimaryColor, size: 20),
                              SizedBox(width: 8),
                              Text('30s Reel Video Recorded Successfully!', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),

                      // 1. Skill Teaching
                      TextField(
                        controller: teachingController,
                        style: const TextStyle(color: kCharcoal),
                        decoration: InputDecoration(
                          labelText: 'Skill You Are Teaching (e.g. UI/UX Design)',
                          labelStyle: const TextStyle(color: kMutedText),
                          filled: true,
                          fillColor: kCardBgColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDividerColor)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Caption / Description
                      TextField(
                        controller: captionController,
                        maxLines: 2,
                        style: const TextStyle(color: kCharcoal),
                        decoration: InputDecoration(
                          labelText: 'Caption / Reel Description',
                          labelStyle: const TextStyle(color: kMutedText),
                          filled: true,
                          fillColor: kCardBgColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDividerColor)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Exchange Preference
                      const Text('What do you want in exchange?', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Learn a Skill'),
                              selected: exchangeChoice == 'Skill',
                              selectedColor: kPrimaryColor.withValues(alpha: 0.2),
                              backgroundColor: kCardBgColor,
                              labelStyle: TextStyle(
                                color: exchangeChoice == 'Skill' ? kPrimaryColor : kCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (sel) => setModalState(() => exchangeChoice = 'Skill'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Bedal Hours'),
                              selected: exchangeChoice == 'Bedal Hours',
                              selectedColor: kPrimaryColor.withValues(alpha: 0.2),
                              backgroundColor: kCardBgColor,
                              labelStyle: TextStyle(
                                color: exchangeChoice == 'Bedal Hours' ? kPrimaryColor : kCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (sel) => setModalState(() => exchangeChoice = 'Bedal Hours'),
                            ),
                          ),
                        ],
                      ),

                      // 4. If Skill, what skill do they want to learn
                      if (exchangeChoice == 'Skill') ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: desiredSkillController,
                          style: const TextStyle(color: kCharcoal),
                          decoration: InputDecoration(
                            labelText: 'What skill do you want to learn in return?',
                            labelStyle: const TextStyle(color: kMutedText),
                            filled: true,
                            fillColor: kCardBgColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDividerColor)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // 5. Select Cafés for Meetup Invites
                      const Text('Select Meetup Cafés to Receive Invites:', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableCafes.map((cafe) {
                          final isSelected = selectedCafes.contains(cafe);
                          return FilterChip(
                            label: Text(cafe),
                            selected: isSelected,
                            selectedColor: kPrimaryColor.withValues(alpha: 0.2),
                            checkmarkColor: kPrimaryColor,
                            backgroundColor: kCardBgColor,
                            labelStyle: TextStyle(color: isSelected ? kPrimaryColor : kCharcoal, fontWeight: FontWeight.w600),
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  selectedCafes.add(cafe);
                                } else {
                                  selectedCafes.remove(cafe);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // 6. Calendar Availability Slots from Profile
                      const Text('Your Profile Calendar Availability Slots:', style: TextStyle(color: kCharcoal, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      userSlots.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: kCardBgColor, borderRadius: BorderRadius.circular(12)),
                              child: const Text('No availability slots added in profile yet. Set them in My Schedule.', style: TextStyle(color: kMutedText, fontSize: 12)),
                            )
                          : Column(
                              children: userSlots.map((slot) => Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: kCardBgColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kDividerColor),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: kPrimaryColor),
                                    const SizedBox(width: 8),
                                    Text('${slot.startTime} – ${slot.endTime}', style: const TextStyle(color: kCharcoal, fontWeight: FontWeight.bold, fontSize: 12.5)),
                                    const Spacer(),
                                    const Text('Attached', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )).toList(),
                            ),
                      const SizedBox(height: 28),

                      // Publish Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () async {
                            await controller.postSkillReel(
                              caption: '${captionController.text} | Teaching: ${teachingController.text} | Exchange: $exchangeChoice${exchangeChoice == 'Skill' ? ' (${desiredSkillController.text})' : ''} | Cafés: ${selectedCafes.join(', ')}',
                              meetupTimings: 'Selected Profile Slots Attached',
                              bedalHoursRequired: exchangeChoice == 'Bedal Hours' ? 1.0 : 0.0,
                              meetupRestriction: 'Open to All',
                              videoUrl: recordedVideo?.path ?? 'assets/videos/home_sample.mp4',
                            );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🎉 30s Skill Reel published successfully!')),
                            );
                          },
                          child: const Text('Publish 30s Skill Reel', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Café Wall Form
  static void _showCafeWallForm(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final CommunityBackendController controller = CommunityBackendController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kExploreBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('☕ Post to Café Wall', style: TextStyle(color: kCharcoal, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  style: const TextStyle(color: kCharcoal),
                  decoration: InputDecoration(
                    hintText: 'Share thoughts, questions, or campus updates...',
                    hintStyle: const TextStyle(color: kMutedText),
                    filled: true,
                    fillColor: kCardBgColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kDividerColor)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await controller.postCafeWallMessage(content: contentController.text);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎉 Posted to Café Wall successfully!')),
                      );
                    },
                    child: const Text('Post to Wall', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
