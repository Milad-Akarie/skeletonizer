import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/painting.dart';

/// Holds painting information for [RenderTransform] & [RenderRotatedBox]
///
/// transforms [descendents] with provide [matrix4]
class TransformElement extends AncestorElement {
  /// see [RenderTransform.matrix]
  final Matrix4 matrix4;

  /// see [RenderTransform.size]
  final Size size;

  /// Default constructor
  TransformElement({
    required this.matrix4,
    required super.descendents,
    required this.size,
    required super.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformElement &&
          runtimeType == other.runtimeType &&
          matrix4 == other.matrix4 &&
          size == other.size &&
          super == (other);

  @override
  int get hashCode => matrix4.hashCode ^ size.hashCode ^ super.hashCode;

  @override
  Rect get rect => offset & size;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final translation = MatrixUtils.getAsTranslation(matrix4);
    if (translation != null) {
      for (final descendent in descendents) {
        descendent.paint(context, offset + translation, shaderPaint);
      }
    } else {
      context.pushTransform(true, offset + this.offset, matrix4, (context, _) {
        for (final descendent in descendents) {
          descendent.paint(context, offset, shaderPaint);
        }
      });
    }
  }
}
