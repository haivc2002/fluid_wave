import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'fluid_wave_start_align.dart';
import 'warp_anim_values.dart';
import 'fluid_wave_overlay_ui.dart';

/// The main controller for managing the fluid wave transition between views.
///
/// Use [FluidWaveController] to trigger and coordinate the transition effect.
/// It captures the current widget as an image, displays it in an overlay,
/// and reveals the new widget state through an expanding circular wave.
class FluidWaveController {
  /// The starting alignment of the fluid wave.
  FluidWaveStartAlign align;

  /// The duration of the transition animation.
  final Duration duration;

  /// The default animation curve for the transition.
  Curve curve;

  /// The initial strength of the radial warp distortion (usually 0.0 to 1.0).
  final double warpStrength;

  /// Creates a [FluidWaveController] with optional configuration.
  FluidWaveController({
    this.align = FluidWaveStartAlign.center,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.ease,
    this.warpStrength = 0.6,
  });

  GlobalKey? _boundaryKey;
  OverlayEntry? _overlay;
  ui.Image? _oldImage;
  bool _running = false;
  bool _animationStarted = false;

  /// The widget size captured during overlay insertion,
  /// used to sync shader radius with overlay pixel radius.
  Size _widgetSize = Size.zero;

  /// Notifies [FluidWaveView] to rebuild with animated warp values.
  final ValueNotifier<WarpAnimValues> warpValues = ValueNotifier(WarpAnimValues.none);

  /// Binds a [RepaintBoundary]'s [GlobalKey] to this controller.
  /// This is handle automatically by [FluidWaveView].
  void bindBoundary(GlobalKey key) => _boundaryKey = key;

  /// Triggers the wave transition effect.
  ///
  /// - [changeView]: A callback that should perform the actual UI state change (e.g. `setState`).
  /// - [align]: The point where the wave will originate from. If null, uses the controller's [align].
  /// - [curve]: The animation curve for the transition. If null, uses the controller's default [curve].
  void forward(VoidCallback changeView, {FluidWaveStartAlign? align, Curve? curve}) async {
    final effectiveCurve = curve ?? this.curve;
    if (align != null) this.align = align;
    final ctx = _boundaryKey?.currentContext;
    if (ctx == null || _running) return;
    _running = true;
    _animationStarted = false;

    // Set initial warp values (full strength, zero radius)
    warpValues.value = WarpAnimValues(
      strength: warpStrength,
      radius: 0.0,
      animating: true,
    );

    _oldImage = await _capture(ctx);
    if (_oldImage == null) {
      _running = false;
      warpValues.value = WarpAnimValues.none;
      return;
    }

    if (ctx.mounted) _insertOverlay(ctx, curve: effectiveCurve);

    // Call the user's view change logic
    changeView();

    // Ensure the above UI change has settled
    await Future.microtask(() {});

    _animationStarted = true;
    _overlay?.markNeedsBuild();
  }

  /// Captures the [RepaintBoundary] as a [ui.Image].
  Future<ui.Image?> _capture(BuildContext ctx) async {
    final ro = ctx.findRenderObject();
    if (ro is! RenderRepaintBoundary || !ro.hasSize) return null;
    return await ro.toImage(
      pixelRatio: MediaQuery.of(ctx).devicePixelRatio,
    );
  }

  /// Inserts a [FluidWaveOverlayUI] into the [Overlay] to cover the transition.
  void _insertOverlay(BuildContext context, {required Curve curve}) {
    final ctx = _boundaryKey?.currentContext;
    if (ctx == null) return;
    final renderBox = ctx.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _widgetSize = size;
    final imOld = _oldImage!;

    _overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: position.dx,
        top: position.dy,
        width: size.width,
        height: size.height,
        child: FluidWaveOverlayUI(
          oldImage: imOld,
          animationStarted: _animationStarted,
          size: size,
          align: align,
          curve: curve,
          onAnimationEnd: removeOverlay,
          duration: duration,
          onAnimationTick: _onWarpTick,
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
  }

  /// Called every frame by [FluidWaveOverlayUI] with the current curved animation value.
  ///
  /// Syncs the shader warp circle with the overlay's expanding reveal circle.
  void _onWarpTick(double curvedValue) {
    final w = _widgetSize.width;
    final h = _widgetSize.height;

    // Convert overlay's pixel radius to shader's UV-corrected radius
    // shaderDist = pixelDist / height
    final shaderRadius = h > 0
        ? curvedValue * math.sqrt(w * w + h * h) / h
        : curvedValue;

    warpValues.value = WarpAnimValues(
      strength: warpStrength * (1.0 - curvedValue),
      radius: shaderRadius,
      animating: true,
    );
  }

  /// Removes the transition overlay and resets state.
  void removeOverlay() {
    _overlay?.remove();
    _overlay = null;
    _oldImage = null;
    _running = false;
    _widgetSize = Size.zero;

    // Reset warp values to no effect
    warpValues.value = WarpAnimValues.none;
  }

  /// Disposes of the controller and its associated resources.
  ///
  /// Call this when the controller is no longer needed (e.g., in a State.dispose method)
  /// to release listeners and avoid memory leaks.
  void dispose() {
    removeOverlay();
    warpValues.dispose();
  }
}
