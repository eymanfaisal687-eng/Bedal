// =========================================================================
// 📄 FILE: security_check_screen.dart
// ROLE: Step 1 Global Onboarding Identity & Perimeter Validation Gate
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/services/auth/location_service.dart';
import 'package:bedal/controllers/auth_backend_controller.dart';
import 'package:bedal/screens/auth/step_1/signup_account_screen.dart';
import 'package:bedal/screens/widgets/main_layout.dart';

// DESIGN SYSTEM BRAND GRAPHICS METRICS
const kPrimaryColor = Color(0xFFC5A059); // Luxury brand signature gold
const kSecondaryColor = Color(0xFFE5A93C);
const kTextColor = Color(0xFF16171A); // Dark charcoal midnight layer canvas
const kSubtextColor = Color(0xFF636262);
const kBorderColor = Color(0xFFF2F2F7);
const kAccentColor = Color(0xFF7B5900);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class SecurityCheckScreen extends StatefulWidget {
  final String registeredName;
  final String? initialCity;

  const SecurityCheckScreen({
    super.key,
    this.registeredName = "",
    this.initialCity,
  });

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  final _formKey = GlobalKey<FormState>();

  // CONNECTED FACTORY INSTANCES
  final LocationService _locationService = LocationService();
  final AuthBackendController _authController = AuthBackendController();

  bool _hasConsentedToManualVerification = false;
  bool _hasAgreedToTerms = false;
  bool _isDeviceFingerprintGenerated = false;
  bool _isGeofenceCheckComplete = false;

  String _detectedCity = 'Detecting...';
  bool _isCityLaunched = true;

  @override
  void initState() {
    super.initState();
    _runAutomatedSecurityHandshake();
  }

  /// Helper to capture target city from widget parameter or environment variables
  String _getEffectiveCity(String? passedCity) {
    if (passedCity != null && passedCity.trim().isNotEmpty) {
      return passedCity.trim();
    }

    const envTestCity = String.fromEnvironment('TEST_CITY', defaultValue: '');
    if (envTestCity.trim().isNotEmpty) return envTestCity.trim();

    const envCity = String.fromEnvironment('CITY', defaultValue: '');
    if (envCity.trim().isNotEmpty) return envCity.trim();

    const envLocation = String.fromEnvironment('LOCATION', defaultValue: '');
    if (envLocation.trim().isNotEmpty) return envLocation.trim();

    const envInitialCity =
        String.fromEnvironment('INITIAL_CITY', defaultValue: '');
    if (envInitialCity.trim().isNotEmpty) return envInitialCity.trim();

    return '';
  }

  Future<void> _runAutomatedSecurityHandshake() async {
    // 1. Simulating Device ID binding configurations loop
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _isDeviceFingerprintGenerated = true;
    });

    final String configuredCity = _getEffectiveCity(widget.initialCity);

    // 2. If run configuration passed a target city (e.g. 'Islamabad'), evaluate it directly!
    if (configuredCity.isNotEmpty) {
      await _authController.evaluateAccountBoundary(
        detectedCity: configuredCity,
        onAccessGranted: () {
          setState(() {
            _detectedCity = configuredCity;
            _isCityLaunched = true;
            _isGeofenceCheckComplete = true;
          });
        },
        onCityNotLaunched: (unlaunchedCity) {
          setState(() {
            _detectedCity = unlaunchedCity;
            _isCityLaunched = false;
            _isGeofenceCheckComplete = true;
          });
        },
      );

      _showSnackBar(
        _isCityLaunched
            ? 'Network configuration matched: $_detectedCity local profile unlocked.'
            : 'Perimeter check complete: $_detectedCity is currently on Waitlist Grid.',
      );
      return;
    }

    // 3. Otherwise, perform live hardware GPS lookup with fallback
    try {
      final String city = await _locationService.getDeviceCityName();
      if (!mounted) return;

      final String finalCity = city.isNotEmpty ? city : 'Islamabad';

      await _authController.evaluateAccountBoundary(
        detectedCity: finalCity,
        onAccessGranted: () {
          setState(() {
            _detectedCity = finalCity;
            _isCityLaunched = true;
            _isGeofenceCheckComplete = true;
          });
        },
        onCityNotLaunched: (unlaunchedCity) {
          setState(() {
            _detectedCity = unlaunchedCity;
            _isCityLaunched = false;
            _isGeofenceCheckComplete = true;
          });
        },
      );

      _showSnackBar(
        _isCityLaunched
            ? 'Network configuration matched: $_detectedCity local profile unlocked.'
            : 'Perimeter check complete: $_detectedCity is currently on Waitlist Grid.',
      );
    } catch (locationError) {
      if (!mounted) return;

      const String fallbackCity = 'Islamabad';

      await _authController.evaluateAccountBoundary(
        detectedCity: fallbackCity,
        onAccessGranted: () {
          setState(() {
            _detectedCity = fallbackCity;
            _isCityLaunched = true;
            _isGeofenceCheckComplete = true;
          });
        },
        onCityNotLaunched: (unlaunchedCity) {
          setState(() {
            _detectedCity = unlaunchedCity;
            _isCityLaunched = false;
            _isGeofenceCheckComplete = true;
          });
        },
      );

      _showSnackBar(
        'Location sensor fallback: $_detectedCity local profile unlocked.',
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kTextColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: kPlusJakartaSans,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isDeviceFingerprintGenerated || !_isGeofenceCheckComplete) return;

    if (!_hasConsentedToManualVerification || !_hasAgreedToTerms) {
      _showSnackBar('Please accept both manual verification consent and Community Guidelines & Secure Access Framework to proceed.');
      return;
    }

    if (!_isCityLaunched) {
      _showComingSoonWaitlistModal();
    } else {
      // Advance to full profile configurations loop (Step 2)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupAccountScreen()),
      );
    }
  }

  // ==========================================
  // SECURE ACCESS FRAMEWORK & COMMUNITY GUIDELINES MODAL
  // ==========================================
  void _showDocumentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16171A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bedal Secure Access Framework',
                    style: TextStyle(
                      color: Color(0xFFC5A059),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '''1. Purpose

Bedal uses account, device, location, and verification information to protect the community and ensure that users access the appropriate Bedal city and community.

Our security measures are designed to:
• Prevent automated account abuse.
• Reduce duplicate or fraudulent accounts.
• Protect the Bedal community from malicious activity.
• Ensure city-specific content is shown to users in the appropriate location.
• Support manual verification during the closed beta.
• Protect cafés, workshops, mentors, and learners using Bedal.
• Maintain a safe environment for in-person interactions.

2. Account Security

Users must:
• Provide accurate information during registration.
• Maintain control of the phone number/email associated with their account.
• Not create accounts for other people without authorization.
• Not impersonate another person.
• Not sell, transfer, rent, or share their Bedal account.
• Not use automated scripts, bots, or account-generation services.
• Not attempt to bypass account restrictions or bans.
• Not attempt to manipulate Bedal's matching, reputation, leaderboard, or Bedal Hour systems.

3. Device Protection

Bedal may use security signals associated with a user's device and account to detect suspicious activity.

These measures may help identify:
• Automated account creation.
• Repeated account abuse.
• Suspicious login patterns.
• Attempts to circumvent bans.
• Coordinated fake-account activity.

These security signals should not be presented as a replacement for identity verification.

4. City Access

Bedal may use device location to determine whether a user is within a city where Bedal services are available.

For example:
> Islamabad Access Authorized
means that the system has determined that the device is currently within the permitted access area for Islamabad.

Location may be used to:
• Enable city-specific communities.
• Show local cafés.
• Show local workshops.
• Show local guilds.
• Enable local meetups.
• Prevent access from unsupported locations.

Your exact location should not be publicly displayed to other users.

5. Location Privacy

Bedal should avoid collecting more location information than necessary.

Where technically possible, use location to determine the user's city/eligibility rather than continuously storing their precise GPS coordinates.

Do not publicly show:
• Exact home address.
• Exact current location.
• Exact workplace location.
• Real-time movement history.

6. Verification Documents

During the closed beta, Bedal may request a student card or CNIC when manual verification is required.

Verification documents:
• Are used only for the stated verification purpose.
• Are not displayed publicly.
• Are not shown to other users.
• Are not used as profile pictures.
• Are not used in the public video feed.
• Are accessible only to authorized reviewers.
• Should be retained only for as long as necessary for the verification process.
• Should be deleted from active storage after verification according to Bedal's retention procedure.

Firebase Security Rules can restrict who can read/write Storage files, including restricting access to authenticated users and specific paths.

7. Manual Verification

During the closed beta, verification may be performed manually by authorized members of the Bedal team.

Verification does not guarantee that every piece of information supplied by a user is accurate.

Bedal may reject verification where:
• The document is unreadable.
• Information appears inconsistent.
• The document appears altered.
• The document does not meet the requested verification requirements.
• The submitted material cannot reasonably establish eligibility.

8. Security Abuse

Users must not attempt to:
• Hack Bedal.
• Circumvent authentication.
• Exploit Firebase security rules.
• Access another user's files.
• Access another user's private information.
• Manipulate API requests.
• Reverse-engineer security mechanisms for abuse.
• Upload malicious files.
• Use bots or scripts to manipulate the platform.
• Attempt unauthorized access to Bedal's servers or databases.''',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.6,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 32),
                  const Text(
                    'Bedal Community Guidelines',
                    style: TextStyle(
                      color: Color(0xFFC5A059),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '''1. Be Respectful
Treat other Bedal members with respect. Do not insult, harass, humiliate, threaten, bully, intimidate, repeatedly contact someone who has asked you to stop, deliberately provoke other users, or encourage others to target a particular user.

2. No Hate Speech
Bedal does not allow attacks or hateful content targeting people based on characteristics such as nationality, ethnicity, race, religion, gender, disability, age, or other protected personal characteristics. You may disagree with someone without attacking them as a person.

3. No Vulgar or Sexually Explicit Content
Bedal is not a platform for sexual or explicit content. Do not post pornography, sexually explicit images, sexual videos, explicit sexual descriptions, sexual solicitation, sexual services, sexually explicit usernames, sexual harassment, or unwanted sexual messages.

4. No Unwanted Sexual Behavior
Do not ask strangers for sexual images, send unwanted sexual messages, make repeated sexual comments toward another user, pressure someone into meeting privately or into physical contact, or continue flirting after someone clearly declines. No means no.

5. Respect Consent & People in Photos and Videos
Consent is required before photographing, recording, posting, sharing someone's private conversation, personal information, or another person's identifiable image/video.
> If another person's face is clearly visible, do not upload the image/video unless you have their permission.
Exceptions: General public-environment content where individuals are incidental and not the focus.

6. No Doxxing
Never post another person's home address, personal phone number, private email, government ID, student ID, passport, financial information, private social-media information, live location, or private messages.

7. No Impersonation
Do not pretend to be another Bedal user, a café, a workshop, a Bedal employee, a public figure, or another organization.

8. No Fake Profiles
Do not create profiles using fake identities, stolen photos, another person's name, misleading credentials, fake skills, or fake reviews.

9. No Fraud or Scams
Do not use Bedal to scam users, request money under false pretenses, sell fake services, promote fraudulent businesses, conduct financial scams, steal Bedal Hours, manipulate Bedal Hour transactions, sell fake workshop seats, or misrepresent a café or workshop.

10. No Spam
Do not send mass invitations, spam users, repeatedly advertise unrelated services, copy/paste promotional messages to many users, create multiple accounts, or flood a community with repetitive posts.

11. Skills Must Be Genuine
> Only list skills, hobbies, experience, or interests that genuinely represent you.
Don't claim to be a certified professional, expert, or representative without authorization.

12. No Dangerous Activities & Illegal Activities
Do not organize activities creating unreasonable danger. Bedal cannot be used to organize, facilitate, advertise, or exchange information for illegal activities.

13. Respect Cafés and Workshops
Follow venue rules, respect staff and customers, keep noise reasonable, do not damage property, do not occupy reserved spaces without authorization, clean up after yourself, and follow workshop safety instructions.

14. No Harassment During Meetups
Allow users to leave a meetup. Do not follow someone, pressure them to stay, demand phone/social media, threaten them for ending a meetup, or continue contacting them after they ask you to stop.

15. Public Meetup Safety
Meet in public partner cafés, workshops, and venues. Avoid sharing private residential addresses with strangers.

16. No Manipulation of Ratings & Retaliation
Do not buy/trade fake reviews, threaten users for bad ratings, create fake accounts to increase rating, or sabotage other users' reputations. Do not punish or harass someone for rejecting invitations, declining meetups, giving low ratings, reporting, blocking, or disagreeing.

17. No Exploitation of Minors
> Bedal is intended for users aged 18 and above.
Users must not attempt to circumvent the age requirement.

18. No Unrelated Content, Political or Hostile Content
> Bedal communities are intended for skills, hobbies, learning, activities, and social connection. Political campaigning, political recruitment, and hostile political arguments are not permitted.

19. No Dangerous Medical or Professional Claims
Do not falsely represent professional qualifications.

20. Respect Intellectual Property & Malicious Links/Files
Do not upload pirated courses, paid books, copyrighted videos, stolen artwork, malware, viruses, phishing links, or dangerous scripts.

21. No Circumventing Bedal Bans & Reporting
Do not create another account to evade suspension or restriction. Users can report violations. Enforcement: Warning → Content removal → Temporary restriction → Suspension → Permanent ban.

22. Emergency Situations & False Reports
Bedal is not an emergency service. In immediate danger, contact local emergency services. Do not submit false reports against another user.

23. Community First
The purpose of Bedal is to help people learn skills, share experiences, discover activities, and build meaningful local connections.''',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.6,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'I Understand & Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // PREMIUM WAITLIST & READ-ONLY ACCESS MODAL
  // ==========================================
  void _showComingSoonWaitlistModal() {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> waitlistFormKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  color: Color(0xFF16171A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Form(
                  key: waitlistFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '👑 BEDAL IS COMING SOON',
                        style: TextStyle(
                          color: Color(0xFFC5A059),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Campus grids haven\'t launched in $_detectedCity yet. Join our priority waitlist to secure your pass as soon as your city goes live.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.5,
                          fontFamily: kPlusJakartaSans,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // TRANSLUCENT EMAIL ENTRY BAR
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontFamily: kPlusJakartaSans,
                          ),
                          cursorColor: const Color(0xFFC5A059),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                              fontFamily: kPlusJakartaSans,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xFFC5A059),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // GOLD ACTION CAPSULE: WAITLIST COMMITMENT
                      InkWell(
                        onTap: isSubmitting
                            ? null
                            : () async {
                                if (!waitlistFormKey.currentState!.validate()) {
                                  return;
                                }
                                setModalState(() => isSubmitting = true);

                                // PUSH RECORD ENTRY TO LIVE FIRESTORE WAITLIST
                                await _authController.submitEmailToLaunchWaitlist(
                                  city: _detectedCity,
                                  userEmail: emailController.text,
                                );

                                if (modalContext.mounted) {
                                  Navigator.pop(modalContext);
                                }
                                _showSnackBar(
                                  '🎉 Priority Pass Secured! We will notify you when $_detectedCity launches.',
                                );
                              },
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kPrimaryColor, kSecondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SECURE MY PRIORITY PASS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: kPlusJakartaSans,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // VIRAL RETENTION HOOK: THE READ-ONLY EXPLORE MODE ACTION BUTTON LINK
                      TextButton(
                        onPressed: () {
                          Navigator.pop(modalContext); // Dismiss popup sheet
                          _showSnackBar(
                            'Entering Read-Only Explore Mode. Interactive transactions are locked.',
                          );
                          // Route directly into your main layout dashboard shell
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLayout(isReadOnly: true),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Browse Campus Registry (Read-Only Mode)',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            fontFamily: kPlusJakartaSans,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isReady =
        _isDeviceFingerprintGenerated && _isGeofenceCheckComplete;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.08,
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
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildIntroSection(),
                              const SizedBox(height: 32),
                              _buildDeviceFingerprintCard(),
                              const SizedBox(height: 24),
                              _buildGeofenceLocationCard(),
                              const SizedBox(height: 24),
                              _buildTermsCheckboxSection(),
                              const SizedBox(height: 32),
                              _buildSubmitButton(isReady),
                            ],
                          ),
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

  Widget _buildIntroSection() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: kPrimaryColor, size: 48),
          SizedBox(height: 20),
          Text(
            'Secure Access Verification',
            style: TextStyle(
              color: kTextColor,
              fontSize: 24,
              fontFamily: kPlusJakartaSans,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Bedal verifies your device and location to make sure you can access the Bedal community available in your selected city.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kSubtextColor,
              fontSize: 13,
              height: 1.5,
              fontFamily: kPlusJakartaSans,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceFingerprintCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: _isDeviceFingerprintGenerated ? kPrimaryColor : kBorderColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isDeviceFingerprintGenerated
              ? const Icon(
                  Icons.verified_user_rounded,
                  color: kPrimaryColor,
                  size: 24,
                )
              : const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: kPrimaryColor,
                  ),
                ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🛡️ Account & Device Protection',
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Bedal uses security signals associated with your device and account to help prevent automated abuse, duplicate accounts, and fraudulent activity.",
                  style: TextStyle(
                    color: kSubtextColor,
                    fontSize: 12,
                    fontFamily: kPlusJakartaSans,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceLocationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: _isGeofenceCheckComplete ? kPrimaryColor : kBorderColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isGeofenceCheckComplete
              ? Icon(
                  _isCityLaunched
                      ? Icons.location_on_rounded
                      : Icons.explore_outlined,
                  color: _isCityLaunched ? Colors.green : kPrimaryColor,
                  size: 24,
                )
              : const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: kPrimaryColor,
                  ),
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Global Perimeter Verification',
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Bedal uses your device's location, when you allow location access, to determine whether Bedal is currently available in your selected city. Your location is used for access and city-matching purposes and is not displayed publicly to other users.",
                  style: TextStyle(
                    color: kSubtextColor,
                    fontSize: 12,
                    fontFamily: kPlusJakartaSans,
                    height: 1.4,
                  ),
                ),
                if (_isGeofenceCheckComplete) ...[
                  const SizedBox(height: 12),
                  Text(
                    "Location Confirmed: $_detectedCity Access Authorized",
                    style: TextStyle(
                      color: _isCityLaunched
                          ? Colors.green.shade700
                          : kAccentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckboxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _hasConsentedToManualVerification,
              onChanged: (val) => setState(() => _hasConsentedToManualVerification = val ?? false),
              activeColor: kPrimaryColor,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'I consent to Bedal securely processing my verification document for manual profile validation during the closed beta.',
                  style: TextStyle(
                    color: kSubtextColor,
                    fontSize: 13,
                    fontFamily: kPlusJakartaSans,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _hasAgreedToTerms,
              onChanged: (val) => setState(() => _hasAgreedToTerms = val ?? false),
              activeColor: kPrimaryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InkWell(
                  onTap: _showDocumentsModal,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: kSubtextColor,
                        fontSize: 13,
                        fontFamily: kPlusJakartaSans,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Community Guidelines and Secure Access Framework',
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: '. (Tap to read full document)'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isReady) {
    return InkWell(
      onTap: isReady ? _handleContinue : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isReady
              ? const LinearGradient(colors: [kPrimaryColor, kSecondaryColor])
              : null,
          color: !isReady ? Colors.grey.shade300 : null,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          isReady
              ? 'Secure Parameters & Continue'
              : 'Analyzing Connection Security...',
          style: TextStyle(
            color: isReady ? Colors.white : Colors.grey.shade600,
            fontSize: 16,
            fontFamily: kPlusJakartaSans,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
