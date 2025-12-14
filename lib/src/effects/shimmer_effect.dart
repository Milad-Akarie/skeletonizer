import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'painting_effect.dart';

/// Builds a painting effect where a linear gradient
/// is used to create a shimmer-like effect
abstract class ShimmerEffect extends PaintingEffect {
  /// see [LinearGradient.colors]
  List<Color> get colors;

  /// see [LinearGradient.stops]
  List<double>? get stops;

  /// see [LinearGradient.begin]
  AlignmentGeometry get begin;

  /// see [LinearGradient.end]
  AlignmentGeometry get end;

  /// see [LinearGradient.tileMode]
  TileMode get tileMode;

  const ShimmerEffect._({super.lowerBound, super.upperBound, super.duration = const Duration(milliseconds: 2000)});

  /// Builds a [_ShimmerEffect] with default values
  const factory ShimmerEffect({
    Color baseColor,
    Color highlightColor,
    AlignmentGeometry begin,
    AlignmentGeometry end,
    Duration duration,
  }) = _ShimmerEffect;

  /// Builds a [RawShimmerEffect] with default values
  const factory ShimmerEffect.raw({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin,
    AlignmentGeometry end,
    TileMode tileMode,
    double lowerBound,
    double upperBound,
    Duration duration,
  }) = RawShimmerEffect;

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    final beginX = begin.resolve(textDirection).x;
    final endX = end.resolve(textDirection).x;
    final isVertical = beginX == 0 && endX == 0;
    return Paint()
      ..shader = LinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: _SlidingGradientTransform(offset: t, isVertical: isVertical),
      ).createShader(rect, textDirection: textDirection);
  }
}

class _ShimmerEffect extends ShimmerEffect {
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerEffect({
    this.baseColor = const Color(0xFFEBEBF4),
    this.highlightColor = const Color(0xFFF4F4F4),
    this.begin = const AlignmentDirectional(-1.0, -0.3),
    this.end = const AlignmentDirectional(1.0, 0.3),
    super.duration,
  }) : super._(lowerBound: -.5, upperBound: 1.5);

  @override
  List<Color> get colors => [baseColor, highlightColor, baseColor];

  @override
  final AlignmentGeometry begin;

  @override
  final AlignmentGeometry end;

  @override
  final List<double> stops = const [0.1, 0.3, 0.4];

  @override
  final TileMode tileMode = TileMode.clamp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ShimmerEffect &&
          runtimeType == other.runtimeType &&
          baseColor == other.baseColor &&
          highlightColor == other.highlightColor &&
          begin == other.begin &&
          duration == other.duration &&
          end == other.end &&
          tileMode == other.tileMode;

  @override
  int get hashCode =>
      baseColor.hashCode ^
      highlightColor.hashCode ^
      begin.hashCode ^
      end.hashCode ^
      tileMode.hashCode ^
      duration.hashCode;

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is _ShimmerEffect) {
      return _ShimmerEffect(
        baseColor: Color.lerp(baseColor, other.baseColor, t)!,
        highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
        begin: AlignmentGeometry.lerp(begin, other.begin, t)!,
        end: AlignmentGeometry.lerp(end, other.end, t)!,
        duration: duration,
      );
    }
    return this;
  }
}

/// A customizable shimmer effect where you can provide
/// your own colors, stops, and other gradient properties
class RawShimmerEffect extends ShimmerEffect {
  @override
  final List<Color> colors;

  @override
  final List<double>? stops;

  @override
  final AlignmentGeometry begin;

  @override
  final AlignmentGeometry end;
  @override
  final TileMode tileMode;

  /// Builds a [RawShimmerEffect] with the provided properties
  const RawShimmerEffect({
    required this.colors,
    this.stops,
    this.begin = const AlignmentDirectional(-1.0, -0.3),
    this.end = const AlignmentDirectional(1.0, 0.3),
    this.tileMode = TileMode.clamp,
    super.lowerBound = -0.5,
    super.upperBound = 1.5,
    super.duration,
  }) : super._();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawShimmerEffect &&
          runtimeType == other.runtimeType &&
          listEquals(colors, other.colors) &&
          listEquals(stops, other.stops) &&
          begin == other.begin &&
          end == other.end &&
          duration == other.duration &&
          tileMode == other.tileMode;

  @override
  int get hashCode =>
      Object.hashAll(colors) ^
      Object.hashAll(colors) ^
      begin.hashCode ^
      end.hashCode ^
      tileMode.hashCode ^
      duration.hashCode;

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is RawShimmerEffect) {
      return RawShimmerEffect(
        colors: List.generate(colors.length, (index) => Color.lerp(colors[index], other.colors[index], t)!),
        stops: stops,
        begin: AlignmentGeometry.lerp(begin, other.begin, t)!,
        end: AlignmentGeometry.lerp(end, other.end, t)!,
        tileMode: tileMode,
        duration: duration,
      );
    }
    return this;
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.offset, required this.isVertical});

  final bool isVertical;
  final double offset;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    if (isVertical) {
      return Matrix4.translationValues(0.0, bounds.height * offset, 0.0);
    }
    final resolvedOffset = textDirection == TextDirection.rtl ? -offset : offset;
    return Matrix4.translationValues(bounds.width * resolvedOffset, 0.0, 0.0);
  }
}
