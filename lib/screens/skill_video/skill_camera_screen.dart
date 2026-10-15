// =========================================================================
// 🎥 FILE: skill_camera_screen.dart
// ROLE: Bedal Skill Video Camera with video playback preview
// =========================================================================

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SkillCameraScreen extends StatefulWidget {
  const SkillCameraScreen({
    super.key,
  });

  @override
  State<SkillCameraScreen> createState() => _SkillCameraScreenState();
}

class _SkillCameraScreenState extends State<SkillCameraScreen>
    with WidgetsBindingObserver {
  static const Color gold = Color(0xFFC5A059);
  static const Color background = Color(0xFF111111);

  CameraController? _controller;
  CameraDescription? _cameraDescription;

  bool _isInitializing = true;
  bool _isRecording = false;
  bool _isFinishingRecording = false;

  String? _errorMessage;

  static const int _maxRecordingSeconds = 30; // 30 seconds max as requested
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  XFile? _recordedVideo;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      controller.dispose();
      _controller = null;
      if (mounted) {
        setState(() => _isInitializing = true);
      }
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (_cameraDescription != null && _recordedVideo == null) {
        _initializeCamera(description: _cameraDescription);
      }
    }
  }

  Future<void> _initializeCamera({CameraDescription? description}) async {
    if (mounted) {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NoCameraAvailable', 'No camera found on device.');
      }

      CameraDescription selectedCamera = description ?? cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraDescription = selectedCamera;

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      _controller = controller;
      await controller.initialize();
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _isInitializing = false;
        _errorMessage = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = e.description ?? 'Unable to access camera.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Unable to open camera.';
      });
    }
  }

  Future<void> _startRecording() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isRecording || _isFinishingRecording) {
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
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _recordingSeconds++;
        });

        if (_recordingSeconds >= _maxRecordingSeconds) {
          timer.cancel();
          await _stopRecording();
        }
      });
    } on CameraException {
      if (!mounted) return;
      _showMessage('Could not start recording.');
    }
  }

  Future<void> _stopRecording() async {
    final controller = _controller;
    if (controller == null || !controller.value.isRecordingVideo || _isFinishingRecording) {
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
    } on CameraException {
      if (mounted) {
        setState(() => _isRecording = false);
        _showMessage('Something went wrong while saving your video.');
      }
    } finally {
      _isFinishingRecording = false;
    }
  }

  Future<void> _switchCamera() async {
    if (_isRecording || _isFinishingRecording) return;
    final cameras = await availableCameras();
    if (cameras.length < 2) {
      _showMessage('Only one camera available.');
      return;
    }

    final currentDir = _cameraDescription?.lensDirection;
    final newCamera = cameras.firstWhere((c) => c.lensDirection != currentDir, orElse: () => cameras.first);

    await _controller?.dispose();
    _controller = null;
    await _initializeCamera(description: newCamera);
  }

  Future<void> _retakeVideo() async {
    if (_recordedVideo == null) return;
    setState(() {
      _recordedVideo = null;
      _recordingSeconds = 0;
    });
    await _initializeCamera(description: _cameraDescription);
  }

  void _continueWithVideo() {
    final video = _recordedVideo;
    if (video == null) return;
    Navigator.of(context).pop(video);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: _recordedVideo != null ? _buildRecordedState() : _buildCameraState(),
      ),
    );
  }

  Widget _buildCameraState() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: gold));
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return _buildErrorState();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(controller)),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _buildTopBar(),
        ),
        if (_isRecording)
          Positioned(
            top: 78,
            left: 0,
            right: 0,
            child: Center(child: _buildRecordingTimer()),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 48,
          child: _buildCaptureControls(),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CameraCircleButton(
          icon: Icons.close_rounded,
          onTap: _isRecording ? null : () => Navigator.of(context).pop(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Record 30s Skill Reel',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        _CameraCircleButton(
          icon: Icons.flip_camera_ios_rounded,
          onTap: _isRecording ? null : _switchCamera,
        ),
      ],
    );
  }

  Widget _buildRecordingTimer() {
    final remaining = _maxRecordingSeconds - _recordingSeconds;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerDot(),
          const SizedBox(width: 7),
          Text(
            '00:${remaining.toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Column(
      children: [
        GestureDetector(
          onTap: _isRecording ? _stopRecording : _startRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 82,
            height: 82,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _isRecording ? Colors.redAccent : gold,
                shape: BoxShape.circle,
              ),
              child: _isRecording
                  ? Center(
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isRecording ? 'Tap to finish' : 'Tap to record',
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          '30 seconds max',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildRecordedState() {
    final video = _recordedVideo;
    if (video == null) return const SizedBox.shrink();

    return Stack(
      fit: StackFit.expand,
      children: [
        _RecordedVideoPreview(videoFile: video),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CameraCircleButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              const Text(
                'Preview Recorded Reel',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 44, height: 44),
            ],
          ),
        ),
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

  Widget _buildErrorState() {
    return Container(
      color: background,
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_outlined, color: gold, size: 32),
            const SizedBox(height: 22),
            const Text('Camera unavailable', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(_errorMessage ?? 'Unable to access camera.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 24),
            _PrimaryButton(icon: Icons.refresh_rounded, label: 'Try Again', onTap: () => _initializeCamera(description: _cameraDescription)),
          ],
        ),
      ),
    );
  }
}

class ContainerDot extends StatelessWidget {
  const ContainerDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}

class _CameraCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CameraCircleButton({required this.icon, required this.onTap});

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
          child: Icon(icon, color: onTap == null ? Colors.white38 : Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC5A059),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 19),
        label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

class _RecordedVideoPreview extends StatefulWidget {
  final XFile videoFile;

  const _RecordedVideoPreview({required this.videoFile});

  @override
  State<_RecordedVideoPreview> createState() => _RecordedVideoPreviewState();
}

class _RecordedVideoPreviewState extends State<_RecordedVideoPreview> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller.setLooping(true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Color(0xFFC5A059)),
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
