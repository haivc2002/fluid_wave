/// Defines the starting position of the fluid wave animation
/// relative to the bounds of the target widget.
///
/// The selected value determines where the circular wave originates
/// before expanding to reveal the next view.
enum FluidWaveStartAlign {
  /// Starts the wave from the top-center edge of the widget.
  topCenter,

  /// Starts the wave from the bottom-center edge of the widget.
  bottomCenter,

  /// Starts the wave from the center-right edge of the widget.
  centerRight,

  /// Starts the wave from the center-left edge of the widget.
  centerLeft,

  /// Starts the wave from the exact center of the widget.
  center,

  /// Starts the wave from the top-left corner of the widget.
  topLeft,

  /// Starts the wave from the top-right corner of the widget.
  topRight,

  /// Starts the wave from the bottom-left corner of the widget.
  bottomLeft,

  /// Starts the wave from the bottom-right corner of the widget.
  bottomRight,
}
