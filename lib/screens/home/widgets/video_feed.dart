import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFeed extends StatefulWidget {
  final String videoAsset;

  // NEW:
  // Controls if the video should be playing (e.g. if the screen is active).
  final bool isActive;

  // Called when the user taps the main video.
  final VoidCallback? onVideoTap;

  const VideoFeed({
    super.key,
    required this.videoAsset,
    this.onVideoTap,
    this.isActive = true,
  });

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  VideoPlayerController? _controller;

  bool _hasError = false;
  bool _isMuted = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(covariant VideoFeed oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  // ================================================================
  // VIDEO INITIALIZATION
  // ================================================================

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        widget.videoAsset,
      );

      _controller = controller;

      await controller.initialize();

      await controller.setLooping(true);

      await controller.setVolume(
        _isMuted ? 0.0 : 1.0,
      );

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });

      if (widget.isActive) {
        await controller.play();
      }
    } catch (e) {
      debugPrint('VIDEO ERROR: $e');

      if (!mounted) return;

      setState(() {
        _hasError = true;
      });
    }
  }

  // ================================================================
  // PLAY / PAUSE
  // ================================================================

  void _togglePlay() {
    final controller = _controller;

    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    setState(() {});
  }

  // ================================================================
  // MUTE / UNMUTE
  // ================================================================

  void _toggleMute() {
    final controller = _controller;

    if (controller == null) return;

    setState(() {
      _isMuted = !_isMuted;
    });

    controller.setVolume(
      _isMuted ? 0.0 : 1.0,
    );
  }

  // ================================================================
  // MAIN VIDEO TAP
  // ================================================================

  void _handleVideoTap() {
    // If HomeScreen supplied an action,
    // use it to open SkillPostDetails.
    if (widget.onVideoTap != null) {
      widget.onVideoTap!();
      return;
    }

    // Otherwise keep the old play/pause behavior.
    _togglePlay();
  }

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildVideoArea(
        child: _buildPlaceholder(),
      );
    }

    final controller = _controller;

    if (controller == null || !_isInitialized) {
      return _buildVideoArea(
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFC5A059),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _handleVideoTap,

      child: _buildVideoArea(
        child: Stack(
          fit: StackFit.expand,
          children: [

            // ========================================================
            // VIDEO
            // ========================================================

            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),

            // ========================================================
            // PLAY / PAUSE INDICATOR
            // ========================================================

            IgnorePointer(
              child: AnimatedOpacity(
                opacity: controller.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),

                child: Center(
                  child: Container(
                    width: 58,
                    height: 58,

                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
            ),

            // ========================================================
            // MUTE BUTTON
            // ========================================================

            Positioned(
              right: 14,
              bottom: 18,

              child: GestureDetector(
                onTap: _toggleMute,

                child: Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1,
                    ),
                  ),

                  child: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ),

            // ========================================================
            // BOTTOM GRADIENT
            // ========================================================

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,

              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,

                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // FULL-BLEED VIDEO AREA
  // ================================================================

  Widget _buildVideoArea({
    required Widget child,
  }) {
    return ClipRect(
      child: ColoredBox(
        color: Colors.black,
        child: child,
      ),
    );
  }

  // ================================================================
  // VIDEO ERROR PLACEHOLDER
  // ================================================================

  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/character_images/reem.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}