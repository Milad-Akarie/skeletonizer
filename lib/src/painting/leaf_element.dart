import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/utils.dart';

/// Holds painting information of leaf elements
/// e.g [ImageRender]
///
/// typically paints a [Rect] or a [RRect] with shader paint
class LeafElement extends PaintableElement {
  @override
  final Rect rect;

  /// The border radius of the element
  final BorderRadius? borderRadius;

  /// Default constructor
  LeafElement({
    required this.rect,
    this.borderRadius,
  }) : super(offset: rect.topLeft);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeafElement &&
          runtimeType == other.runtimeType &&
          rect == other.rect &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode => rect.hashCode ^ borderRadius.hashCode;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final shiftedRect = rect.shift(offset);
    if (borderRadius != null) {
      final rRect = shiftedRect.toRRect(borderRadius!);
      context.canvas.drawRRect(rRect, shaderPaint);
    } else {
      context.canvas.drawRect(shiftedRect, shaderPaint);
    }
  }
}
