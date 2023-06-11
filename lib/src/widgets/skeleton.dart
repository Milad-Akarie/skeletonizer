import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/src/widgets/skeletonizer.dart';

class Skeleton extends SingleChildRenderObjectWidget {
  final SkeletonAnnotation _annotation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSkeletonAnnotation(annotation: _annotation);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSkeletonAnnotation renderObject,
  ) {
    renderObject.annotation = _annotation;
  }

  const Skeleton._(this._annotation, {super.key, super.child});

  const Skeleton.ignore({
    super.key,
    required super.child,
    bool ignore = true,
  }) : _annotation = ignore ? const IgnoreDescendants() : _none;

  /// shades original element
  const Skeleton.shade({
    super.key,
    required super.child,
    bool shade = true,
  }) : _annotation = shade ? const ShadeOriginal() : _none;

  const factory Skeleton.replace({
    Key? key,
    required Widget child,
    bool visible,
    double? replacementWidth,
    double? replacementHeight,
    Widget replacement,
  }) = _SkeletonReplace;
}

class RenderSkeletonAnnotation extends RenderProxyBox {
  RenderSkeletonAnnotation({
    RenderBox? child,
    required this.annotation,
  });

  SkeletonAnnotation annotation;
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

class ReplaceOriginal extends SkeletonAnnotation {
  const ReplaceOriginal();
}

class _SkeletonReplace extends Skeleton {
  const _SkeletonReplace({
    super.key,
    required super.child,
    this.visible = false,
    this.replacementWidth,
    this.replacementHeight,
    this.replacement = const DecoratedBox(
      decoration: BoxDecoration(color: Colors.black),
    ),
  }) : super._(const ReplaceOriginal());

  final double? replacementWidth, replacementHeight;
  final bool visible;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final isVisible = visible || !Skeletonizer.of(context).loading;
    return isVisible
        ? child!
        : SizedBox(
            width: replacementWidth,
            height: replacementHeight,
            child: replacement,
          );
  }
}
