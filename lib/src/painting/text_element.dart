import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/utils.dart';

class TextElement extends PaintableElement {
  final List<LineMetrics> lines;
  final double fontSize;
  final Size textSize;
  final BorderRadius? borderRadius;

  TextElement({
    required super.offset,
    required this.lines,
    required this.fontSize,
    required this.textSize,
    this.borderRadius,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextElement &&
          runtimeType == other.runtimeType &&
          lines == other.lines &&
          fontSize == other.fontSize &&
          textSize == other.textSize &&
          offset == other.offset &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode => lines.hashCode ^ fontSize.hashCode ^ textSize.hashCode ^ borderRadius.hashCode ^ offset.hashCode;

  @override
  Rect get rect => offset & textSize;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final drawingOffset = this.offset + offset;
    var yOffset = drawingOffset.dy;
    for (final line in lines) {
      final rect = Rect.fromLTWH(
        drawingOffset.dx,
        yOffset + (line.height - fontSize) / 2,
        line.width,
        fontSize,
      );
      if (borderRadius != null) {
        context.canvas.drawRRect(rect.toRRect(borderRadius!), shaderPaint);
      } else {
        context.canvas.drawRect(rect, shaderPaint);
      }
      yOffset += line.height;
    }
  }
}
