import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';

class SoldColorEffect extends PaintingEffect {
  final Color color;

 const SoldColorEffect({
    this.color = const Color(0xFFF6F6F6),
    super.lowerBound,
    super.upperBound,
  }) : super(duration: Duration.zero);

  @override
  Paint createPaint(double t, Rect rect) {
    // if possible find a better way to create one-color shaders!
    return Paint()
      ..shader = LinearGradient(
        colors: [color, color],
      ).createShader(rect);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SoldColorEffect && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
