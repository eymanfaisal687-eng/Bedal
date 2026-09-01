import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bedal/screens/auth/step_1/signup_account_screen.dart';
import 'password_recovery_screen.dart';
import 'package:bedal/screens/widgets/main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Swapped out the old phone field controller for a secure email address controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  _buildHeaderTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildCharacterImageSection(),
                          _buildWelcomeIntro(),
                          const SizedBox(height: 32),
                          _buildFormInputs(),
                          const SizedBox(height: 32),
                          _buildOrDivider(),
                          const SizedBox(height: 32),
                          _buildCreateAccountFooter(),
                          const SizedBox(height: 48),
                          _buildCopyrightText(),
                          const SizedBox(height: 24),
                        ],
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

  /// 1. Top Navigation Bar holding the back asset button alignment
  Widget _buildHeaderTopBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2B2B2B), size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }

  /// 2. Embedded login character image located between Header and Welcome text
  Widget _buildCharacterImageSection() {
    return Container(
      width: 344,
      height: 344,
      // Adjusted layout constraint to handle text fields elegantly below it
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.50, 0.50),
          radius: 0.90,
          colors: [Color(0x26C89B4A), Color(0x00C89B4A)],
        ),
      ),
      child: Image.asset(
        'assets/images/character_images/login_screen_character.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Graceful fallback placeholder layout if your project's asset tree path changes
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://placehold.co"),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }

  /// 3. Welcome Headline Typography summary block
  Widget _buildWelcomeIntro() {
    return Column(
      children: [
        const Text(
          'Welcome Back ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontSize: 34,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.24,
            letterSpacing: -1.02,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: const Text(
            'Log in to continue your journey and\nconnect with your local community.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5F5E5E),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  /// 4. Core Form Inputs & Interactive Sign In Action Button Layout
  Widget _buildFormInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Updated Field Label matching your clean corporate alignment constraints
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Email Address',
            style: TextStyle(
              color: Color(0xFF2B2B2B),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        // Email Input Box container with premium Figma curvature parameters
        _buildTextFieldBoxWrapper(
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            // Pulls up the active '@' keyboard overlay layout for users
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'name@example.com',
              hintStyle: TextStyle(color: Color(0xFFA1A2A2)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password Field Label
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Password',
            style: TextStyle(
              color: Color(0xFF2B2B2B),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        // Security entry box input track
        _buildTextFieldBoxWrapper(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: Color(0xFFA1A2A2)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isPasswordObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFFA1A2A2),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Forgot Password Hyperlink Trigger Text alignment
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasswordRecoveryScreen(),
                ),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFFC89B3C),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Core Sign In Active Command Execution button
        InkWell(
          onTap: () {
            // BLoC Integration Point:
            // This is where you pass variables safely through your event loops later:
            // BlocProvider.of<LoginBloc>(context).add(SignInWithEmailPressed(email: _emailController.text, password: _passwordController.text));
            debugPrint(
              "Authentication process invoked for user target: ${_emailController.text}",
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLayout()),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            height: 58,
            decoration: ShapeDecoration(
              color: const Color(0xFF2F3034),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                // Balancing structural spacing offset alignment details
                const Text(
                  'SIGN IN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: 0.40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Reusable Input Box Decoration Layout component
  Widget _buildTextFieldBoxWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  /// 5. Alternative Action Segment Splitter Line
  Widget _buildOrDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE3E2E7))),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            color: const Color(0xFFEEEDF3),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE3E2E7)),
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          child: const Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF5F5E5E),
              fontSize: 11,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.27,
              letterSpacing: 0.33,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE3E2E7))),
      ],
    );
  }

  /// 6. Bottom Sign-up Redirection hyper-link context
  Widget _buildCreateAccountFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Color(0xFF5F5E5E),
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupAccountScreen(),
              ),
            );
          },
          child: const Text(
            'Create an Account',
            style: TextStyle(
              color: Color(0xFFC89B3C),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  /// 7. Legal Disclaimer Footer
  Widget _buildCopyrightText() {
    return Opacity(
      opacity: 0.40,
      child: const Text(
        '© Bedal • Skill Exchange',
        style: TextStyle(
          color: Color(0xFF5F5E5E),
          fontSize: 16,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }
}
