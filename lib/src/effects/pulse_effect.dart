import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';

class PulseEffect extends PaintingEffect {
  final Color from;
  final Color to;

  const PulseEffect(
      {this.from = const Color(0xFFEBEBF4),
      this.to = const Color(0xFFF6F6F6),
      super.lowerBound,
      super.upperBound,
      super.duration = const Duration(milliseconds: 1000)})
      : super(reverse: true);

  @override
  Paint createPaint(double t, Rect rect) {
    final color = Color.lerp(from, to, t)!;
    // if possible find a better way to create one-color shaders!
    return Paint()
      ..shader = LinearGradient(
        colors: [color, color],
      ).createShader(rect);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PulseEffect &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to &&
          duration == other.duration;

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ duration.hashCode;
}
