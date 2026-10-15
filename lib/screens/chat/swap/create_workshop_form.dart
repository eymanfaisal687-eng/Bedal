// =========================================================================
// 📄 FILE: create_workshop_form.dart
// ROLE: Form Screen for Hosting a Group Workshop matching Explore screen colors
// =========================================================================

import 'package:flutter/material.dart';
import 'package:bedal/controllers/community_backend_controller.dart';

const kPrimaryColor = Color(0xFFC5A059);
const kSecondaryColor = Color(0xFFE5A93C);
const kExploreBg = Color(0xFFF1EEE7); // Explore screen background
const kCardBgColor = Color(0xFFFFFFFF);
const kCharcoal = Color(0xFF16171A);
const kMutedText = Color(0xFF7A7368);
const kDividerColor = Color(0xFFE3E0D6);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class CreateWorkshopForm extends StatefulWidget {
  const CreateWorkshopForm({super.key});

  @override
  State<CreateWorkshopForm> createState() => _CreateWorkshopFormState();
}

class _CreateWorkshopFormState extends State<CreateWorkshopForm> {
  final _formKey = GlobalKey<FormState>();
  final CommunityBackendController _controller = CommunityBackendController();

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  int _maxStudents = 5; // Capped at 5
  bool _isSubmitting = false;

  @override
  void dispose() {
    _topicController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitWorkshop() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final success = await _controller.createWorkshop(
      topic: _topicController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      venueLocation: _locationController.text.trim(),
      maxStudents: _maxStudents,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kCharcoal,
          content: Text('🎉 Group Workshop published live to Explore shelf!'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kCharcoal,
          content: Text('❌ Error publishing workshop. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kExploreBg,
      appBar: AppBar(
        backgroundColor: kCardBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kCharcoal, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Host Group Workshop',
          style: TextStyle(
            color: kCharcoal,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: kPlusJakartaSans,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: kDividerColor, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👑 WORKSHOP DETAILS',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _topicController,
                  label: 'Workshop Topic (e.g. Figma UI Masterclass)',
                  hint: 'Enter workshop title',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _dateController,
                  label: 'Date (e.g. Friday, Nov 20)',
                  hint: 'Enter date',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _timeController,
                  label: 'Time (e.g. 4:00 PM - 6:00 PM)',
                  hint: 'Enter time range',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'Café Venue Location (e.g. Draft Café)',
                  hint: 'Enter partner hub name',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Maximum Student Limit (Capped at 5)',
                  style: TextStyle(
                    color: kCharcoal,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _maxStudents.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        activeColor: kPrimaryColor,
                        inactiveColor: kDividerColor,
                        label: '$_maxStudents Students',
                        onChanged: (val) {
                          setState(() => _maxStudents = val.toInt());
                        },
                      ),
                    ),
                    Text(
                      '$_maxStudents Students',
                      style: const TextStyle(
                        color: kCharcoal,
                        fontWeight: FontWeight.bold,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitWorkshop,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'PUBLISH WORKSHOP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: kPlusJakartaSans,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kMutedText,
            fontSize: 13,
            fontFamily: kPlusJakartaSans,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: kCardBgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kDividerColor),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: kCharcoal, fontFamily: kPlusJakartaSans),
            cursorColor: kPrimaryColor,
            validator: (val) => val == null || val.trim().isEmpty ? 'Please fill in this field' : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kMutedText),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
