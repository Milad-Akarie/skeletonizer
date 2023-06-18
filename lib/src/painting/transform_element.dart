import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/painting.dart';

/// Holds painting information for [RenderTransform] & [RenderRotatedBox]
///
/// transforms [descendents] with provide [matrix4]
class TransformElement extends AncestorElement {
  /// see [RenderTransform.matrix]
  final Matrix4 matrix4;

  /// see [RenderTransform.origin]
  final Offset? origin;

  /// see [RenderTransform.alignment]
  final AlignmentGeometry? alignment;

  /// see [RenderTransform.textDirection]
  final TextDirection textDirection;

  /// see [RenderTransform.size]
  final Size size;

  /// Default constructor
  TransformElement({
    required this.matrix4,
    required super.descendents,
    required this.textDirection,
    required this.size,
    required super.offset,
    this.origin,
    this.alignment,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformElement &&
          runtimeType == other.runtimeType &&
          matrix4 == other.matrix4 &&
          origin == other.origin &&
          alignment == other.alignment &&
          textDirection == other.textDirection &&
          size == other.size &&
          super == (other);

  @override
  int get hashCode =>
      matrix4.hashCode ^
      origin.hashCode ^
      alignment.hashCode ^
      textDirection.hashCode ^
      size.hashCode ^
      super.hashCode;

  @override
  Rect get rect => offset & size;

  late final _transform = _effectiveTransform;

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

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final translation = MatrixUtils.getAsTranslation(_transform);
    if (translation != null) {
      for (final descendent in descendents) {
        descendent.paint(
            context, this.offset + offset + translation, shaderPaint);
      }
    } else {
      context.pushTransform(
          descendents.isNotEmpty, this.offset + offset, _transform,
          (context, _) {
        for (final descendent in descendents) {
          descendent.paint(context, offset, shaderPaint);
        }
      });
    }
  }
}
