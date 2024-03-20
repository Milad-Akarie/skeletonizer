import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';
import 'package:skeletonizer/src/painting/uniting_painting_context.dart';

/// A signature for a function that paints with a [SkeletonizerPaintingContext].
typedef SkeletonizerPainter = void Function(
  SkeletonizerPaintingContext context,
  Rect paintBounds,
  Painter paint,
  TextDirection? textDirection,
);

//// A signature for a function that paints with a [PaintingContext].
typedef Painter = void Function(PaintingContext context, Offset offset);

/// An interface for a skeleton annotation widget
/// skeleton annotation widgets are used to configure or customize how
/// the skeleton effect is applied to the child widget
abstract class Skeleton extends Widget {
  /// Default constructor
  const Skeleton({super.key});

  /// Whether the annotation is enabled
  bool get enabled;

  /// Creates a widget that ignores the child when [Skeletonizer.enabled] is true
  const factory Skeleton.ignore({
    Key? key,
    required Widget child,
    bool ignore,
  }) = _IgnoreSkeleton;

  /// Creates a widget that unites the child with its descendants when [Skeletonizer.enabled] is true
  const factory Skeleton.unite({
    Key? key,
    required Widget child,
    bool unite,
    BorderRadiusGeometry? borderRadius,
  }) = _UnitingSkeleton;

  /// Creates a widget that keeps paints the original child  as is when [Skeletonizer.enabled] is true
  const factory Skeleton.keep({
    Key? key,
    required Widget child,
    bool keep,
  }) = _KeepSkeleton;

  /// Creates a widget that shades the child when [Skeletonizer.enabled] is true
  /// This works as a [ShaderMask] but with a [SkeletonizerPaintingContext]
  const factory Skeleton.shade({
    Key? key,
    required Widget child,
    bool shade,
  }) = _SkeletonShaderMask;

  /// Creates a widget that replaces the child when [Skeletonizer.enabled] is true
  const factory Skeleton.replace({
    Key? key,
    required Widget child,
    bool replace,
    double? width,
    double? height,
    Widget replacement,
  }) = _SkeletonReplace;

  /// Creates a widget that forces the child to have a painting effect
  /// e.g a Shimmer effect when [Skeletonizer.enabled] is true
  const factory Skeleton.leaf({
    Key? key,
    required Widget child,
    bool enabled,
  }) = _LeafSkeleton;

  /// Creates a widget that ignores pointer events when [Skeletonizer.enabled] is true
  const factory Skeleton.ignorePointer({
    Key? key,
    required Widget child,
    bool ignore,
  }) = _SkeletonIgnorePointer;
}

abstract class _BasicSkeleton extends SingleChildRenderObjectWidget
    implements Skeleton {
  const _BasicSkeleton({
    super.key,
    required Widget super.child,
    bool enabled = true,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBasicSkeleton(
      textDirection: Directionality.of(context),
      painter: paint,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderBasicSkeleton renderObject,
  ) {
    renderObject
      ..textDirection = Directionality.of(context)
      ..enabled = enabled;
  }

  void paint(
    SkeletonizerPaintingContext context,
    Rect paintBounds,
    Painter paint,
    TextDirection? textDirection,
  );
}

class _IgnoreSkeleton extends SingleChildRenderObjectWidget
    implements Skeleton {
  const _IgnoreSkeleton({
    super.key,
    required Widget super.child,
    bool ignore = true,
  }) : enabled = ignore;

  @override
  final bool enabled;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIgnoredSkeleton(
        enabled: enabled && isSkeletonizerEnabled(context));
  }

  bool isSkeletonizerEnabled(BuildContext context) {
    final skeletonizer = Skeletonizer.maybeOf(context);
    return skeletonizer?.enabled == true;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderIgnoredSkeleton renderObject,
  ) {
    renderObject.enabled = enabled && isSkeletonizerEnabled(context);
  }
}

class _KeepSkeleton extends _BasicSkeleton {
  const _KeepSkeleton({
    super.key,
    required super.child,
    bool keep = true,
  })  : enabled = keep,
        super(enabled: keep);

  @override
  final bool enabled;

  @override
  void paint(SkeletonizerPaintingContext context, rect, paint, _) {
    context.createDefaultContext(rect, paint);
  }
}

class _UnitingSkeleton extends _BasicSkeleton {
  final BorderRadiusGeometry? borderRadius;

  @override
  final bool enabled;

  const _UnitingSkeleton({
    super.key,
    required super.child,
    this.borderRadius,
    bool unite = true,
  })  : enabled = unite,
        super(enabled: unite);

  @override
  void paint(SkeletonizerPaintingContext context, Rect paintBounds,
      Painter paint, textDirection) {
    final unitingContext = UnitingPaintingContext(context.layer, paintBounds);
    paint(unitingContext, Offset.zero);
    final canvas = unitingContext.canvas;
    final unitedRect = canvas.unitedRect.shift(paintBounds.topLeft);
    final brRadius =
        borderRadius?.resolve(textDirection) ?? canvas.borderRadius;
    if (brRadius != null) {
      context.canvas
          .drawRRect(brRadius.toRRect(unitedRect), context.shaderPaint);
    } else {
      context.canvas.drawRect(unitedRect, context.shaderPaint);
    }
  }
}

class _RenderBasicSkeleton extends RenderProxyBox {
  /// Default constructor
  _RenderBasicSkeleton({
    required TextDirection textDirection,
    required SkeletonizerPainter painter,
    required bool enabled,
  })  : _textDirection = textDirection,
        _painter = painter,
        _enabled = enabled;

  bool _enabled = true;

  set enabled(bool value) {
    if (value != _enabled) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  SkeletonizerPainter? _painter;

  set painter(SkeletonizerPainter? value) {
    if (value != _painter) {
      _painter = value;
      markNeedsPaint();
    }
  }

  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (value != _textDirection) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_enabled && context is SkeletonizerPaintingContext) {
      assert(_painter != null, 'painter must not be null');
      return _painter!(context, offset & size, super.paint, _textDirection);
    }
    super.paint(context, offset);
  }
}

