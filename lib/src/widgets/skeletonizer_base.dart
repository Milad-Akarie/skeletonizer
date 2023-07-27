import 'package:flutter/material.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';
import 'package:skeletonizer/src/widgets/skeletonizer.dart';

/// Builds a [RenderSkeletonizer]
class SkeletonizerBase extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SkeletonizerBase({
    super.key,
    required super.child,
    required this.data,
  });

  final SkeletonizerBuildData data;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      animationValue: data.animationValue,
      brightness: data.brightness,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSkeletonizer renderObject,
  ) {
    renderObject
      ..animationValue = data.animationValue
      ..brightness = data.brightness
      ..config = data.config
      ..ignorePointers = data.ignorePointers
      ..textDirection = data.textDirection;
  }
}

/// Builds a [RenderSkeletonizer]
class SliverSkeletonizerBase extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SliverSkeletonizerBase({
    super.key,
    required super.child,
    required this.data,
  });

  final SkeletonizerBuildData data;

  @override
  RenderSliverSkeletonizer createRenderObject(BuildContext context) {
    return RenderSliverSkeletonizer(
      animationValue: data.animationValue,
      brightness: data.brightness,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSliverSkeletonizer renderObject,
  ) {
    renderObject
      ..animationValue = data.animationValue
      ..brightness = data.brightness
      ..config = data.config
      ..ignorePointers = data.ignorePointers
      ..textDirection = data.textDirection;
  }
}
