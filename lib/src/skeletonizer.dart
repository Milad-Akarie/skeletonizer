import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:collection/collection.dart';
import 'package:skeleton_builder/src/helper_utils.dart';

class Skeletonizer extends StatefulWidget {
  const Skeletonizer({
    super.key,
    required this.child,
    required this.loading,
  });

  final Widget child;
  final bool loading;

  @override
  State<Skeletonizer> createState() => _SkeletonizerState();
}

class _SkeletonizerState extends State<Skeletonizer> with SingleTickerProviderStateMixin<Skeletonizer> {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this);
    _startAnimation();
    _shimmerController.addListener(_onShimmerChange);
  }

  void _startAnimation() {
    _shimmerController.repeat(
      min: -0.5,
      max: 1.5,
      period: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(covariant Skeletonizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.loading != widget.loading) {
      if (!widget.loading) {
        _shimmerController.stop();
      } else if (!_shimmerController.isAnimating) {
        _startAnimation();
      }
    }
  }

  @override
  void dispose() {
    _shimmerController.removeListener(_onShimmerChange);
    _shimmerController.dispose();
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.loading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Skeletonizer(
      loading: widget.loading,
      shimmer: LinearGradient(
        colors: const [
          Color(0xFFEBEBF4),
          Color(0xFFF4F4F4),
          Color(0xFFEBEBF4),
        ],
        stops: const [0.1, 0.3, 0.4],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
        transform: _SlidingGradientTransform(slidePercent: _shimmerController.value),
      ),
      child: widget.child,
    );
  }
}

class _Skeletonizer extends SingleChildRenderObjectWidget {
  const _Skeletonizer({
    super.key,
    required super.child,
    required this.loading,
    required this.shimmer,
  });

  final LinearGradient shimmer;
  final bool loading;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      loading,
      shimmer: shimmer,
      textDirection: Directionality.of(context),
      theme: Theme.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSkeletonizer renderObject) {
    renderObject
      ..loading = loading
      ..shimmer = shimmer;
    super.updateRenderObject(context, renderObject);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   renderObject._skeletonize();
    // });
  }
}

class RenderSkeletonizer extends RenderProxyBox {
  RenderSkeletonizer(
    this.loading, {
    required this.textDirection,
    required this.theme,
    RenderBox? child,
    required LinearGradient shimmer,
  })  : _shimmer = shimmer,
        super(child);

  final TextDirection textDirection;
  final ThemeData theme;
  bool loading;

  double _skeletonizedAtWidth = 0;

  // @override
  // void performLayout() {
  //   super.performLayout();
  //   if (_skeletonizedAtWidth != constraints.maxWidth) {
  //     _skeletonizedAtWidth = constraints.maxWidth;
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // _skeletonize();
  //
  //     });
  //   }
  // }

  void _skeletonize() {
    _bones.clear();
    skeletonize(this, _bones, Offset.zero);
    // onSkeletonReady(Stack(children: _bones));

    // e_bones.map((e) => e));
    // print(_clippers.map((e) => e.paintBounds));
  }

  final _bones = <PaintableElement>[];

  void skeletonize(RenderObject node, List<PaintableElement> bones, Offset offset) {
    node.visitChildren((child) {
      if (child is RenderSkeletonAnnotation) {
        if (child.annotation is IgnoreDescendants) {
          return;
        }
      }
      var childOffset = offset;
      final transform = Matrix4.identity();
      if (node is! RenderTransformX) {
        node.applyPaintTransform(child, transform);
        childOffset = MatrixUtils.transformPoint(transform, offset);
      }

      // Widget? widget;
      if (child is RenderBox) {
        // if (child is RenderParagraph) {
        //   widget = _buildTextBone(child);
        // } else if (child is RenderDecoratedBox) {
        //   widget = _buildDecoratedBox(child);
        // }

        // final offset = ;

        if (child is RenderClipRRect) {
          final borderRadius = child.borderRadius.resolve(textDirection);
          final rect = offset & child.size;
          final rRect = RRect.fromRectAndCorners(
            rect,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          );
          final descendents = <PaintableElement>[];
          skeletonize(child, descendents, childOffset);
          // child.applyPaintTransform(child, transform)
          bones.add(
            RRectClipElement(
              clip: rRect,
              descendents: descendents,
            ),
          );
          return;
        } else if (child is RenderTransformX) {
          final matrix = debugValueOfType<Matrix4>(child)!.clone();
          final descendents = <PaintableElement>[];
          skeletonize(child, descendents, childOffset);
          bones.add(
            TransformElement(
              matrix4: matrix,
              size: child.size,
              textDirection: textDirection,
              origin: child.origin,
              alignment: child.alignment,
              descendents: descendents,
              globalOffset: offset,
            ),
          );
          return;
        } else if (child is RenderParagraph) {
          bones.add(_buildTextBone(child, childOffset));
        } else if (child is RenderPhysicalShape) {
          return bones.add(_buildPhysicalShape(child, childOffset));
        }
      }
      skeletonize(child, bones, childOffset);
    });
  }

