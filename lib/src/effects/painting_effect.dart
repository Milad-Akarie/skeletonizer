import 'package:flutter/material.dart';

/// An abstraction for skeleton painting effects
/// consumed by the [Skeletonizer.animationController]
abstract class PaintingEffect {
  /// The starting value for the animation controller
  final double lowerBound;

  /// The ending value for the animation controller
  final double upperBound;

  /// Whether to animate in reverse
  final bool reverse;

  /// The duration of the effect animation
  final Duration duration;

  /// Default constructor
  const PaintingEffect({
    this.reverse = false,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    required this.duration,
  });

  /// Evaluates the painting effect at animation value [t]
  ///
  /// typically used to create shaders e.g [LinearGradient] shaders
  Paint createPaint(double t, Rect rect, TextDirection? textDirection);

  /// lerp between two painting effects
  PaintingEffect lerp(PaintingEffect? other, double t);
}
