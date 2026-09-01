import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bedal/services/auth/security_service.dart';
import 'package:bedal/screens/auth/step_3/category_selection_screen.dart';

// ==========================================
// CONSTANTS & THEME
// ==========================================
const kPrimaryColor = Color(0xFFD4AF37);
const kSecondaryColor = Color(0xFFE5C158);
const kTextColor = Color(0xFF1A1B1F);
const kSubtextColor = Color(0xFF636262);
const kHelperTextColor = Color(0xFF8E8E93);
const kBorderColor = Color(0xFFF2F2F7);
const kAccentColor = Color(0xFF7B5900);
const kPlusJakartaSans = 'Plus Jakarta Sans';

class SecurityCheckScreen extends StatefulWidget {
  final String registeredName;

  const SecurityCheckScreen({super.key, required this.registeredName});

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final SecurityService _securityService = SecurityService(); // Instantiate your service logic

  bool _hasAgreedToTerms = false;
  bool _isDeviceFingerprintGenerated = false;
  bool _isGeofenceCheckComplete = false;
  bool _isUserInJeddah = false;

  @override
  void initState() {
    super.initState();
    _runAutomatedSecurityHandshake();
  }

  Future<void> _runAutomatedSecurityHandshake() async {
// 1. Trigger automated Device ID configuration lookup
    final String deviceId = await _securityService.fetchSecureDeviceId();
    if (!mounted) return;
    setState(() {
      _isDeviceFingerprintGenerated = true;
    });

// 2. Trigger automated Regional Geofencing lookup
    final bool isLocal = await _securityService.verifyJeddahGeofence(deviceId);
    if (!mounted) return;
    setState(() {
      _isUserInJeddah = isLocal;
      _isGeofenceCheckComplete = true;
    });

    _showSnackBar(_isUserInJeddah
        ? 'Network configuration matched: Jeddah local profile unlocked.'
        : 'Location mismatch. Switched to Read-Only Explore Mode.');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kTextColor,
        content: Text(message, style: const TextStyle(
            color: Colors.white, fontFamily: kPlusJakartaSans)),
      ),
    );
  }

  void _handleSubmitForReview() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isDeviceFingerprintGenerated || !_isGeofenceCheckComplete) return;

    if (!_hasAgreedToTerms) {
      _showSnackBar(
          'Please accept the community guidelines and security frameworks to proceed.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategorySelectionScreen(registeredName: widget.registeredName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isReady = _isDeviceFingerprintGenerated &&
        _isGeofenceCheckComplete;

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
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24,
                              vertical: 24),
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
                        Icons.arrow_back_ios_new, color: kTextColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  'Step 2 of 3',
                  style: TextStyle(color: kPrimaryColor,
                      fontSize: 14,
                      fontFamily: kPlusJakartaSans,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const LinearProgressIndicator(value: 0.66,
              backgroundColor: kBorderColor,
              color: kPrimaryColor,
              minHeight: 2),
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
            'Secure Account Boundary',
            style: TextStyle(color: kTextColor,
                fontSize: 24,
                fontFamily: kPlusJakartaSans,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Text(
            'To keep Bedal secure for everyone in Jeddah, our firewall establishes localized network parameters before joining.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kSubtextColor,
                fontSize: 13,
                height: 1.5,
                fontFamily: kPlusJakartaSans),
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
        border: Border.all(color: _isDeviceFingerprintGenerated
            ? kPrimaryColor
            : kBorderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isDeviceFingerprintGenerated
              ? const Icon(
              Icons.check_circle_rounded, color: Colors.green, size: 24)
              : const SizedBox(width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: kPrimaryColor)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anti-Bot Device Binding', style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans)),
                SizedBox(height: 4),
                Text(
                    "Bedal binds safely with an anonymous system signature token to block multi-account script networks.",
                    style: TextStyle(color: kSubtextColor,
                        fontSize: 12,
                        fontFamily: kPlusJakartaSans,
                        height: 1.4)),
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
            color: _isGeofenceCheckComplete ? kPrimaryColor : kBorderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isGeofenceCheckComplete
              ? Icon(_isUserInJeddah ? Icons.location_on_rounded : Icons
              .explore_outlined,
              color: _isUserInJeddah ? Colors.green : kPrimaryColor, size: 24)
              : const SizedBox(width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: kPrimaryColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Jeddah Geofence Verification', style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: kPlusJakartaSans)),
                const SizedBox(height: 4),
                const Text(
                    "Connections originating outside regional perimeters are constrained strictly to read-only Explore Mode profiles.",
                    style: TextStyle(color: kSubtextColor,
                        fontSize: 12,
                        fontFamily: kPlusJakartaSans,
                        height: 1.4)),
                if (_isGeofenceCheckComplete) ...[
                  const SizedBox(height: 12),
                  Text(_isUserInJeddah
                      ? "Location Confirmed: Jeddah Community Access Authorized"
                      : "External Region Target: Explore Mode Enabled",
                      style: TextStyle(color: _isUserInJeddah
                          ? Colors.green.shade700
                          : kAccentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: kPlusJakartaSans)),
                ]
              ],),),
        ],),);
  }

  Widget _buildTermsCheckboxSection() {
    return InkWell(
      onTap: () => setState(() => _hasAgreedToTerms = !_hasAgreedToTerms),
      child: Row(
        children: [
          Checkbox(
            value: _hasAgreedToTerms,
            onChanged: (val) => setState(() => _hasAgreedToTerms = val ?? false),
            activeColor: kPrimaryColor,
          ),
          const Expanded(
            child: Text(
              'I agree to the Community Guidelines and Secure Access Framework.',
              style: TextStyle(
                color: kSubtextColor,
                fontSize: 13,
                fontFamily: kPlusJakartaSans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isReady) {
    return InkWell(
      onTap: isReady ? _handleSubmitForReview : null,
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