  TextBoneElement _buildTextBone(RenderParagraph node, Offset offset) {
    final painter = TextPainter(
      text: node.text,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      textScaleFactor: node.textScaleFactor,
    )..layout(maxWidth: node.constraints.maxWidth);
    final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;
    final lineCount = painter.size.height ~/ painter.preferredLineHeight;

    return TextBoneElement(
      painter: painter,
      fontSize: fontSize,
      lineCount: lineCount,
      offset: offset,
      renderObject: node,
    );
    // return TextBone(
    //   lineHeight: painter.preferredLineHeight,
    //   textAlign: node.textAlign,
    //   textDirection: node.textDirection,
    //   fontSize: fontSize,
    //   lineLength: lineCount * painter.width,
    //   maxLines: node.maxLines,
    //   borderRadius: 8,
    //   width: painter.width,
    // );
  }

  Widget _buildDecoratedBox(RenderDecoratedBox node) {
    final boxDecoration = node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

    final ShapeBorder shape;
    final borderSide = (boxDecoration.border?.top ?? BorderSide.none).copyWith(
      color: Colors.green,
    );

    if (boxDecoration.shape == BoxShape.circle) {
      shape = CircleBorder(side: borderSide);
    } else {
      shape = RoundedRectangleBorder(
        borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
        side: borderSide,
      );
    }
    final canBeContainer = false;

    return BoxBone(
      borderRadius: boxDecoration.borderRadius,
      width: node.size.width,
      height: node.size.height,
      shape: boxDecoration.shape,
    );

    //  SkeletonContainer(
    //   shape: shape,
    //   width: node.assignableWidth,
    //   height: node.assignableHeight,
    //   // child: res.widget,
    // );
    //
  }

  Map<String, Object?> debugPropertiesMap(Diagnosticable node) {
    return Map.fromEntries(
      debugProperties(node).where((e) => e.name != null).map(
            (e) => MapEntry(e.name!, e.value),
          ),
    );
  }

  List<DiagnosticsNode> debugProperties(Diagnosticable node) {
    final builder = DiagnosticPropertiesBuilder();
    node.debugFillProperties(builder);
    return builder.properties;
  }

  T? debugValueOfType<T>(RenderObject node) {
    return debugProperties(node).firstWhereOrNull((e) => e.value is T)?.value as T?;
  }

  LinearGradient _shimmer;

  set shimmer(LinearGradient value) {
    _shimmer = value;
    markNeedsPaint();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return !loading && super.hitTest(result, position: position);
  }

