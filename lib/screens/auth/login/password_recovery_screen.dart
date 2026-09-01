import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ==========================================
// CONSTANTS & THEME MATCHING SIGNUP & LOGIN
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
// 1. THE PASSWORD RECOVERY SCREEN MODULE
// ==========================================
class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Swapped out the old username field for your permanent email string collector
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _securityAnswerController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  String? _selectedSecurityQuestion;

  // The exact identical universal questions built into your Step 1 Signup file
  final List<String> _securityQuestions = [
    'What was the name of your first elementary school?',
    'In what city did your parents first meet?',
    'What was the name of your very first childhood pet?',
    'What was the model of your family’s very first car?',
    'What is the name of your favorite childhood teacher?',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _securityAnswerController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedSecurityQuestion == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content:
                Text('Please select your secret verification question prompt.'),
          ),
        );
        return;
      }

      // BLoC Integration Point:
      // This is where you pass your text variables to your state logic pipelines:
      // BlocProvider.of<RecoveryBloc>(context).add(SubmitPasswordResetEvent(email: ..., answer: ...));

      debugPrint(
          "Recovery validation payload clean. Executing password hash swap for user: ${_emailController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content:
              Text('Password Reset Successfully! Redirecting to login... 🎉'),
        ),
      );
      Navigator.maybePop(context);
    }
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
                  opacity: 0.6,
                  child: SvgPicture.asset(
                    'assets/images/auth_background/background.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  _buildTopAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildIntroHeaderSection(),
                            const SizedBox(height: 32),
                            _buildIdentityCheckCard(),
                            const SizedBox(height: 24),
                            _buildCredentialsCard(),
                            const SizedBox(height: 36),
                            _buildSubmitActionSection(),
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

  /// 1. Navigation Header Bar with integrated back trigger action hooks
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kSubtextColor,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Back to Login',
            style: TextStyle(
              color: kSubtextColor,
              fontSize: 14,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Profile Intro Branding Vector Image block and text summaries
  Widget _buildIntroHeaderSection() {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo/bedal_icon.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const Text(
          'Reset Your Password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kTextColor,
            fontSize: 28,
            fontFamily: kPlusJakartaSans,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter your registered email address and answer your\nsecret security question to instantly choose\na brand new password.',
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
    );
  }

  /// 3. Card Container 1: Security Identity Verification forms wrapper layout
  Widget _buildIdentityCheckCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: kBorderColor),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionTitle('SECURITY IDENTITY CHECK'),
          const SizedBox(height: 20),

          // Field Element 1: Email Input Box Setup
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Your Account Email',
              style: TextStyle(
                color: kTextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInputBoxWrapper(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontFamily: kPlusJakartaSans, fontSize: 15, color: kTextColor),
              decoration: const InputDecoration(
                hintText: 'name@example.com',
                hintStyle: TextStyle(color: kHelperTextColor),
                prefixIcon:
                    Icon(Icons.email_outlined, color: kHelperTextColor, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please type your account email';
                }
                if (!value.contains('@')) {
                  return 'Please input a valid email formatting';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          // Field Element 2: Private Security Verification Selector Dropdown Component
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Your Private Security Question',
              style: TextStyle(
                color: kTextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInputBoxWrapper(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedSecurityQuestion,
                isExpanded: true,
                hint: const Text('Select your secure prompt question',
                    style: TextStyle(color: kHelperTextColor, fontSize: 14)),
                icon: const Icon(Icons.arrow_drop_down, color: kHelperTextColor),
                style: const TextStyle(
                    fontFamily: kPlusJakartaSans,
                    color: kTextColor,
                    fontSize: 14),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.help_outline_rounded,
                      color: kHelperTextColor, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                items: _securityQuestions.map((q) {
                  return DropdownMenuItem(
                      value: q, child: Text(q, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (value) => setState(() => _selectedSecurityQuestion = value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Field Element 3: Secure Answer Entry Text field
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Your Secure Answer',
              style: TextStyle(
                color: kTextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInputBoxWrapper(
            child: TextFormField(
              controller: _securityAnswerController,
              style: const TextStyle(
                  fontFamily: kPlusJakartaSans, fontSize: 15, color: kTextColor),
              decoration: const InputDecoration(
                hintText: 'Type your secret answer here...',
                hintStyle: TextStyle(color: kHelperTextColor),
                prefixIcon: Icon(Icons.vpn_key_outlined,
                    color: kHelperTextColor, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please type your recovery password answer'
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Card Container 2: New Credential definition wrappers
  Widget _buildCredentialsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: kBorderColor),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionTitle('CREATE NEW CREDENTIALS'),
          const SizedBox(height: 20),
          // Field Element 4: Choose Password Input
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Choose New Password',
              style: TextStyle(
                color: kTextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInputBoxWrapper(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newPasswordController,
                    obscureText: _isPasswordObscured,
                    style: const TextStyle(
                        fontFamily: kPlusJakartaSans,
                        fontSize: 15,
                        color: kTextColor),
                    decoration: const InputDecoration(
                      hintText: 'Min 8 characters',
                      hintStyle: TextStyle(color: kHelperTextColor),
                      prefixIcon: Icon(Icons.lock_outline_rounded,
                          color: kHelperTextColor, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    validator: (value) => (value != null && value.length < 8)
                        ? 'Password must be minimum 8 characters'
                        : null,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kHelperTextColor,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordObscured = !_isPasswordObscured),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Field Element 5: Confirm Password Input
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Confirm New Password',
              style: TextStyle(
                color: kTextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInputBoxWrapper(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _isConfirmPasswordObscured,
                    style: const TextStyle(
                        fontFamily: kPlusJakartaSans,
                        fontSize: 15,
                        color: kTextColor),
                    decoration: const InputDecoration(
                      hintText: 'Repeat your password value',
                      hintStyle: TextStyle(color: kHelperTextColor),
                      prefixIcon: Icon(Icons.lock_outline_rounded,
                          color: kHelperTextColor, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please retype your target password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Credentials configurations do not match';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isConfirmPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kHelperTextColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() =>
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Submit Execution command button and secure metadata subtitle
  Widget _buildSubmitActionSection() {
    return Column(
      children: [
        InkWell(
          onTap: _handleUpdatePassword,
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
                  borderRadius: BorderRadius.circular(16)),
              shadows: const [
                BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -4),
                BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                    spreadRadius: -3),
              ],
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UPDATE PASSWORD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: kPlusJakartaSans,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.published_with_changes_rounded,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 16, color: kHelperTextColor),
            SizedBox(width: 8),
            Text(
              'Sovereign Saudi Node Encryption Active',
              style: TextStyle(
                color: kHelperTextColor,
                fontSize: 12,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// UTILITY WIDGET: Small card headers
  Widget _buildCardSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x4CD2C5B1), width: 1)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: kAccentColor,
          fontSize: 12,
          fontFamily: kPlusJakartaSans,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  /// UTILITY WIDGET: Consolidates input container styles across form elements
  Widget _buildInputBoxWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE8E8E8)),
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
      alignment: Alignment.center,
      child: child,
    );
  }
}