/// A Render object that paints nothing when skeletonizer is enabled
class RenderIgnoredSkeleton extends RenderProxyBox {
  /// Default constructor
  RenderIgnoredSkeleton({
    RenderBox? child,
    required bool enabled,
  }) : _enabled = enabled;

  bool _enabled = true;

  /// Whether the skeletonizer is enabled
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (value != _enabled) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_enabled) {
      super.paint(context, offset);
    }
  }
}

class _LeafSkeleton extends _BasicSkeleton {
  const _LeafSkeleton({
    super.key,
    required super.child,
    this.enabled = true,
  });

  @override
  final bool enabled;

  @override
  void paint(
      SkeletonizerPaintingContext context, Rect paintBounds, Painter paint, _) {
    context.createLeafContext(paintBounds, (leafContext, offset) {
      paint(leafContext, paintBounds.topLeft);
    });
  }
}

/// Builds a [_RenderSkeletonShaderMask]
class _SkeletonShaderMask extends SingleChildRenderObjectWidget
    implements Skeleton {
  /// Creates a widget that applies a mask generated by a [Shader] to its child.
  ///
  /// The [shader] and [blendMode] arguments must not be null.
  const _SkeletonShaderMask({
    super.key,
    required super.child,
    bool shade = true,
  }) : enabled = shade;

  @override
  final bool enabled;

  @override
  _RenderSkeletonShaderMask createRenderObject(BuildContext context) {
    return _RenderSkeletonShaderMask(shade: enabled);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSkeletonShaderMask renderObject,
  ) {
    renderObject.shade = enabled;
  }
}

/// This is typically a [RenderShaderMask] with few adjustments
///
/// it takes shader info from context instead of a widget
class _RenderSkeletonShaderMask extends RenderProxyBox {
  /// Creates a render object that applies a mask generated by a [Shader] to its child.

  _RenderSkeletonShaderMask({
    RenderBox? child,
    required bool shade,
  })  : _shade = shade,
        super(child);

  bool _shade = true;

  set shade(bool value) {
    if (value != _shade) {
      _shade = value;
      markNeedsPaint();
    }
  }

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      if (_shade && context is SkeletonizerPaintingContext) {
        assert(needsCompositing);
        layer ??= ShaderMaskLayer();
        layer!
          ..shader = context.shaderPaint.shader
          ..maskRect = context.estimatedBounds
          ..blendMode = BlendMode.srcATop;
        context.createDefaultContext(offset & size, (childContext, offset) {
          childContext.pushLayer(layer!, super.paint, offset);
          assert(() {
            layer!.debugCreator = debugCreator;
            return true;
          }());
        });
      } else {
        super.paint(context, offset);
      }
    } else {
      layer = null;
    }
  }
}

/// Replace the original element when [Skeletonizer.enabled] is true
class _SkeletonReplace extends StatelessWidget implements Skeleton {
  /// Default constructor
  const _SkeletonReplace({
    super.key,
    required this.child,
    bool replace = true,
    this.width,
    this.height,
    this.replacement = const ColoredBox(color: Colors.black),
  }) : enabled = replace;

  final Widget child;

  /// The width nad height of the replacement
  final double? width, height;

  @override
  final bool enabled;

  /// The replacement widget
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final doReplace = enabled && Skeletonizer.maybeOf(context)?.enabled == true;
    return SizedBox(
      width: width,
      height: height,
      child: doReplace ? replacement : child,
    );
  }
}

/// Ignores pointer events when [Skeletonizer.enabled] is true
class _SkeletonIgnorePointer extends StatelessWidget implements Skeleton {
  /// Default constructor
  const _SkeletonIgnorePointer({
    super.key,
    required this.child,
    bool ignore = true,
  }) : enabled = ignore;

  final Widget child;

  @override
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ignoring = enabled && Skeletonizer.maybeOf(context)?.enabled == true;
    return IgnorePointer(
      ignoring: ignoring,
      child: child,
    );
  }
}