  double _lastSkeletonizedWidth = 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!loading) {
      return super.paint(context, offset);
    }
    if (_bones.isEmpty || _lastSkeletonizedWidth != size.width) {
      _lastSkeletonizedWidth = size.width;
      final watch = Stopwatch()..start();
      _skeletonize();
      print('Skeletonized in : ${watch.elapsedMilliseconds}');
    }

    // super.paint(context, offset);

    final canvas = context.canvas;
    final shader = _shimmer.createShader(offset & size, textDirection: textDirection);
    final shaderPaint = Paint()..shader = shader;

    for (final bone in _bones) {
      bone.paint(context, offset, shaderPaint);
    }
    // print('painted in:  ${watch.elapsedMilliseconds}');
  }

  Widget? rebuildWidget(RenderObject? node) {
    if (node == null) return null;

    Widget? widget;

    // print(node.runtimeType);
    if (node is RenderBox && node.isInside<Divider>()) {
      final divider = node.findAncestorWidget<Divider>()!;
      final height = divider.thickness ?? theme.dividerTheme.thickness ?? 1;
      final padding = EdgeInsetsDirectional.only(
        start: divider.indent ?? 0,
        end: divider.endIndent ?? 0,
      );
      widget = SizedBox(
        height: node.size.height,
        child: BoxBone(
          alignment: Alignment.center,
          height: height,
          width: double.infinity,
          padding: padding,
        ),
      );
    } else if (node.isInside<IconButton>()) {
      final renderConstrains = node.findFirstChildOf<RenderConstrainedBox>();
      final size = renderConstrains?.size ?? const Size(48, 48);
      final icon = node.findFirstChildOf<RenderParagraph>();

      widget = SizedBox(
        width: size.width,
        height: size.height,
        child: BoxBone(
          alignment: Alignment.center,
          width: icon?.size.width ?? 24,
          height: icon?.size.height ?? 24,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (node is RenderRotatedBox) {
      widget = RotatedBox(
        quarterTurns: node.quarterTurns,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderTransform) {
      final matrix4 = debugValueOfType<Matrix4>(node);
      final childWidget = rebuildWidget(node.child);

      if (childWidget != null) {
        widget = Transform(
          transform: matrix4 ?? Matrix4.identity(),
          alignment: node.alignment,
          origin: node.origin,
          child: childWidget,
        );
      }
    } else if (node is RenderClipPath) {
      widget = ClipPath(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipRect) {
      widget = ClipRect(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipOval) {
      widget = ClipOval(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipRRect) {
      widget = ClipRRect(
        borderRadius: node.borderRadius,
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderPhysicalModel) {
      widget = SkeletonContainer(
        elevation: node.elevation,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderPhysicalShape) {
      final isChip = node.isInside<RawChip>();
      final isButton = node.findParentWithName('_RenderInputPadding') != null || isChip;
      final shape = (node.clipper as ShapeBorderClipper).shape;
      BoxShape? boxShape;
      BorderRadiusGeometry? borderRadius;
      if (shape is RoundedRectangleBorder) {
        borderRadius = shape.borderRadius;
      } else if (shape is StadiumBorder) {
        borderRadius = BorderRadius.circular(node.size.height);
      } else if (shape is CircleBorder) {
        boxShape = BoxShape.circle;
      }

      if (true) {
        final width = isButton ? node.size.width : double.infinity;
        widget = BoxBone(
          width: width,
          height: node.size.height,
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius: borderRadius,
          // alignment: isChip ? Alignment.center : null,
        );
      } else {
        widget = SkeletonContainer(
          clipBehavior: node.clipBehavior,
          elevation: node.elevation,
          shape: shape,
          child: rebuildWidget(node.child),
        );
      }
    } else if (node is RenderImage) {
      widget = const BoxBone();
    } else if (node is RenderParagraph) {
      final painter = TextPainter(
        text: node.text,
        textAlign: node.textAlign,
        textDirection: node.textDirection,
        textScaleFactor: node.textScaleFactor,
      )..layout(maxWidth: node.constraints.maxWidth);
      final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;
      final lineCount = (painter.size.height / painter.preferredLineHeight);

      widget = TextBone(
        lineHeight: painter.preferredLineHeight,
        textAlign: node.textAlign,
        textDirection: node.textDirection,
        fontSize: fontSize,
        lineLength: lineCount * painter.width,
        maxLines: node.maxLines,
        borderRadius: 8,
        width: painter.width,
      );
    } else if (node is RenderDecoratedBox) {
      final boxDecoration =
          node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

      final ShapeBorder shape;
      final borderSide = (boxDecoration.border?.top ?? BorderSide.none).copyWith(
        color: Colors.green,
      );

      if (boxDecoration.shape == BoxShape.circle) {
        shape = CircleBorder(side: borderSide);
      } else {
        shape = RoundedRectangleBorder(
          borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
          side: borderSide,
        );
      }
      final res = rebuildWidget(node.child);
      const canBeContainer = false;
      if (!canBeContainer) {
        widget = BoxBone(
          borderRadius: boxDecoration.borderRadius,
          width: node.size.width,
          height: node.size.height,
          shape: boxDecoration.shape,
        );
      } else {
        widget = SkeletonContainer(
          shape: shape,
          width: node.assignableWidth,
          height: node.assignableHeight,
          child: res,
        );
      }
    } else if (node is RenderObjectWithChildMixin) {
      widget = rebuildWidget(node.child);
    } else if (node is ContainerRenderObjectMixin) {
      widget = rebuildWidget(node.firstChild);
    } else if (node is CustomMultiChildLayout) {
      print('Here');
    } else if (node.typeName == '_RenderDecoration') {
      widget = const BoxBone();
    } else {
      print(node.runtimeType);
    }

    return widget;
  }

  ContainerElement _buildPhysicalShape(RenderPhysicalShape node, Offset offset) {
    final isChip = node.isInside<RawChip>();
    final isButton = node.findParentWithName('_RenderInputPadding') != null || isChip;
    final shape = (node.clipper as ShapeBorderClipper).shape;
    BorderRadiusGeometry? borderRadius;
    if (shape is RoundedRectangleBorder) {
      borderRadius = shape.borderRadius;
    } else if (shape is StadiumBorder) {
      borderRadius = BorderRadius.circular(node.size.height);
    } else if (shape is CircleBorder) {}

    final descendents = <PaintableElement>[];
    if (!isButton) {
      skeletonize(node, descendents, offset);
    }
    return ContainerElement(
      rect: offset & node.size,
      elevation: node.elevation,
      descendents: descendents,
      borderRadius: borderRadius?.resolve(textDirection),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LinearGradient>('_shimmer', _shimmer));
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

abstract class PaintableElement {
  void paint(PaintingContext context, Offset offset, Paint shaderPaint);

  Matrix4? _transformer;

  set transformer(Matrix4 value) {
    _transformer = value;
  }
}

class BoneElement extends PaintableElement {
  final Rect rect;
  final BorderRadius? borderRadius;

  BoneElement({
    required this.rect,
    this.borderRadius,
  });

  RRect addBorderRadius(Rect rect, BorderRadius borderRadius) {
    return RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final shiftedRect = rect.shift(offset);
    if (borderRadius != null) {
      final rRect = addBorderRadius(shiftedRect, borderRadius!);
      context.canvas.drawRRect(rRect, shaderPaint);
    } else {
      context.canvas.drawRect(shiftedRect, shaderPaint);
    }
  }
}

class ContainerElement extends BoneElement {
  final List<PaintableElement> descendents;
  final double? elevation;

  ContainerElement({
    this.descendents = const [],
    this.elevation,
    required super.rect,
    super.borderRadius,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final shiftedRect = rect.shift(offset);
    final surfacePaint = Paint()..color = Colors.white;
    final drawShadow = descendents.isNotEmpty && elevation != null && elevation! > 0;
    final treatAsBone = descendents.isEmpty;
    if (borderRadius != null) {
      final rRect = addBorderRadius(shiftedRect, borderRadius!);
      if (drawShadow) {
        context.canvas.drawShadow(Path()..addRRect(rRect), Colors.black, elevation!, false);
      }
      context.canvas.drawRRect(rRect, treatAsBone ? shaderPaint : surfacePaint);
    } else {
      if (drawShadow) {
        context.canvas.drawShadow(Path()..addRect(shiftedRect), Colors.black, elevation!, false);
      }
      context.canvas.drawRect(shiftedRect, treatAsBone ? shaderPaint : surfacePaint);
    }
    for (final descendent in descendents) {
      descendent.paint(context, offset, shaderPaint);
    }
  }
}

class TextBoneElement extends PaintableElement {
  final TextPainter painter;
  final int lineCount;
  final double fontSize;
  final Offset offset;
  final RenderParagraph renderObject;

  TextBoneElement({
    required this.painter,
    required this.offset,
    required this.lineCount,
    required this.fontSize,
    required this.renderObject,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final drawingOffset = this.offset + offset;
    // final layer = ShaderMaskLayer()
    //   ..blendMode = BlendMode.srcATop
    //   ..shader = const LinearGradient(colors: [Colors.red, Colors.blue]).createShader(drawingOffset & painter.size)
    //   ..maskRect = drawingOffset & painter.size;
    // context.pushLayer(layer, (context, offset) {
    //   renderObject.paint(context, drawingOffset);
    // }, offset);
    //
    // return;
    final rect = Rect.fromLTWH(
      drawingOffset.dx,
      drawingOffset.dy,
      painter.width,
      fontSize,
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      shaderPaint,
    );
  }
}

class RRectClipElement extends PaintableElement {
  final List<PaintableElement> descendents;
  final RRect clip;

  RRectClipElement({required this.clip, required this.descendents});

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRRect(false, offset, clip.middleRect, clip, (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

class TransformElement extends PaintableElement {
  final List<PaintableElement> descendents;
  final Matrix4 matrix4;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final TextDirection textDirection;
  final Size size;
  final Offset globalOffset;

  TransformElement({
    required this.matrix4,
    required this.descendents,
    required this.textDirection,
    required this.size,
    required this.globalOffset,
    this.origin,
    this.alignment,
  });

  Matrix4 get _effectiveTransform {
    final Alignment? resolvedAlignment = alignment?.resolve(textDirection);
    if (origin == null && resolvedAlignment == null) {
      return matrix4;
    }

    final Matrix4 result = Matrix4.identity();
    if (origin != null) {
      result.translate(origin!.dx, origin!.dy);
    }
    Offset? translation;
    if (resolvedAlignment != null) {
      translation = resolvedAlignment.alongSize(size);
      result.translate(translation.dx, translation.dy);
    }
    result.multiply(matrix4);
    if (resolvedAlignment != null) {
      result.translate(-translation!.dx, -translation.dy);
    }
    if (origin != null) {
      result.translate(-origin!.dx, -origin!.dy);
    }
    return result;
  }

  Matrix4 get multiplied {
    final transform = Matrix4.identity();
    transform.multiply(_effectiveTransform);
    return transform;
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushTransform(descendents.isNotEmpty, globalOffset + offset, _effectiveTransform, (context, _) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}
