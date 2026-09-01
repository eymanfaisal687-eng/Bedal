import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/screens/auth/step_2/security_check_screen.dart';
import 'package:bedal/screens/auth/login/login_screen.dart';

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
// 1. THE MAIN SIGNUP SCREEN
// ==========================================
class SignupAccountScreen extends StatefulWidget {
  const SignupAccountScreen({super.key});

  @override
  State<SignupAccountScreen> createState() => _SignupAccountScreenState();
}

class _SignupAccountScreenState extends State<SignupAccountScreen> {
  // ===========================================================
  //                 FORM
  // ===========================================================
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ===========================================================
  //                  TEXT CONTROLLERS
  // ===========================================================
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _invitationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityAnswerController = TextEditingController();

  // ===========================================================
  //                     FORM STATE
  // ===========================================================
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isButtonPressed = false;

  String? _selectedAge;
  String? _selectedSecurityQuestion;
  double _passwordStrength = 0.0;

  // ===========================================================
  //                   DROPDOWN DATA
  // ===========================================================
  static const List<String> _ageOptions = ['18-24', '25-34', '35-44', '45+'];

  static const List<String> _securityQuestions = [
    'What was the name of your first\nelementary school?',
    'In what city did your parents first meet?',
    'What was the name of your very first\nchildhood pet?',
    'What was the model of your family’s\nvery first car?',
    'What is the name of your favorite\nchildhood teacher?',
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_calculatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_calculatePasswordStrength);
    _fullNameController.dispose();
    _emailController.dispose();
    _invitationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength() {
    final text = _passwordController.text;
    if (text.isEmpty) {
      setState(() => _passwordStrength = 0.0);
      return;
    }
    double strength = 0.0;
    if (text.length >= 8) strength += 0.3;
    if (text.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (text.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (text.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (text.contains(RegExp(r'[!@#$&*~]'))) strength += 0.15;
    setState(() => _passwordStrength = strength);
  }

  void _handleContinue() async {
    setState(() => _isButtonPressed = true);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _isButtonPressed = false);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    debugPrint('Form validated successfully. Navigating to Security Check.');
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurityCheckScreen(
          registeredName: _fullNameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // Dark icons for white background
        statusBarBrightness: Brightness.light, // For iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Background Image - Now contained within SafeArea so it starts below status bar
              Positioned.fill(
                child: Container(color: Colors.white),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/onboarding/splash_screen.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
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
                              _buildHeader(),
                              const SizedBox(height: 32),
                              _buildAccountInformationSection(),
                              const SizedBox(height: 40),
                              _buildRecoverySection(),
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildBottomNavigation(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo/bedal_logo2.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Text(
            'Welcome to Bedal',
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
            'Create your trusted local profile to exchange\nskills, discover hobbies, meet learners, and\nearn Bedal Hours completely free.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kSubtextColor,
              fontSize: 14,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(title: 'ACCOUNT INFORMATION'),
        const SizedBox(height: 24),
        AppTextField(
          controller: _invitationCodeController,
          hintText: 'Invitation / Access Code (Optional)',
          prefixIcon: Icons.confirmation_number_outlined,
          helperText: 'Leave blank to join the Jeddah Campus Waitlist.',
        ),
        const SizedBox(height: 22),
        AppTextField(
          controller: _fullNameController,
          hintText: 'Full Name',
          prefixIcon: Icons.person_outline,
          helperText: 'As written on your official ID passport or card',
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter your full name'
              : null,
        ),
        const SizedBox(height: 22),
        AppTextField(
          controller: _emailController,
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          helperText:
              'Used as your permanent recovery key if you lose your credentials.',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            final trimmed = value.trim();
            if (!trimmed.contains('@') || !trimmed.contains('.')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 22),
        AppDropdownField<String>(
          value: _selectedAge,
          hintText: 'Select your age range',
          prefixIcon: Icons.cake_outlined,
          prefixIconColor: kHelperTextColor,
          options: _ageOptions,
          helperText: 'Bedal campus access is strict for users aged 18+',
          itemBuilder: (age) => Text(
            age,
            style: const TextStyle(
              color: kTextColor,
              fontFamily: kPlusJakartaSans,
              fontSize: 15,
            ),
          ),
          onChanged: (value) => setState(() => _selectedAge = value),
          validator: (value) =>
              value == null ? 'Please select your age group' : null,
        ),
        const SizedBox(height: 22),
        _buildPasswordField(),
        const SizedBox(height: 22),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildRecoverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(title: 'ACCOUNT RECOVERY SETUP'),
        const SizedBox(height: 20),
        _buildSecurityQuestionDropdown(),
        const SizedBox(height: 18),
        AppTextField(
          controller: _securityAnswerController,
          hintText: 'Type your secure answer here...',
          prefixIcon: Icons.vpn_key_outlined,
          prefixIconColor: kRecoveryTextColor,
          customBorderSide: const BorderSide(
            width: 1,
            color: kRecoveryBorderColor,
          ),
          helperText:
              'This answer string is encrypted and fully case-insensitive.',
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please provide a secure private answer'
              : null,
        ),
        const SizedBox(height: 36),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: kHelperTextColor,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          helperText: 'Must be a minimum of 8 characters for account safety',
          validator: (value) => (value != null && value.length < 8)
              ? 'Password must be minimum 8 characters'
              : null,
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildPasswordStrengthMeter(),
        ],
      ],
    );
  }

  Widget _buildPasswordStrengthMeter() {
    Color meterColor = Colors.red;
    String label = 'Weak';
    if (_passwordStrength > 0.7) {
      meterColor = Colors.green;
      label = 'Strong';
    } else if (_passwordStrength > 0.4) {
      meterColor = Colors.orange;
      label = 'Medium';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: _passwordStrength,
                backgroundColor: kBorderColor,
                color: meterColor,
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: meterColor,
              fontSize: 11,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return AppTextField(
      controller: _confirmPasswordController,
      hintText: 'Confirm Password',
      prefixIcon: Icons.lock_outline,
      obscureText: !_isConfirmPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: kHelperTextColor,
          size: 20,
        ),
        onPressed: () => setState(
          () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Credentials values do not match';
        }
        return null;
      },
    );
  }

  Widget _buildSecurityQuestionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            'Select Security Question',
            style: TextStyle(
              color: kRecoveryTextColor,
              fontSize: 14,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        AppDropdownField(
          value: _selectedSecurityQuestion,
          hintText: 'Choose a recovery prompt question',
          prefixIcon: Icons.help_outline,
          prefixIconColor: kRecoveryTextColor,
          customBorderSide: const BorderSide(
            width: 1,
            color: kRecoveryBorderColor,
          ),
          options: _securityQuestions,
          isSearchable: true,
          searchDialogTitle: 'Search Security Questions',
          itemBuilder: (q) => Text(
            q,
            style: const TextStyle(
              color: kTextColor,
              fontFamily: kPlusJakartaSans,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          onChanged: (value) =>
              setState(() => _selectedSecurityQuestion = value),
          validator: (value) => value == null
              ? 'Please select a recovery security question'
              : null,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: _isButtonPressed ? 0.96 : 1.0),
      duration: const Duration(milliseconds: 100),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTap: _handleContinue,
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: kPlusJakartaSans,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have a campus pass? ',
              style: TextStyle(
                color: kSubtextColor,
                fontSize: 14,
                fontFamily: kPlusJakartaSans,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Login here',
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 14,
                  fontFamily: kPlusJakartaSans,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
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
                  'Step 1 of 3',
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
            value: 0.33,
            backgroundColor: kBorderColor,
            color: kPrimaryColor,
            minHeight: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: kBorderColor)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your information is securely protected',
            style: TextStyle(
              color: kHelperTextColor,
              fontSize: 11,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. REUSABLE INFRASTRUCTURE WIDGETS
// ==========================================
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? helperText;
  final BorderSide? customBorderSide;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.prefixIconColor = kHelperTextColor,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.helperText,
    this.customBorderSide,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: (_) => validator?.call(controller.text),
      builder: (FormFieldState<String> fieldState) {
        final hasError = fieldState.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormFieldBoxContainer(
              customBorderSide:
                  customBorderSide ??
                  (hasError
                      ? const BorderSide(color: Colors.red, width: 1.5)
                      : null),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: const TextStyle(
                  fontFamily: kPlusJakartaSans,
                  color: kTextColor,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: kHelperTextColor),
                  prefixIcon: Icon(
                    prefixIcon,
                    color: prefixIconColor,
                    size: 22,
                  ),
                  suffixIcon: suffixIcon,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: fieldState.didChange,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: hasError
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        fieldState.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (helperText != null && !hasError) ...[
              const SizedBox(height: 6),
              AppHelperText(text: helperText!),
            ],
          ],
        );
      },
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final List<T> options;
  final bool isSearchable;
  final String searchDialogTitle;
  final String? helperText;
  final BorderSide? customBorderSide;
  final Widget Function(T) itemBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.options,
    required this.itemBuilder,
    required this.onChanged,
    this.prefixIconColor = kHelperTextColor,
    this.isSearchable = false,
    this.searchDialogTitle = 'Search Options',
    this.helperText,
    this.customBorderSide,
    this.validator,
  });

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _SearchableDropdownModal<T>(
          title: searchDialogTitle,
          options: options,
          itemBuilder: itemBuilder,
          onSelected: (selected) {
            onChanged(selected);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (FormFieldState<T> fieldState) {
        if (fieldState.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fieldState.didChange(value);
          });
        }
        final hasError = fieldState.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: isSearchable ? () => _showSearchDialog(context) : null,
              borderRadius: BorderRadius.circular(16),
              child: FormFieldBoxContainer(
                customBorderSide:
                    customBorderSide ??
                    (hasError
                        ? const BorderSide(color: Colors.red, width: 1.5)
                        : null),
                child: isSearchable
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Icon(prefixIcon, color: prefixIconColor, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: value != null
                                  ? itemBuilder(value as T)
                                  : Text(
                                      hintText,
                                      style: const TextStyle(
                                        color: kHelperTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: kHelperTextColor,
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<T>(
                          initialValue: value,
                          dropdownColor: Colors.white,
                          hint: Text(
                            hintText,
                            style: const TextStyle(
                              color: kHelperTextColor,
                              fontSize: 15,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: kHelperTextColor,
                          ),
                          style: const TextStyle(
                            fontFamily: kPlusJakartaSans,
                            color: kTextColor,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              prefixIcon,
                              color: prefixIconColor,
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                          ),
                          items: options
                              .map(
                                (opt) => DropdownMenuItem<T>(
                                  value: opt,
                                  child: itemBuilder(opt),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            fieldState.didChange(val);
                            onChanged(val);
                          },
                        ),
                      ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: hasError
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        fieldState.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (helperText != null && !hasError) ...[
              const SizedBox(height: 6),
              AppHelperText(text: helperText!),
            ],
          ],
        );
      },
    );
  }
}

class _SearchableDropdownModal<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final Widget Function(T) itemBuilder;
  final ValueChanged<T> onSelected;

  const _SearchableDropdownModal({
    required this.title,
    required this.options,
    required this.itemBuilder,
    required this.onSelected,
  });

  @override
  State<_SearchableDropdownModal<T>> createState() =>
      _SearchableDropdownModalState<T>();
}

class _SearchableDropdownModalState<T>
    extends State<_SearchableDropdownModal<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchController.addListener(_filterOptions);
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options.where((option) {
          return option.toString().toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: kPlusJakartaSans,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: kBorderColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: kTextColor),
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: kHelperTextColor),
                prefixIcon: Icon(Icons.search, color: kHelperTextColor),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: _filteredOptions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No matching items found',
                        style: TextStyle(
                          color: kHelperTextColor,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final item = _filteredOptions[index];
                      return ListTile(
                        title: widget.itemBuilder(item),
                        onTap: () => widget.onSelected(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  final String title;

  const AppSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kRecoveryTextColor,
            fontSize: 12,
            fontFamily: kPlusJakartaSans,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: kBorderColor, thickness: 1)),
      ],
    );
  }
}

class FormFieldBoxContainer extends StatelessWidget {
  final Widget child;
  final BorderSide? customBorderSide;

  const FormFieldBoxContainer({
    super.key,
    required this.child,
    this.customBorderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD), // Almost-white fields
        shape: RoundedRectangleBorder(
          side:
              customBorderSide ??
              const BorderSide(width: 1, color: Color(0xFFE8E8E8)),
          // Subtle beige/gray border
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), // Very soft shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppHelperText extends StatelessWidget {
  final String text;

  const AppHelperText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: kHelperTextColor,
          fontSize: 11,
          fontFamily: kPlusJakartaSans,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
