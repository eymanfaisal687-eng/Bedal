// =========================================================================
// 🎥 FILE: skill_camera_screen.dart
// ROLE: Bedal Skill Video Camera
// =========================================================================
//
// FLOW:
//
// Home +
//
//      ↓
//
// In-App Camera
//
//      ↓
//
// Record up to 15 seconds
//
//      ↓
//
// Preview / Retake / Continue
//
//      ↓
//
// Skill Details screen (next file)
//
// IMPORTANT:
// • No gallery
// • No photo upload
// • Recording happens inside Bedal
// • Maximum recording length = 15 seconds
// • Video is returned as an XFile when Continue is pressed
// =========================================================================

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SkillCameraScreen extends StatefulWidget {
  const SkillCameraScreen({
    super.key,
  });

  @override
  State<SkillCameraScreen> createState() => _SkillCameraScreenState();
}

class _SkillCameraScreenState extends State<SkillCameraScreen>
    with WidgetsBindingObserver {
  // =========================================================================
  // BEDAL COLORS
  // =========================================================================

  static const Color gold = Color(0xFFC5A059);
  static const Color background = Color(0xFF111111);

  // =========================================================================
  // CAMERA
  // =========================================================================

  CameraController? _controller;

  CameraDescription? _cameraDescription;

  bool _isInitializing = true;
  bool _isRecording = false;
  bool _isFinishingRecording = false;

  String? _errorMessage;

  // =========================================================================
  // RECORDING
  // =========================================================================

  static const int _maxRecordingSeconds = 15;

  Timer? _recordingTimer;

  int _recordingSeconds = 0;

  // =========================================================================
  // RECORDED VIDEO
  // =========================================================================

  XFile? _recordedVideo;

  // =========================================================================
  // CAMERA STATE
  // =========================================================================

  // =========================================================================
  // LIFECYCLE
  // =========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _recordingTimer?.cancel();

    _controller?.dispose();

    super.dispose();
  }

  // =========================================================================
  // APP LIFECYCLE
  // =========================================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;

    if (controller == null) {
      return;
    }

    // If the app goes into the background, release the camera.
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();

      _controller = null;

      if (mounted) {
        setState(() {
          _isInitializing = true;
        });
      }

      return;
    }

    // Re-open camera when returning to Bedal.
    if (state == AppLifecycleState.resumed) {
      if (_cameraDescription != null && _recordedVideo == null) {
        _initializeCamera(
          description: _cameraDescription,
        );
      }
    }
  }

  // =========================================================================
  // CAMERA INITIALIZATION
  // =========================================================================

  Future<void> _initializeCamera({
    CameraDescription? description,
  }) async {
    if (mounted) {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });
    }

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw CameraException(
          'NoCameraAvailable',
          'No camera was found on this device.',
        );
      }

      CameraDescription selectedCamera;

      if (description != null) {
        selectedCamera = description;
      } else {
        // Prefer the rear camera when opening Bedal.
        selectedCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
      }

      _cameraDescription = selectedCamera;

      final controller = CameraController(
        selectedCamera,

        // High quality without unnecessarily making the recording enormous.
        ResolutionPreset.high,

        // Skill videos can contain explanations, so keep audio enabled.
        enableAudio: true,
      );

      _controller = controller;

      await controller.initialize();

      // Keep portrait recording aligned with the Bedal feed.
      await controller.lockCaptureOrientation(
        DeviceOrientation.portraitUp,
      );

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _isInitializing = false;
        _errorMessage = null;
      });
    } on CameraException catch (e) {
      debugPrint(
        'BEDAL CAMERA ERROR: ${e.code} - ${e.description}',
      );

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _errorMessage = _cameraErrorMessage(e);
      });
    } catch (e) {
      debugPrint('BEDAL CAMERA ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _errorMessage = 'Unable to open the camera.';
      });
    }
  }

  // =========================================================================
  // CAMERA ERROR MESSAGES
  // =========================================================================

  String _cameraErrorMessage(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Camera access was denied. Please allow camera access in Settings.';

      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera access is disabled. Please enable it in Settings.';

      case 'CameraAccessRestricted':
        return 'Camera access is currently restricted.';

      case 'AudioAccessDenied':
        return 'Microphone access was denied. Please allow microphone access.';

      case 'AudioAccessDeniedWithoutPrompt':
        return 'Microphone access is disabled. Please enable it in Settings.';

      case 'AudioAccessRestricted':
        return 'Microphone access is currently restricted.';

      default:
        return error.description ?? 'Unable to access the camera.';
    }
  }

  // =========================================================================
  // START RECORDING
  // =========================================================================

  Future<void> _startRecording() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isRecording ||
        _isFinishingRecording) {
      return;
    }

    try {
      await controller.startVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
      });

      _recordingTimer?.cancel();

      _recordingTimer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) async {
          if (!mounted) {
            timer.cancel();
            return;
          }

          setState(() {
            _recordingSeconds++;
          });

          // Automatically stop at exactly 15 seconds.
          if (_recordingSeconds >= _maxRecordingSeconds) {
            timer.cancel();

            await _stopRecording();
          }
        },
      );
    } on CameraException catch (e) {
      debugPrint(
        'BEDAL RECORDING ERROR: ${e.code} - ${e.description}',
      );

      if (!mounted) return;

      _showMessage(
        'Could not start recording.',
      );
    }
  }

  // =========================================================================
  // STOP RECORDING
  // =========================================================================

  Future<void> _stopRecording() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isRecordingVideo ||
        _isFinishingRecording) {
      return;
    }

    _isFinishingRecording = true;

    _recordingTimer?.cancel();
    _recordingTimer = null;

    try {
      final video = await controller.stopVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _recordedVideo = video;
      });
    } on CameraException catch (e) {
      debugPrint(
        'BEDAL STOP RECORDING ERROR: ${e.code} - ${e.description}',
      );

      if (mounted) {
        setState(() {
          _isRecording = false;
        });

        _showMessage(
          'Something went wrong while saving your video.',
        );
      }
    } finally {
      _isFinishingRecording = false;
    }
  }

  // =========================================================================
  // SWITCH CAMERA
  // =========================================================================

  Future<void> _switchCamera() async {
    if (_isRecording || _isFinishingRecording) {
      return;
    }

    final cameras = await availableCameras();

    if (cameras.length < 2) {
      _showMessage('This device only has one camera.');
      return;
    }

    final currentDirection = _cameraDescription?.lensDirection;

    final newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection != currentDirection,
      orElse: () => cameras.first,
    );

    await _controller?.dispose();

    _controller = null;

    await _initializeCamera(
      description: newCamera,
    );
  }

  // =========================================================================
  // RETAKE
  // =========================================================================

  Future<void> _retakeVideo() async {
    if (_recordedVideo == null) {
      return;
    }

    setState(() {
      _recordedVideo = null;
      _recordingSeconds = 0;
    });

    await _initializeCamera(
      description: _cameraDescription,
    );
  }

  // =========================================================================
  // CONTINUE
  // =========================================================================

  void _continueWithVideo() {
    final video = _recordedVideo;

    if (video == null) {
      return;
    }

    // For now we return the recorded video to whoever opened this screen.
    //
    // The next screen we build will receive this XFile and show:
    //
    // Video
    // ↓
    // Skill I Offer
    // Skill I Want To Learn
    // Bedal Hours
    // Gender Preference
    // Saudi / Expat / Student / Tourist
    // Meeting Preference
    // ↓
    // Publish
    //
    Navigator.of(context).pop(video);
  }

  // =========================================================================
  // MESSAGE
  // =========================================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF25231F),
        ),
      );
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        bottom: false,
        child: _recordedVideo != null
            ? _buildRecordedState()
            : _buildCameraState(),
      ),
    );
  }

  // =========================================================================
  // CAMERA STATE
  // =========================================================================

  Widget _buildCameraState() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: gold,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return _buildErrorState();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ================================================================
        // CAMERA PREVIEW
        // ================================================================

        _buildCameraPreview(controller),

        // ================================================================
        // TOP GRADIENT
        // ================================================================

        IgnorePointer(
          child: Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.70),
                  Color.fromRGBO(0, 0, 0, 0.0),
                ],
              ),
            ),
          ),
        ),

        // ================================================================
        // BOTTOM GRADIENT
        // ================================================================

        IgnorePointer(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.85),
                    Color.fromRGBO(0, 0, 0, 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ================================================================
        // TOP BAR
        // ================================================================

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _buildTopBar(),
        ),

        // ================================================================
        // RECORDING TIMER
        // ================================================================

        if (_isRecording)
          Positioned(
            top: 78,
            left: 0,
            right: 0,
            child: Center(
              child: _buildRecordingTimer(),
            ),
          ),

        // ================================================================
        // RECORDING CONTROL
        // ================================================================

        Positioned(
          left: 0,
          right: 0,
          bottom: 48,
          child: _buildCaptureControls(),
        ),

        // ================================================================
        // SKILL TIP
        // ================================================================

        if (!_isRecording)
          Positioned(
            left: 32,
            right: 32,
            bottom: 145,
            child: _buildSkillTip(),
          ),
      ],
    );
  }

  // =========================================================================
  // CAMERA PREVIEW
  // =========================================================================

  Widget _buildCameraPreview(CameraController controller,) {
    final size = MediaQuery.sizeOf(context);

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          child: SizedBox(
            width: size.height *
                controller.value.aspectRatio,
            height: size.height,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // TOP BAR
  // =========================================================================

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // CLOSE
        _CameraCircleButton(
          icon: Icons.close_rounded,
          onTap: _isRecording
              ? null
              : () => Navigator.of(context).pop(),
        ),

        // TITLE
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Create Skill Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),

        // CAMERA SWITCH
        _CameraCircleButton(
          icon: Icons.flip_camera_ios_rounded,
          onTap: _isRecording
              ? null
              : _switchCamera,
        ),
      ],
    );
  }

  // =========================================================================
  // RECORDING TIMER
  // =========================================================================

  Widget _buildRecordingTimer() {
    final remaining =
        _maxRecordingSeconds - _recordingSeconds;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            '00:${remaining.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CAPTURE CONTROLS
  // =========================================================================

  Widget _buildCaptureControls() {
    return Column(
      children: [
        // RECORD BUTTON
        GestureDetector(
          onTap: _isRecording
              ? _stopRecording
              : _startRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: _isRecording ? 76 : 82,
            height: _isRecording ? 76 : 82,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: _isRecording
                    ? Colors.redAccent
                    : gold,
                shape: _isRecording
                    ? BoxShape.circle
                    : BoxShape.circle,
              ),
              child: _isRecording
                  ? Center(
                child: Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          _isRecording
              ? 'Tap to finish'
              : 'Tap to record',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '15 seconds max',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // SKILL TIP
  // =========================================================================

  Widget _buildSkillTip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: gold,
            size: 19,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Show what you can teach. Keep it clear, useful and natural.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // RECORDED VIDEO STATE
  // =========================================================================

  Widget _buildRecordedState() {
    final video = _recordedVideo;

    if (video == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ================================================================
        // VIDEO PREVIEW
        // ================================================================

        _RecordedVideoPreview(
          videoFile: video,
        ),

        // ================================================================
        // TOP GRADIENT
        // ================================================================

        IgnorePointer(
          child: Container(
            height: 170,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.72),
                  Color.fromRGBO(0, 0, 0, 0.0),
                ],
              ),
            ),
          ),
        ),

        // ================================================================
        // HEADER
        // ================================================================

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _CameraCircleButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              const Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 44,
                height: 44,
              ),
            ],
          ),
        ),

        // ================================================================
        // BOTTOM ACTIONS
        // ================================================================

        Positioned(
          left: 24,
          right: 24,
          bottom: 38,
          child: Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  icon: Icons.refresh_rounded,
                  label: 'Retake',
                  onTap: _retakeVideo,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: _PrimaryButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Continue',
                  onTap: _continueWithVideo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // ERROR STATE
  // =========================================================================

  Widget _buildErrorState() {
    return Container(
      color: background,
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.videocam_off_outlined,
                color: gold,
                size: 32,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Camera unavailable',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _errorMessage ??
                  'Bedal could not access your camera.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            _PrimaryButton(
              icon: Icons.refresh_rounded,
              label: 'Try Again',
              onTap: () =>
                  _initializeCamera(
                    description: _cameraDescription,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// CAMERA CIRCLE BUTTON
// ===========================================================================

class _CameraCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CameraCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.42),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: onTap == null
                ? Colors.white38
                : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PRIMARY BUTTON
// ===========================================================================

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const Color gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SECONDARY BUTTON
// ===========================================================================

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 19,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.28),
          ),
          backgroundColor: Colors.black.withValues(alpha: 0.30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// RECORDED VIDEO PREVIEW
// ===========================================================================

class _RecordedVideoPreview extends StatefulWidget {
  final XFile videoFile;

  const _RecordedVideoPreview({
    required this.videoFile,
  });

  @override
  State<_RecordedVideoPreview> createState() =>
      _RecordedVideoPreviewState();
}

class _RecordedVideoPreviewState extends State<_RecordedVideoPreview> {
  // This will be implemented with video_player in the preview stage.
  //
  // Keeping the recording screen independent means the next screen can
  // become the dedicated Bedal skill-video editor/preview.
  //
  // For now, we display a clean placeholder until the preview player is
  // connected.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFFC5A059),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Video recorded',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}