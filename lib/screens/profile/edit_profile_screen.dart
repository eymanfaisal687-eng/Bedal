import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/auth/user_profile_model.dart';

// =========================================================================
// 📄 FILE: edit_profile_screen.dart
// PURPOSE: Dedicated screen for editing editable profile fields and visibility settings
// =========================================================================

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _locationController;
  late TextEditingController _occupationController;
  late TextEditingController _imageUrlController;

  bool _showAge = true;
  bool _showGender = true;
  bool _showNationality = true;
  bool _showLocation = true;
  String _gender = 'Man';
  String _nationality = 'Saudi';

  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    final profile = profileProvider.profile;

    _nameController = TextEditingController(text: profile?.fullName ?? 'Ahmed');
    _ageController = TextEditingController(text: profile?.age ?? '24');
    _locationController = TextEditingController(text: profile?.location ?? 'Al Rawdah, Jeddah');
    _occupationController = TextEditingController(text: profile?.occupation ?? 'Student');
    _imageUrlController = TextEditingController(text: profile?.profileImageUrl ?? '');

    _showAge = profile?.showAge ?? true;
    _showGender = profile?.showGender ?? true;
    _showNationality = profile?.showNationality ?? true;
    _showLocation = profile?.showLocation ?? true;
    _gender = profile?.gender ?? 'Man';
    _nationality = profile?.nationality ?? 'Saudi';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _occupationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty.')),
      );
      return;
    }

    final success = await context.read<ProfileProvider>().updateProfileDetails(
          fullName: _nameController.text.trim(),
          age: _ageController.text.trim(),
          showAge: _showAge,
          showGender: _showGender,
          showNationality: _showNationality,
          location: _locationController.text.trim(),
          showLocation: _showLocation,
          occupation: _occupationController.text.trim(),
        );

    if (!mounted) return;

    if (_imageUrlController.text.trim() != (context.read<ProfileProvider>().profile?.profileImageUrl ?? '')) {
      await context.read<ProfileProvider>().updateProfileDetails(
            fullName: _nameController.text.trim(),
            age: _ageController.text.trim(),
            showAge: _showAge,
            showGender: _showGender,
            showNationality: _showNationality,
            location: _locationController.text.trim(),
            showLocation: _showLocation,
            occupation: _occupationController.text.trim(),
          );
    }

    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ Profile updated successfully in Firebase!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final resolvedAvatar = resolveAvatarAssetOrUrl(profile?.copyWith(profileImageUrl: _imageUrlController.text.trim()));

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
          'Edit Profile',
          style: TextStyle(
            color: charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        actions: [
          TextButton(
            onPressed: profileProvider.isLoading ? null : _saveProfile,
            child: profileProvider.isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: gold))
                : const Text(
                    'Save',
                    style: TextStyle(color: gold, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image preview & picker
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundImage: resolvedAvatar.startsWith('http')
                        ? NetworkImage(resolvedAvatar) as ImageProvider
                        : AssetImage(resolvedAvatar),
                    backgroundColor: gold.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      if (_imageUrlController.text.trim().isNotEmpty) {
                        _imageUrlController.clear();
                        context.read<ProfileProvider>().removeProfilePicture();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Custom profile picture removed. Reverted to 3D character face.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter a custom image URL below to set a custom profile picture.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                    label: const Text('Remove Custom Picture', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('PROFILE DETAILS', style: TextStyle(color: Color(0xFF7A7368), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: charcoal),
              decoration: const InputDecoration(
                labelText: 'Username / Full Name',
                labelStyle: TextStyle(color: Color(0xFF7A7368)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _imageUrlController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: charcoal),
              decoration: const InputDecoration(
                labelText: 'Custom Profile Image URL (Optional)',
                labelStyle: TextStyle(color: Color(0xFF7A7368)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            const SizedBox(height: 20),

            // IMMUTABLE GENDER & VISIBILITY CONTROL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E1D6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Gender (Permanent)', style: TextStyle(color: charcoal, fontWeight: FontWeight.bold, fontSize: 13)),
                      Chip(
                        label: Text(_gender, style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
                        backgroundColor: gold.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Show Gender on public profile', style: TextStyle(color: charcoal, fontSize: 13)),
                    value: _showGender,
                    activeThumbColor: gold,
                    onChanged: (val) => setState(() => _showGender = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // IMMUTABLE NATIONALITY & VISIBILITY CONTROL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E1D6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nationality (Permanent)', style: TextStyle(color: charcoal, fontWeight: FontWeight.bold, fontSize: 13)),
                      Chip(
                        label: Text(_nationality, style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
                        backgroundColor: gold.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Show Nationality on public profile', style: TextStyle(color: charcoal, fontSize: 13)),
                    value: _showNationality,
                    activeThumbColor: gold,
                    onChanged: (val) => setState(() => _showNationality = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AGE & LOCATION EDITING + VISIBILITY
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: charcoal),
              decoration: const InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: Color(0xFF7A7368)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            SwitchListTile(
              title: const Text('Show Age on public profile', style: TextStyle(color: charcoal, fontSize: 13)),
              value: _showAge,
              activeThumbColor: gold,
              onChanged: (val) => setState(() => _showAge = val),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _locationController,
              style: const TextStyle(color: charcoal),
              decoration: const InputDecoration(
                labelText: 'Location (e.g. Al Rawdah, Jeddah)',
                labelStyle: TextStyle(color: Color(0xFF7A7368)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            SwitchListTile(
              title: const Text('Show Location on public profile', style: TextStyle(color: charcoal, fontSize: 13)),
              value: _showLocation,
              activeThumbColor: gold,
              onChanged: (val) => setState(() => _showLocation = val),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _occupationController,
              style: const TextStyle(color: charcoal),
              decoration: const InputDecoration(
                labelText: 'Occupation / Community (e.g. Student)',
                labelStyle: TextStyle(color: Color(0xFF7A7368)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: profileProvider.isLoading ? null : _saveProfile,
                child: profileProvider.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text(
                        'Save Profile Changes',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
