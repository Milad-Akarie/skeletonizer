import 'package:flutter/material.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';
import 'package:skeletonizer/src/widgets/skeletonizer.dart';

/// Builds a [RenderSkeletonizer]
class SkeletonizerRenderObjectWidget extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SkeletonizerRenderObjectWidget({
    super.key,
    required super.child,
    required this.data,
  });

  /// The Skeletonizer build data
  final SkeletonizerBuildData data;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      animationValue: data.animationValue,
      brightness: data.brightness,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
      manual: data.zoned,
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
      ..manual = data.zoned
      ..textDirection = data.textDirection;
  }
}

/// Builds a [RenderSkeletonizer]
class SliverSkeletonizerRenderObjectWidget
    extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SliverSkeletonizerRenderObjectWidget({
    super.key,
    required super.child,
    required this.data,
  });

  /// The Skeletonizer build data
  final SkeletonizerBuildData data;

  @override
  RenderSliverSkeletonizer createRenderObject(BuildContext context) {
    return RenderSliverSkeletonizer(
      animationValue: data.animationValue,
      brightness: data.brightness,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
      manual: data.zoned,
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
      ..manual = data.zoned
      ..textDirection = data.textDirection;
  }
}
