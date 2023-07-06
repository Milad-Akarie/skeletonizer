import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';

/// Builds a [RenderSkeletonizer]
class SkeletonizerBase extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SkeletonizerBase({
    super.key,
    required super.child,
    required this.enabled,
    required this.animationValue,
    required this.brightness,
    required this.textDirection,
    required this.config,
  });

  /// If false the widget tree will painted
  /// as is
  final bool enabled;

  /// The value to animate painting effects
  final double animationValue;

  /// The used brightness
  final Brightness brightness;

  /// The scoped text direction
  /// used to resolve Directional geometries e.g [BorderRadiusDirectional]
  final TextDirection textDirection;

  /// The resolved skeletonizer theme data
  final SkeletonizerConfigData config;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      enabled: enabled,
      animationValue: animationValue,
      brightness: brightness,
      textDirection: textDirection,
      config: config,
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
      ..brightness = brightness
      ..config = config
      ..textDirection = textDirection;
  }
}
/// Builds a [RenderSkeletonizer]
class SliverSkeletonizerBase extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SliverSkeletonizerBase({
    super.key,
    required super.child,
    required this.enabled,
    required this.animationValue,
    required this.brightness,
    required this.textDirection,
    required this.config,
  });

  /// If false the widget tree will painted
  /// as is
  final bool enabled;

  /// The value to animate painting effects
  final double animationValue;

  /// The used brightness
  final Brightness brightness;

  /// The scoped text direction
  /// used to resolve Directional geometries e.g [BorderRadiusDirectional]
  final TextDirection textDirection;

  /// The resolved skeletonizer theme data
  final SkeletonizerConfigData config;

  @override
  RenderSliverSkeletonizer createRenderObject(BuildContext context) {
    return RenderSliverSkeletonizer(
      enabled: enabled,
      animationValue: animationValue,
      brightness: brightness,
      textDirection: textDirection,
      config: config,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      covariant RenderSliverSkeletonizer renderObject,
      ) {
    renderObject
      ..enabled = enabled
      ..animationValue = animationValue
      ..brightness = brightness
      ..config = config
      ..textDirection = textDirection;
  }
}

