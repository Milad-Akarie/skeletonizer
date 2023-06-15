import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';

class _AnnotatedSkeleton extends SingleChildRenderObjectWidget {
  final SkeletonAnnotation annotation;

  const _AnnotatedSkeleton({super.child, required this.annotation});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSkeletonAnnotation(annotation: annotation);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSkeletonAnnotation renderObject,
  ) {
    renderObject.annotation = annotation;
  }
}

class RenderSkeletonAnnotation extends RenderProxyBox {
  RenderSkeletonAnnotation({
    RenderBox? child,
    required this.annotation,
  });

  SkeletonAnnotation annotation;
}

class Skeleton extends StatelessWidget {
  final Widget child;
  final SkeletonAnnotation annotation;

  const Skeleton._({
    super.key,
    required this.child,
    required this.annotation,
  });

  const Skeleton.ignore({
    super.key,
    required this.child,
    bool ignore = true,
  }) : annotation = ignore ? const IgnoreDescendants() : _none;

  /// shades original element
  const factory Skeleton.shade({
    Key? key,
    required Widget child,
    bool shade,
  }) = SkeletonShade;

  /// paints original element
  const Skeleton.keep({
    super.key,
    required this.child,
    bool keep = true,
  }) : annotation = keep ? const KeepOriginal() : _none;

  const Skeleton.union({
    super.key,
    required this.child,
    bool union = true,
    UnionDescendents annotation = const UnionDescendents(),
  }) : annotation = union ? annotation : _none;

  @override
  Widget build(BuildContext context) {
    return _AnnotatedSkeleton(
      annotation: annotation,
      child: child,
    );
  }

  const factory Skeleton.replace({
    Key? key,
    required Widget child,
    bool visible,
    double? replacementWidth,
    double? replacementHeight,
    Widget replacement,
  }) = SkeletonReplace;
}

abstract class SkeletonAnnotation {
  const SkeletonAnnotation();
}

const _none = _NoAnnotation();

class _NoAnnotation extends SkeletonAnnotation {
  const _NoAnnotation();
}

class IgnoreDescendants extends SkeletonAnnotation {
  const IgnoreDescendants();
}

class ShadeOriginal extends SkeletonAnnotation {
  const ShadeOriginal();
}

class KeepOriginal extends SkeletonAnnotation {
  const KeepOriginal();
}

class ReplaceOriginal extends SkeletonAnnotation {
  const ReplaceOriginal();
}

class UnionDescendents extends SkeletonAnnotation {
  const UnionDescendents({this.borderRadius});

  final BorderRadiusGeometry? borderRadius;
}

class SkeletonReplace extends Skeleton {
  const SkeletonReplace({
    super.key,
    required super.child,
    this.visible = false,
    this.replacementWidth,
    this.replacementHeight,
    this.replacement = const DecoratedBox(
      decoration: BoxDecoration(color: Colors.black),
    ),
  }) : super._(annotation: const ReplaceOriginal());

  final double? replacementWidth, replacementHeight;
  final bool visible;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final isVisible = visible || !Skeletonizer.of(context).enabled;
    return isVisible
        ? super.build(context)
        : SizedBox(
            width: replacementWidth,
            height: replacementHeight,
            child: replacement,
          );
  }
}

class SkeletonShade extends Skeleton {
  const SkeletonShade({
    super.key,
    required super.child,
    this.shade = true,
  }) : super._(annotation: shade ? const ShadeOriginal() : _none);

  final bool shade;

  @override
  Widget build(BuildContext context) {
    final useMask = shade && Skeletonizer.of(context).enabled;
    return useMask ? SkeletonShaderMask(child: super.build(context)) : super.build(context);
  }
}
