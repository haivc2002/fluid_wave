/// Represents the state of the warp animation for the fluid wave effect.
///
/// This model is used to pass animation parameters between the
/// [FluidWaveController] and the [FluidWarpWidget].
class WarpAnimValues {
  /// The current strength of the warp distortion.
  /// A value of 0.0 means no distortion, while higher values
  /// (e.g., 0.6) create a stronger liquid effect.
  final double strength;

  /// The current radius of the warp circle, usually normalized
  /// relative to the widget's height (due to shader aspect correction).
  final double radius;

  /// Whether the animation is currently active.
  final bool animating;

  /// Creates a [WarpAnimValues] instance.
  const WarpAnimValues({
    required this.strength,
    required this.radius,
    required this.animating,
  });

  /// A constant representing the default (no distortion) state.
  static const none = WarpAnimValues(
    strength: 0.0,
    radius: 0.0,
    animating: false,
  );
}
