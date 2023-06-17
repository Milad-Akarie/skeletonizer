import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';

class SkeletonizerBase extends SingleChildRenderObjectWidget {
  const SkeletonizerBase({
    super.key,
    required super.child,
    required this.enabled,
    required this.effect,
    required this.animationValue,
    required this.brightness,
    required this.textDirection,
    required this.themeData,
  });

  final PaintingEffect effect;
  final bool enabled;
  final double animationValue;
  final Brightness brightness;
  final TextDirection textDirection;
  final SkeletonizerThemeData themeData;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      enabled: enabled,
      paintingEffect: effect,
      animationValue: animationValue,
      brightness: brightness,
      textDirection: textDirection,
      themeData: themeData,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSkeletonizer renderObject,
  ) {
    renderObject
      ..enabled = enabled
      ..animationValue = animationValue
      ..paintingEffect = effect
      ..brightness = brightness
      ..themeData = themeData
      ..textDirection = textDirection;
  }
}
