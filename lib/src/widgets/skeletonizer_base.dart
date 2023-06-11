import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:collection/collection.dart';
import 'package:skeleton_builder/src/helper_utils.dart';
import 'package:skeleton_builder/src/painting/paintable_element.dart';

class SkeletonizerBase extends SingleChildRenderObjectWidget {
  const SkeletonizerBase({
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
  void updateRenderObject(
    BuildContext context,
    covariant RenderSkeletonizer renderObject,
  ) {
    renderObject
      ..loading = loading
      ..shimmer = shimmer;
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

  @override
  void markNeedsLayout() {
    super.markNeedsLayout();
    _needsSkeletonizing = true;
  }

  void _skeletonize() {
    _needsSkeletonizing = false;
    _paintableElements.clear();
    _skeletonizeRecursively(this, _paintableElements, Offset.zero);
  }

  final _paintableElements = <PaintableElement>[];

  Offset get rootOffset {
    final transform = Matrix4.identity();
    if (parent is RenderObject) {
      (parent as RenderObject).applyPaintTransform(this, transform);
      return MatrixUtils.transformPoint(transform, Offset.zero);
    }
    return Offset.zero;
  }

  void _skeletonizeRecursively(RenderObject node, List<PaintableElement> elements, Offset offset) {
    node.visitChildren((child) {
      var childOffset = offset;

      final transform = Matrix4.identity();
      if (node is! RenderTransform) {
        node.applyPaintTransform(child, transform);
        childOffset = MatrixUtils.transformPoint(transform, offset);
      }

      if (child is RenderSkeletonAnnotation) {
        if (child.annotation is IgnoreDescendants) {
          return;
        } else if (child.annotation is ShadeOriginal) {
          return elements.add(
            ShadedElement(
              offset: childOffset,
              renderObject: child.child!,
              canvasSize: size,
            ),
          );
        }
      }

      if (child is RenderBox) {
        if (child is RenderClipRRect) {
          final RRect clipRect;
          if(child.clipper != null){
            clipRect = child.clipper!.getClip(child.size);
          }else {
            final borderRadius = child.borderRadius.resolve(textDirection);
            clipRect = (offset & child.size).toRRect(borderRadius);
          }
          elements.add(
            RRectClipElement(
              clip: clipRect,
              descendents: _getDescendents(child, childOffset),
            ),
          );
          return;
        } else if (child is RenderClipPath) {
          final clipper = child.clipper;
          if (clipper != null) {
            elements.add(
              PathClipElement(
                offset: childOffset,
                clip: clipper.getClip(child.size),
                descendents: _getDescendents(child, childOffset),
              ),
            );
            return;
          }
        } else if (child is RenderClipOval) {
          final rect = child.clipper?.getClip(child.size) ?? child.paintBounds;
          elements.add(
            PathClipElement(
              offset: childOffset,
              clip: Path()..addOval(rect),
              descendents: _getDescendents(child, childOffset),
            ),
          );
          return;
        } else if(child is RenderClipRect){
          elements.add(
            RectClipElement(
              offset: childOffset,
              clip: child.clipper?.getClip(child.size) ?? child.paintBounds,
              descendents: _getDescendents(child, childOffset),
            ),
          );
          return;
        }else if (child is RenderTransformX) {
          final matrix = debugValueOfType<Matrix4>(child)!.clone();
          elements.add(
            TransformElement(
              matrix4: matrix,
              size: child.size,
              textDirection: textDirection,
              origin: child.origin,
              alignment: child.alignment,
              descendents: _getDescendents(child, childOffset),
              offset: offset,
            ),
          );
          return;
        } else if(child is RenderImage){
          elements.add(BoneElement(rect: childOffset & child.size));
        }else if (child is RenderParagraph) {
          elements.add(_buildTextBone(child, childOffset));
        } else if (child is RenderPhysicalModel) {
          elements.add(_buildPhysicalModel(child, childOffset));
        } else if (child is RenderPhysicalShape) {
          elements.add(_buildPhysicalShape(child, childOffset));
        } else if (child is RenderDecoratedBox) {
          elements.add(_buildDecoratedBox(child, childOffset));
        }
      }
      _skeletonizeRecursively(child, elements, childOffset);
    });
  }

  List<PaintableElement> _getDescendents(RenderObject child, Offset childOffset) {
    final descendents = <PaintableElement>[];
    _skeletonizeRecursively(child, descendents, childOffset);
    return descendents;
  }

  TextBoneElement _buildTextBone(RenderParagraph node, Offset offset) {
    final painter = TextPainter(
      text: node.text,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      textScaleFactor: node.textScaleFactor,
    )..layout(maxWidth: node.constraints.maxWidth);
    final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;
    return TextBoneElement(
      fontSize: fontSize,
      lines: painter.computeLineMetrics(),
      offset: offset,
    );
  }

  ContainerElement _buildDecoratedBox(RenderDecoratedBox node, Offset offset) {
    final boxDecoration = node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

    return ContainerElement(
      rect: offset & node.size,
      border: boxDecoration.border,
      borderRadius: boxDecoration.borderRadius?.resolve(textDirection),
      descendents: _getDescendents(node, offset),
      color: boxDecoration.color,
      boxShape: boxDecoration.shape,
      boxShadow: boxDecoration.boxShadow,
    );
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
  bool _needsSkeletonizing = true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!loading) {
      return super.paint(context, offset);
    }

    if (_needsSkeletonizing || _lastSkeletonizedWidth != size.width) {
      _lastSkeletonizedWidth = size.width;
      final watch = Stopwatch()..start();
      _skeletonize();
      print('Skeletonized in : ${watch.elapsedMilliseconds}');
    }
    final shader = _shimmer.createShader(offset & size, textDirection: textDirection);
    final shaderPaint = Paint()..shader = shader;
    // final shaderPaint = Paint()..color = Colors.red;

    for (final element in _paintableElements) {
      element.paint(context, offset, shaderPaint);
    }
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
      _skeletonizeRecursively(node, descendents, offset);
    }
    return ContainerElement(
      rect: offset & node.size,
      elevation: node.elevation,
      descendents: descendents,
      color: node.color,
      borderRadius: borderRadius?.resolve(textDirection),
    );
  }

  ContainerElement _buildPhysicalModel(RenderPhysicalModel node, Offset offset) {
    final shape = node.clipper == null ? null : (node.clipper as ShapeBorderClipper).shape;
    BorderRadiusGeometry? borderRadius;
    if (shape is RoundedRectangleBorder) {
      borderRadius = shape.borderRadius;
    } else if (shape is StadiumBorder) {
      borderRadius = BorderRadius.circular(node.size.height);
    } else if (shape is CircleBorder) {}
    return ContainerElement(
      rect: offset & node.size,
      elevation: node.elevation,
      descendents: _getDescendents(node, offset),
      color: node.color,
      borderRadius: borderRadius?.resolve(textDirection),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LinearGradient>('_shimmer', _shimmer));
  }
}
