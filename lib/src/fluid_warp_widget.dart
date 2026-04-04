import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

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
///   align: Alignment.center,
///   child: MyAnimatedWidget(),
/// )
/// ```
class FluidWarpWidget extends StatelessWidget {
  /// The widget to be distorted.
  final Widget child;

  /// Determines the normalized center of the distortion.
  final Alignment align;

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
    this.align = Alignment.center,
    this.strength = 0.15,
    this.radius = 0.5,
    this.enabled = true,
  });

  /// Maps [Alignment] to normalized coordinates (0.0 to 1.0).
  Offset _getNormalizedCenter() {
    return Offset(
      (align.x + 1.0) / 2.0,
      (align.y + 1.0) / 2.0,
    );
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
