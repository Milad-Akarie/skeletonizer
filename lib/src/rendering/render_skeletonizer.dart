import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/rendering/render_skeleton_shader_mask.dart';
import 'dart:math' as math;

import 'package:skeletonizer/src/utils.dart';
import 'package:skeletonizer/src/painting/painting.dart';

const double _kQuarterTurnsInRadians = math.pi / 2.0;

/// Builds a renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
class RenderSkeletonizer extends RenderProxyBox with _RenderSkeletonBase<RenderBox> {
  /// Default constructor
  RenderSkeletonizer({
    required bool enabled,
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    RenderBox? child,
    required SkeletonizerConfigData config,
  })  : _animationValue = animationValue,
        _enabled = enabled,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  Brightness _brightness;

  @override
  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return !_enabled && super.hitTest(result, position: position);
  }
}

/// Builds a sliver renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
class RenderSliverSkeletonizer extends RenderProxySliver with _RenderSkeletonBase<RenderSliver> {
  /// Default constructor
  RenderSliverSkeletonizer({
    required bool enabled,
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    RenderSliver? child,
    required SkeletonizerConfigData config,
  })  : _animationValue = animationValue,
        _enabled = enabled,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  Brightness _brightness;

  @override
  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      _needsSkeletonizing = true;
      markNeedsPaint();
    }
  }

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(SliverHitTestResult result, {required double mainAxisPosition, required double crossAxisPosition}) {
    if (!_enabled) return false;
    return super.hitTest(result, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
  }
}

