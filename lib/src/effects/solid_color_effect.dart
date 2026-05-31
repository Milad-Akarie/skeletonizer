import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';

@Deprecated('Use SolidColorEffect instead')
/// backward compatibility typedef for SolidColorEffect
typedef SoldColorEffect = SolidColorEffect;

/// Creates a none-animated painting effect
class SolidColorEffect extends PaintingEffect {
  /// The color to paint or shade renderers
  final Color color;

  /// Default constructor
  const SolidColorEffect({
    this.color = const Color(0xFFF6F6F6),
    super.lowerBound,
    super.upperBound,
  }) : super(duration: Duration.zero);

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    // We're creating a shader here because [ShadedElement] component
    // will use a shader mask to shade original elements
    //
    // todo: find a better way to create a one-color shader!
    return Paint()..shader = LinearGradient(colors: [color, color]).createShader(rect);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SolidColorEffect && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is SolidColorEffect) {
      return SolidColorEffect(color: Color.lerp(color, other.color, t)!);
    }
    return this;
  }
}
