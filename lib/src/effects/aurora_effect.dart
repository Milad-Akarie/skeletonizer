import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import 'painting_effect.dart';

/// An effect that paints a rotating gradient around the widget's border,
/// creating an aurora-like effect.
///
/// This effect is ideal for circular or stadium-shaped widgets. On rectangles,
/// the gradient will appear to move faster at the corners.
class AuroraEffect extends PaintingEffect {
  /// The colors of the gradient.
  final List<Color>? colors;
  /// The stops of the gradient.
  final List<double>? stops;

  /// The tile mode of the gradient.
  final TileMode tileMode;

  /// The width of the border stroke.
  final double strokeWidth;

  /// The tilt angle of the gradient in radians.
  final double tilt;

  static List<Color> get defaultColors => const [
    Color(0x00FFFFFF),
    Color(0xFFEBEBF4),
  ];
  /// Creates an AuroraEffect.
  const AuroraEffect({
     this.colors,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.strokeWidth = 1.0,
    this.tilt = 0.0,
    super.lowerBound = 0.0,
    super.upperBound = 1.0,
    super.duration = const Duration(milliseconds: 1500),
    super.reverse,
  });

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    final List<Color> auroraColors = colors ?? defaultColors;

    return Paint()
      ..shader = SweepGradient(
        center: Alignment.center.resolve(textDirection),
        colors: auroraColors,
        stops: stops,
        tileMode: tileMode,
        transform: _RotationTransform(
            angle: t * 2 * math.pi * (reverse ? -1 : 1), tilt: tilt),
      ).createShader(rect, textDirection: textDirection)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is AuroraEffect) {
      final List<Color>? lerpedColors;
      if (colors != null && other.colors != null) {
        lerpedColors = List.generate(
          math.max(colors!.length, other.colors!.length),
              (i) {
            final color1 = colors!.length > i ? colors![i] : colors!.last;
            final color2 = other.colors!.length > i ? other.colors![i] : other.colors!.last;
            return Color.lerp(color1, color2, t)!;
          },
        );
      } else {
        lerpedColors = t < 0.5 ? colors : other.colors;
      }

      return AuroraEffect(
        colors: lerpedColors,
        stops: stops,
        tileMode: tileMode,
        strokeWidth: strokeWidth,
        duration: duration,
        tilt: lerpDouble(tilt, other.tilt, t)!,
      );
    }
    return this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuroraEffect &&
          runtimeType == other.runtimeType &&
          colors == other.colors &&
          stops == other.stops &&
          strokeWidth == other.strokeWidth &&
          duration == other.duration &&
          tileMode == other.tileMode &&
          tilt == other.tilt;

  @override
  int get hashCode =>
      colors.hashCode ^
      stops.hashCode ^
      tileMode.hashCode ^
      strokeWidth.hashCode ^
      duration.hashCode ^
      tilt.hashCode;
}

/// A gradient transform that rotates the gradient around the center of the bounds.
class _RotationTransform extends GradientTransform {
  const _RotationTransform({required this.angle, required this.tilt});

  final double angle;
  final double tilt;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final c = bounds.bottomLeft;
    return Matrix4.identity()
      ..translate(c.dx, c.dy)
      ..rotateZ(angle + tilt)
      ..translate(-c.dx, -c.dy);
  }
}
