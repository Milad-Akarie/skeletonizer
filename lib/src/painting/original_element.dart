import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/rendering/render_skeleton_shader_mask.dart';

/// Holds the original render object
/// and just paints it with global offset
class OriginalElement extends PaintableElement {
  /// The render object to paint
  final RenderBox renderObject;

  /// Default constructor
  OriginalElement({
    required super.offset,
    required this.renderObject,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    renderObject.paint(context, this.offset + offset);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OriginalElement &&
          runtimeType == other.runtimeType &&
          offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  Rect get rect => offset & renderObject.size;
}

/// Holds RenderSkeletonShaderMask object
/// and just paints it with global offset
/// after setting shader information
///
/// This is added it to the actual tree using
/// [Skeleton.shade]
class ShadedElement extends PaintableElement {
  /// The shader render object
  final RenderSkeletonShaderMask renderObject;

  /// The size used when creating the paint shader
  final Size canvasSize;

  /// Default construct
  ShadedElement({
    required super.offset,
    required this.canvasSize,
    required this.renderObject,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadedElement &&
          runtimeType == other.runtimeType &&
          offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    renderObject.shader = shaderPaint.shader;
    renderObject.maskRect = offset & canvasSize + this.offset;
    renderObject.paint(context, this.offset + offset);
  }

  @override
  Rect get rect => Rect.zero;
}
