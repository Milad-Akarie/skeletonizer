import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

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

  const Skeleton.ignore({
    super.key,
    required super.child,
    bool ignore = true,
  }) : _annotation = ignore ? const IgnoreDescendants() : _none;


  const Skeleton.shadeOriginal({
    super.key,
    required super.child,
    bool shade = true,
  }) : _annotation = shade ? const ShadeOriginal() : _none;
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
