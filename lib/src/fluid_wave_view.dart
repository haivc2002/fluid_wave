import 'package:flutter/material.dart';

import 'fluid_wave_controller.dart';
import 'warp_anim_values.dart';
import 'fluid_warp_widget.dart';

/// A widget that captures its child into an image and enables
/// a fluid wave transition effect when switching views.
///
/// [FluidWaveView] wraps the given [child] with a [RepaintBoundary]
/// so that the widget can be rendered into an image for transition
/// animations controlled by [FluidWaveController].
///
/// During the wave transition, a [FluidWarpWidget] shader distortion
/// is animated in sync:
/// - **strength**: decreases from [FluidWaveController.warpStrength] → 0
/// - **radius**: increases from 0 → [FluidWaveController.warpRadiusEnd]
///
/// Typical usage:
/// ```dart
/// final controller = FluidWaveController();
///
/// FluidWaveView(
///   controller: controller,
///   child: YourWidget(),
/// );
/// ```
///
/// Call `controller.forward()` to trigger the wave transition.
class FluidWaveView extends StatefulWidget {
  /// The controller that coordinates the transition.
  final FluidWaveController controller;

  /// The child widget to be transitions.
  final Widget child;

  /// Creates a [FluidWaveView] with the required [controller] and [child].
  const FluidWaveView({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<FluidWaveView> createState() => _FluidWaveViewState();
}

class _FluidWaveViewState extends State<FluidWaveView> {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller.bindBoundary(_repaintKey);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WarpAnimValues>(
      valueListenable: widget.controller.warpValues,
      builder: (context, warp, _) {
        return FluidWarpWidget(
          align: widget.controller.align,
          strength: warp.strength,
          radius: warp.radius,
          enabled: warp.animating,
          child: RepaintBoundary(
            key: _repaintKey,
            child: widget.child,
          ),
        );
      },
    );
  }
}
