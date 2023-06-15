import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/rendering/render_skeleton_shader_mask.dart';

class OriginalElement extends PaintableElement {
  final RenderBox renderObject;

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
      other is OriginalElement && runtimeType == other.runtimeType && offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  Rect get rect => offset & renderObject.size;


}

class ShadedElement extends PaintableElement {
  final RenderSkeletonShaderMask renderObject;
  final Size canvasSize;

  ShadedElement({
    required super.offset,
    required this.canvasSize,
    required this.renderObject,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShadedElement && runtimeType == other.runtimeType && offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    renderObject.shader = shaderPaint.shader;
    renderObject.maskRect = rect;
    renderObject.paint(context, this.offset + offset);
  }

  @override
  Rect get rect => Offset.zero & canvasSize + offset;
}
