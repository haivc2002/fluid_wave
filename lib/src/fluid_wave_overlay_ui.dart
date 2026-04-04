import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'fluid_wave_painter.dart';

/// An internal UI component displayed in the [Overlay] during transition.
///
/// This widget coordinates the animation that reveals the new view by
/// increasing the radius of a circular hole in the captured old image.
class FluidWaveOverlayUI extends StatefulWidget {
  /// The image capture of the previous UI state.
  final ui.Image oldImage;

  /// Whether the transition animation should start.
  final bool animationStarted;

  /// Callback executed when the reveal animation completes.
  final VoidCallback onAnimationEnd;

  /// The alignment where the revealing wave originates.
  final Alignment align;

  /// The dimensions of the overlay area.
  final Size size;

  /// The total duration of the revelation.
  final Duration duration;

  /// Callback called every animation frame with current progress.
  final ValueChanged<double>? onAnimationTick;

  /// The animation curve to use for the reveal.
  final Curve curve;

  /// Creates a [FluidWaveOverlayUI].
  const FluidWaveOverlayUI({
    super.key,
    required this.oldImage,
    required this.align,
    required this.size,
    required this.animationStarted,
    required this.onAnimationEnd,
    this.onAnimationTick,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.ease,
  });

  @override
  State<FluidWaveOverlayUI> createState() => _FluidWaveOverlayUIState();
}

class _FluidWaveOverlayUIState extends State<FluidWaveOverlayUI> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _curvedAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationEnd();
      }
    });

    _curvedAnim = CurvedAnimation(
      parent: _anim,
      curve: widget.curve,
    );

    _curvedAnim.addListener(() {
      widget.onAnimationTick?.call(_curvedAnim.value);
    });

    if (widget.animationStarted) {
      _anim.forward();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FluidWaveOverlayUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationStarted && (!oldWidget.animationStarted || _anim.isDismissed)) {
      _anim.forward(from: 0);
    }
  }

  /// Calculates the wave origin pixel position based on [Alignment].
  Offset get resolveWaveCenter => widget.align.alongSize(widget.size);

  @override
  Widget build(BuildContext context) {
    if (!widget.animationStarted) {
      return RawImage(
        image: widget.oldImage,
        fit: BoxFit.cover,
      );
    }

    return AnimatedBuilder(
      animation: _curvedAnim,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size.width, widget.size.height),
          painter: FluidWavePainter(
            image: widget.oldImage,
            progress: _curvedAnim.value,
            center: resolveWaveCenter,
          ),
        );
      },
    );
  }
}
