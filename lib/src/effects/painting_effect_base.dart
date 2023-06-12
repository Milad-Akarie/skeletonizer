import 'dart:ui';

abstract class PaintingEffect {
  final double lowerBound;
  final double upperBound;
  final bool reverse;

  const PaintingEffect({
    this.reverse = false,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  });

  Paint createPaint(double t, Rect rect);
}
