import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';

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

/// Delegates a [SkeletonAnnotation] to the render tree
class RenderSkeletonAnnotation extends RenderProxyBox {
  /// Default constructor
  RenderSkeletonAnnotation({
    RenderBox? child,
    required SkeletonAnnotation annotation,
  }) : _annotation = annotation;

  SkeletonAnnotation _annotation;

  /// The annotation to be used
  set annotation(SkeletonAnnotation value) {
    if (value != _annotation) {
      _annotation = value;
      markNeedsLayout();
    }
  }

  /// The annotation to be used
  SkeletonAnnotation get annotation => _annotation;
}

/// A Widget that holds [SkeletonAnnotation]
/// to be consumed by [RenderSkeletonizer]
class Skeleton extends StatelessWidget {
  /// The child under this widget
  final Widget child;

  /// The annotation to be passed to the [_AnnotatedSkeleton]
  final SkeletonAnnotation annotation;

  const Skeleton._({
    super.key,
    required this.child,
    required this.annotation,
  });

  /// Do not skeletonize the descended widgets
  const Skeleton.ignore({
    super.key,
    required this.child,
    bool ignore = true,
  }) : annotation = ignore ? const IgnoreDescendants() : _none;

  /// Wrap original widget with shader mask
  const factory Skeleton.shade({
    Key? key,
    required Widget child,
    bool shade,
  }) = _SkeletonShade;

  /// Paint original element as is
  const Skeleton.keep({
    super.key,
    required this.child,
    bool keep = true,
  }) : annotation = keep ? const KeepOriginal() : _none;

  /// Unite all descendants into a one big rect
  const Skeleton.unite({
    super.key,
    required this.child,
    bool unite = true,
    UniteDescendents annotation = const UniteDescendents(),
  }) : annotation = unite ? annotation : _none;

  /// Used to annotate a [ColoredBox] or [Container] with a color not 'Decoration'
  ///
  /// ColoredBox and Container widgets with non-null color build a private
  /// _RenderColoredBox which is not accessible to the render tree.
  /// this annotation is used to pass the color to the render tree
  Skeleton.coloredBox({
    super.key,
    required this.child,
    Color? color,
  })  : assert(child is ColoredBox || child is Container),
        annotation = ColoredBoxAnnotation(color: _getColor(child, color));

  static Color _getColor(Widget child, Color? color) {
    if (color != null) {
      return color;
    } else if (child is ColoredBox) {
      return child.color;
    } else if (child is Container) {
      assert(child.color != null,
          'do not use this annotation with Container that has null color');
      return child.color!;
    }
    throw AssertionError(
      'color must not be null or child must be ColoredBox or Container with non-null color',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AnnotatedSkeleton(
      annotation: annotation,
      child: child,
    );
  }

  /// Replace the original element when [Skeletonizer.enabled] is true
  const factory Skeleton.replace({
    Key? key,
    required Widget child,
    bool replace,
    double? width,
    double? height,
    Widget replacement,
  }) = _SkeletonReplace;
}

/// An abstraction for annotation values
/// that change how skeletonized renderers look
abstract class SkeletonAnnotation {
  /// Default constructor
  const SkeletonAnnotation();
}

const _none = _NoAnnotation();

/// No annotation is used, this is equal to null
class _NoAnnotation extends SkeletonAnnotation {
  const _NoAnnotation();
}

/// Ignore all descendent skeletonized renderers
class IgnoreDescendants extends SkeletonAnnotation {
  /// Default constructor
  const IgnoreDescendants();
}

/// Shade the original the element and do not skeletonize it
class ShadeOriginal extends SkeletonAnnotation {
  /// Default constructor
  const ShadeOriginal();
}

/// paint the original element as is
class KeepOriginal extends SkeletonAnnotation {
  /// Default constructor
  const KeepOriginal();
}

/// Replace the original element when [Skeletonizer.enabled] is true
class ReplaceOriginal extends SkeletonAnnotation {
  /// Default constructor
  const ReplaceOriginal();
}

/// Unite all descendants into a one big rect
class UniteDescendents extends SkeletonAnnotation {
  /// Default constructor
  const UniteDescendents({this.borderRadius});

  /// The overall border radius of all united descendants
  ///
  /// if not provided a the border radius of hte biggest descent will be used
  final BorderRadiusGeometry? borderRadius;
}

/// A workaround for [ColoredBox] and [Container.color] cases
/// as they do not have a public [RenderObject] to be used
class ColoredBoxAnnotation extends SkeletonAnnotation {
  /// Default constructor
  const ColoredBoxAnnotation({required this.color});

  /// The color of the box
  final Color color;
}

/// Replace the original element when [Skeletonizer.enabled] is true
class _SkeletonReplace extends Skeleton {
  /// Default constructor
  const _SkeletonReplace({
    super.key,
    required super.child,
    this.replace = false,
    this.width,
    this.height,
    this.replacement = const DecoratedBox(
      decoration: BoxDecoration(color: Colors.black),
    ),
  }) : super._(annotation: const ReplaceOriginal());

  /// The width nad height of the replacement
  final double? width, height;

  /// Whether replacing is enabled
  final bool replace;

  /// The replacement widget
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final doReplace = replace || !Skeletonizer.of(context).enabled;
    return doReplace
        ? super.build(context)
        : SizedBox(
            width: width,
            height: height,
            child: replacement,
          );
  }
}

/// Shade the original the element and do not skeletonize it
class _SkeletonShade extends Skeleton {
  const _SkeletonShade({
    super.key,
    required super.child,
    this.shade = true,
  }) : super._(annotation: shade ? const ShadeOriginal() : _none);

  final bool shade;

  @override
  Widget build(BuildContext context) {
    final userShaderMask = shade && Skeletonizer.of(context).enabled;
    return userShaderMask
        ? SkeletonShaderMask(child: super.build(context))
        : super.build(context);
  }
}
