import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'fluid_wave_start_align.dart';

/// A widget that applies a real-time radial warp distortion to its [child].
///
/// Unlike a static snapshot approach, this uses [AnimatedSampler] which
/// re-captures the child widget **every frame**. This allows live animations
/// (e.g. progress indicators) to be distorted in real-time.
///
/// Think of it as placing a distortion lens over a live widget — the widget
/// underneath keeps running, and you see it through the warped lens.
///
/// ```dart
/// FluidWarpWidget(
///   strength: 0.15,
///   radius: 0.5,
///   align: FluidWaveStartAlign.center,
///   child: MyAnimatedWidget(),
/// )
/// ```
class FluidWarpWidget extends StatelessWidget {
  /// The widget to be distorted.
  final Widget child;

  /// Determines the normalized center of the distortion.
  final FluidWaveStartAlign align;

  /// The strength of the radial warp effect.
  final double strength;

  /// The radius of the warp area, normally relative to child height.
  final double radius;

  /// When false, the child is rendered normally without distortion.
  final bool enabled;

  /// Creates a [FluidWarpWidget].
  const FluidWarpWidget({
    super.key,
    required this.child,
    this.align = FluidWaveStartAlign.center,
    this.strength = 0.15,
    this.radius = 0.5,
    this.enabled = true,
  });

  /// Maps [FluidWaveStartAlign] to normalized coordinates (0.0 to 1.0).
  Offset _getNormalizedCenter() {
    switch (align) {
      case FluidWaveStartAlign.topCenter:
        return const Offset(0.5, 0.0);
      case FluidWaveStartAlign.bottomCenter:
        return const Offset(0.5, 1.0);
      case FluidWaveStartAlign.centerLeft:
        return const Offset(0.0, 0.5);
      case FluidWaveStartAlign.centerRight:
        return const Offset(1.0, 0.5);
      case FluidWaveStartAlign.center:
        return const Offset(0.5, 0.5);
      case FluidWaveStartAlign.topLeft:
        return const Offset(0.0, 0.0);
      case FluidWaveStartAlign.topRight:
        return const Offset(1.0, 0.0);
      case FluidWaveStartAlign.bottomLeft:
        return const Offset(0.0, 1.0);
      case FluidWaveStartAlign.bottomRight:
        return const Offset(1.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, _) {
        return AnimatedSampler(
          (ui.Image image, Size size, Canvas canvas) {
            shader.setFloat(0, size.width);
            shader.setFloat(1, size.height);
            shader.setImageSampler(0, image);
            shader.setFloat(2, strength);
            shader.setFloat(3, radius);

            final center = _getNormalizedCenter();
            shader.setFloat(4, center.dx);
            shader.setFloat(5, center.dy);

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
          enabled: enabled,
          child: child,
        );
      },
      assetKey: "packages/fluid_wave/shaders/radial_warp.frag",
    );
  }
}