/// Builds a renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
mixin _RenderSkeletonBase<R extends RenderObject> on RenderObjectWithChildMixin<R> {
  /// The text direction used to resolve Directional geometries
  TextDirection get textDirection;

  /// The resolved skeletonizer theme data
  SkeletonizerConfigData get config;

  /// The selected brightness
  Brightness get brightness;

  /// Whether the skeletonizer is enabled
  bool get enabled;

  /// The value to animate painting effects
  double get animationValue;

  void _skeletonize() {
    _needsSkeletonizing = false;
    paintableElements.clear();
    _skeletonizeRecursively(this, paintableElements, Offset.zero);
  }

  /// Holds the painting elements stripped out
  /// the actual render tree
  @visibleForTesting
  final paintableElements = <PaintableElement>[];

  void _skeletonizeRecursively(RenderObject node, List<PaintableElement> elements, Offset offset) {
    // avoid skeletonizing renderers outside of skeletonizer bounds
    //
    // this may need shifting by parent offset
    if (!paintBounds.containsRect(node.paintBounds)) {
      return;
    }

    node.visitChildren((child) {
      var childOffset = offset;
      if (child.hasParentData) {
        final transform = Matrix4.identity();
        if (node is! RenderTransform && node is! RenderRotatedBox) {
          node.applyPaintTransform(child, transform);
          childOffset = MatrixUtils.transformPoint(transform, offset);
        }
      }

      // avoid skeletonizing renderers outside of parent bounds
      if (!node.paintBounds.containsRect(child.paintBounds)) {
        return;
      }

      if (child is RenderSkeletonAnnotation) {
        if (child.annotation is IgnoreDescendants) {
          return;
        }
        if (child.annotation is KeepOriginal) {
          return elements.add(
            OriginalElement(
              offset: childOffset,
              renderObject: child.child!,
            ),
          );
        } else if (child.annotation is UniteDescendents) {
          final descendents = _getDescendents(child.child!, childOffset);
          final (rect, borderRadius) = _union(descendents);
          final effectiveBorderRadius =
              (child.annotation as UniteDescendents).borderRadius?.resolve(textDirection) ?? borderRadius;
          elements.add(LeafElement(rect: rect, borderRadius: effectiveBorderRadius));
          return;
        }
      }
      if (child is RenderSkeletonShaderMask) {
        return elements.add(
          ShadedElement(
            offset: childOffset,
            renderObject: child,
            canvasSize: paintBounds.size,
          ),
        );
      } else if (child is RenderBox) {
        if (child is RenderClipRRect) {
          return _handleClipRRect(child, childOffset, elements);
        } else if (child is RenderClipPath) {
          return _handlePathClip(child, childOffset, elements);
        } else if (child is RenderClipOval) {
          return _handleOvalClip(child, childOffset, elements);
        } else if (child is RenderClipRect) {
          return _handleClipRect(child, childOffset, elements);
        } else if (child is RenderTransform) {
          return _handleTransform(child, childOffset, elements);
        } else if (child is RenderImage) {
          return elements.add(LeafElement(rect: childOffset & child.size));
        } else if (child is RenderParagraph) {
          return elements.add(_buildTextBone(child, childOffset));
        } else if (child is RenderPhysicalModel) {
          return elements.add(_buildPhysicalModel(child, childOffset));
        } else if (child is RenderPhysicalShape) {
          return elements.add(_buildPhysicalShape(child, childOffset));
        } else if (child is RenderDecoratedBox) {
          return elements.add(_buildDecoratedBox(child, childOffset));
        } else if (child.widget is ColoredBox) {
          return elements.add(
            ContainerElement(
                rect: childOffset & child.size,
                color: (child.widget as ColoredBox).color,
                descendents: _getDescendents(child, childOffset),
                drawContainer: !config.ignoreContainers),
          );
        } else if (child is RenderRotatedBox) {
          final element = _buildRotatedBox(child, childOffset);
          if (element != null) {
            elements.add(element);
          }
          return;
        }
      }
      _skeletonizeRecursively(child, elements, childOffset);
    });
  }

  void _handleClipRRect(RenderClipRRect child, Offset childOffset, List<PaintableElement> elements) {
    final descendents = _getDescendents(child, childOffset);
    if (child.clipBehavior == Clip.none) {
      elements.addAll(descendents);
    } else if (descendents.isNotEmpty) {
      final RRect clipRect;
      if (child.clipper != null) {
        clipRect = child.clipper!.getClip(child.size);
      } else {
        final borderRadius = child.borderRadius.resolve(textDirection);
        clipRect = (childOffset & child.size).toRRect(borderRadius);
      }
      elements.add(
        ClipRRectElement(
          clip: clipRect,
          offset: childOffset,
          descendents: descendents,
        ),
      );
    }
  }

  void _handlePathClip(RenderClipPath child, Offset childOffset, List<PaintableElement> elements) {
    final descendents = _getDescendents(child, childOffset);
    final clipper = child.clipper;
    if (child.clipBehavior == Clip.none) {
      elements.addAll(descendents);
    } else if (clipper != null && descendents.isNotEmpty) {
      elements.add(
        ClipPathElement(
          offset: childOffset,
          clip: clipper.getClip(child.size),
          descendents: _getDescendents(child, childOffset),
        ),
      );
    }
  }

  void _handleOvalClip(RenderClipOval child, Offset childOffset, List<PaintableElement> elements) {
    final descendents = _getDescendents(child, childOffset);
    if (child.clipBehavior == Clip.none) {
      elements.addAll(descendents);
    } else if (descendents.isNotEmpty) {
      final rect = child.clipper?.getClip(child.size) ?? child.paintBounds;
      elements.add(
        ClipPathElement(
          offset: childOffset,
          clip: Path()..addOval(rect),
          descendents: descendents,
        ),
      );
    }
  }

  void _handleTransform(RenderTransform child, Offset childOffset, List<PaintableElement> elements) {
    final descendents = _getDescendents(child, childOffset);
    if (descendents.isNotEmpty) {
      elements.add(
        TransformElement(
          matrix4: _debugValueOfType<Matrix4>(child)!.clone(),
          size: child.size,
          textDirection: textDirection,
          origin: child.origin,
          alignment: child.alignment,
          descendents: descendents,
          offset: childOffset,
        ),
      );
    }
  }

  void _handleClipRect(RenderClipRect child, Offset childOffset, List<PaintableElement> elements) {
    final descendents = _getDescendents(child, childOffset);
    if (child.clipBehavior == Clip.none) {
      elements.addAll(descendents);
    } else if (descendents.isNotEmpty) {
      elements.add(
        ClipRectElement(
          offset: childOffset,
          rect: child.clipper?.getClip(child.size) ?? child.paintBounds,
          descendents: descendents,
        ),
      );
    }
  }

  (Rect, BorderRadius?) _union(List<PaintableElement> descendents) {
    if (descendents.isEmpty) return (Rect.zero, null);

    var expanded = Rect.fromPoints(
      descendents.first.offset,
      descendents.first.offset,
    );
    BorderRadius? borderRadius;
    Size biggestDescendent = Size.zero;
    for (final descendent in descendents) {
      if (descendent is LeafElement) {
        if (descendent.rect.size > biggestDescendent) {
          biggestDescendent = descendent.rect.size;
          borderRadius = descendent.borderRadius;
        }
        expanded = expanded.expandToInclude(descendent.rect);
      } else if (descendent is ContainerElement) {
        if (descendent.rect.size > biggestDescendent) {
          biggestDescendent = descendent.rect.size;
          borderRadius = descendent.borderRadius;
        }
        expanded = expanded.expandToInclude(descendent.rect);
      } else if (descendent is TextElement) {
        if (descendent.textSize > biggestDescendent) {
          biggestDescendent = descendent.textSize;
          borderRadius = descendent.borderRadius;
        }
        expanded = expanded.expandToInclude(descendent.offset & descendent.textSize);
      }
    }
    return (expanded, borderRadius);
  }

  List<PaintableElement> _getDescendents(RenderObject child, Offset childOffset) {
    final descendents = <PaintableElement>[];
    _skeletonizeRecursively(child, descendents, childOffset);
    return descendents;
  }

  TextElement _buildTextBone(RenderParagraph node, Offset offset) {
    final painter = TextPainter(
      text: node.text,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      textScaleFactor: node.textScaleFactor,
      maxLines: node.maxLines,
    )..layout(
        maxWidth: node.constraints.maxWidth,
        minWidth: node.constraints.minWidth,
      );
    final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;

    return TextElement(
      fontSize: fontSize,
      textSize: painter.size,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      justifyMultiLines: config.justifyMultiLineText,
      lines: painter.computeLineMetrics(),
      offset: offset,
      borderRadius: config.textBorderRadius.usesHeightFactor
          ? BorderRadius.circular(fontSize * config.textBorderRadius.heightPercentage!)
          : config.textBorderRadius.borderRadius!.resolve(textDirection),
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
      drawContainer: !config.ignoreContainers,
    );
  }

  TransformElement? _buildRotatedBox(RenderRotatedBox child, Offset childOffset) {
    final descendents = _getDescendents(child, childOffset);
    if (descendents.isNotEmpty) {
      final transChild = child.child!;
      final transform = Matrix4.identity()
        ..translate(child.size.width / 2.0, child.size.height / 2.0)
        ..rotateZ(_kQuarterTurnsInRadians * (child.quarterTurns % 4))
        ..translate(-transChild.size.width / 2.0, -transChild.size.height / 2.0);
      return TransformElement(
        matrix4: transform,
        descendents: descendents,
        textDirection: textDirection,
        size: child.size,
        offset: childOffset,
      );
    }
    return null;
  }

  List<DiagnosticsNode> _debugProperties(Diagnosticable node) {
    final builder = DiagnosticPropertiesBuilder();
    node.debugFillProperties(builder);
    return builder.properties;
  }

  T? _debugValueOfType<T>(RenderObject node) {
    return _debugProperties(node).firstWhereOrNull((e) => e.value is T)?.value as T?;
  }

  bool _needsSkeletonizing = true;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
    _needsSkeletonizing = true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!enabled) {
      return super.paint(context, offset);
    }
    if (_needsSkeletonizing) _skeletonize();
    final paint = config.effect.createPaint(animationValue, offset & paintBounds.size);
    for (final element in paintableElements) {
      element.paint(context, offset, paint);
    }
  }

  PaintableElement _buildPhysicalShape(RenderPhysicalShape node, Offset offset) {
    final isButton = node.findParentWithName('_RenderInputPadding') != null;
    final shape = (node.clipper as ShapeBorderClipper).shape;
    BorderRadiusGeometry? borderRadius;
    if (shape is RoundedRectangleBorder) {
      borderRadius = shape.borderRadius;
    } else if (shape is StadiumBorder) {
      borderRadius = BorderRadius.circular(node.size.height);
    }
    var descendents = isButton ? const <PaintableElement>[] : _getDescendents(node, offset);

    if (borderRadius != null && node.clipBehavior != Clip.none && descendents.isNotEmpty) {
      final clipRect = (offset & node.size).toRRect(borderRadius.resolve(textDirection));
      descendents = [
        ClipRRectElement(
          clip: clipRect,
          offset: offset,
          descendents: descendents,
        )
      ];
    }
    return ContainerElement(
      rect: offset & node.size,
      elevation: node.elevation,
      descendents: descendents,
      color: node.color,
      boxShape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: borderRadius?.resolve(textDirection),
      drawContainer: !config.ignoreContainers,
    );
  }

  ContainerElement _buildPhysicalModel(RenderPhysicalModel node, Offset offset) {
    final shape = node.clipper == null ? null : (node.clipper as ShapeBorderClipper).shape;
    BorderRadiusGeometry? borderRadius;
    if (shape is RoundedRectangleBorder) {
      borderRadius = shape.borderRadius;
    } else if (shape is StadiumBorder) {
      borderRadius = BorderRadius.circular(node.size.height);
    }
    return ContainerElement(
      rect: offset & node.size,
      elevation: node.elevation,
      descendents: _getDescendents(node, offset),
      color: node.color,
      boxShape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: borderRadius?.resolve(textDirection),
      drawContainer: !config.ignoreContainers,
    );
  }
}
