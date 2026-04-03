import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] that renders the previously captured image and
/// "cuts out" an expanding circular hole to reveal the new UI underneath.
class FluidWavePainter extends CustomPainter {
  /// The image capture of the previous UI state.
  final ui.Image image;

  /// The current animation progress (0.0 to 1.0).
  final double progress;

  /// The center point of the circular reveal.
  final Offset center;

  /// Creates a [FluidWavePainter].
  FluidWavePainter({
    required this.image,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
      fit: BoxFit.cover,
      isAntiAlias: true,
    );

    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);
    final currentRadius = maxRadius * progress;

    final holePaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..isAntiAlias = true;

    canvas.drawCircle(center, currentRadius, holePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FluidWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.image != image;
  }
}
