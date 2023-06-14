import 'dart:ui';

abstract class PaintingEffect {
  final double lowerBound;
  final double upperBound;
  final bool reverse;
  final Duration duration;
  const PaintingEffect({
    this.reverse = false,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    required this.duration,
  });

  Paint createPaint(double t, Rect rect);
}
