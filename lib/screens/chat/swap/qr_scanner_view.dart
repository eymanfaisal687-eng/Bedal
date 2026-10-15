// =========================================================================
// 📄 FILE: qr_scanner_view.dart
// ROLE: Dedicated Camera QR Code Scanner & Session Verification View for Bedal
// =========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:bedal/models/swap_session_model.dart';

const kPrimaryColor = Color(0xFFC5A15B); // Muted Bedal gold
const kCanvasColor = Color(0xFF16171A);
const kPlusJakartaSans = 'Plus Jakarta Sans';

enum QrScanTarget { cafe, participant }

class QrScannerView extends StatefulWidget {
  final SwapSession session;
  final QrScanTarget scanTarget;

  const QrScannerView({
    super.key,
    required this.session,
    this.scanTarget = QrScanTarget.participant,
  });

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera available on this device.';
        });
        return;
      }

      final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Camera permission required or unavailable: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleSuccessfulScan() {
    if (_isVerifying) return;
    setState(() {
      _isVerifying = true;
    });

    // Simulate cryptographic backend validation and role checking
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.pop(context, widget.scanTarget);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.scanTarget == QrScanTarget.cafe
        ? 'Scan Café QR Code'
        : 'Scan Participant QR Code';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kCanvasColor,
        body: Stack(
          children: [
            if (_isCameraInitialized && _controller != null)
              Positioned.fill(
                child: CameraPreview(_controller!),
              )
            else
              Positioned.fill(
                child: Center(
                  child: _errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: kPlusJakartaSans,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(color: kPrimaryColor),
                ),
              ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context, null),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kPrimaryColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withValues(alpha: 0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        if (_isVerifying)
                          const Center(
                            child: CircularProgressIndicator(color: kPrimaryColor),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      widget.scanTarget == QrScanTarget.cafe
                          ? 'Scan Draft Café Counter QR Code'
                          : 'Scan your partner\'s participant QR code',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: kPlusJakartaSans,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Position the QR code within the frame to verify.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontFamily: kPlusJakartaSans,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 24,
              right: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                onPressed: _isVerifying ? null : _handleSuccessfulScan,
                child: Text(
                  _isVerifying
                      ? 'Validating on Backend...'
                      : (widget.scanTarget == QrScanTarget.cafe
                          ? 'Simulate Café Order & QR Scan'
                          : 'Simulate Participant QR Scan'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFamily: kPlusJakartaSans,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
