import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';

/// Creates a painting effect where a two colors are lerped
/// back nad forward based on animation value
class PulseEffect extends PaintingEffect {
  /// The color to fade from
  final Color from;

  /// The color to fade to
  final Color to;

  /// Default constructor
  const PulseEffect(
      {this.from = const Color(0xFFEBEBF4),
      this.to = const Color(0xFFF6F6F6),
      super.lowerBound,
      super.upperBound,
      super.duration = const Duration(milliseconds: 1000)})
      : super(reverse: true);

  @override
  Paint createPaint(double t, Rect rect,TextDirection? textDirection) {
    final color = Color.lerp(from, to, t)!;

    // We're creating a shader here because [ShadedElement] component
    // will use a shader mask to shade original elements
    //
    // todo: find a better way to create a one-color shader!
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
