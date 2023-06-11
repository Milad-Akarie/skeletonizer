import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/src/helper_utils.dart';

abstract class PaintableElement {
  const PaintableElement();

  void paint(PaintingContext context, Offset offset, Paint shaderPaint);
}

abstract class AncestorElement extends PaintableElement {
  final List<PaintableElement> descendents;

  const AncestorElement({this.descendents = const []});
}

class BoneElement extends PaintableElement {
  final Rect rect;
  final BorderRadius? borderRadius;

  BoneElement({
    required this.rect,
    this.borderRadius,
  });

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

class ShadedElement extends PaintableElement {
  final Offset offset;
  final RenderBox renderObject;
  final Size canvasSize;

  ShadedElement({
    required this.offset,
    required this.canvasSize,
    required this.renderObject,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final layer = ShaderMaskLayer()
      ..shader = shaderPaint.shader
      ..maskRect = Offset.zero & canvasSize + offset
      ..blendMode = BlendMode.srcATop;

    context.pushLayer(
      layer,
      renderObject.paint,
      this.offset + offset,
      childPaintBounds: renderObject.paintBounds,
    );
  }
}

class ContainerElement extends AncestorElement {
  final double? elevation;
  final BoxBorder? border;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BoxShape boxShape;
  final Rect rect;
  final BorderRadius? borderRadius;

  ContainerElement({
    required super.descendents,
    this.elevation,
    required this.rect,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxShadow,
    this.color,
    this.border,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final shiftedRect = rect.shift(offset);
    if (color != null) {
      final treatAsBone = descendents.isEmpty;
      final surfacePaint = Paint()..color = color ?? Colors.white;
      final drawElevation = descendents.isNotEmpty && elevation != null && elevation! > 0;

      if (boxShape == BoxShape.circle) {
        if (boxShadow != null) {
          for (final box in boxShadow!) {
            context.canvas.drawCircle(
              shiftedRect.center + box.offset,
              shiftedRect.shortestSide / 2,
              box.toPaint(),
            );
          }
        }
        context.canvas.drawCircle(
          shiftedRect.center,
          shiftedRect.shortestSide / 2,
          treatAsBone ? shaderPaint : surfacePaint,
        );
      } else if (borderRadius != null) {
        final rRect = shiftedRect.toRRect(borderRadius!);
        if (drawElevation) {
          context.canvas.drawShadow(
            Path()..addRRect(rRect),
            Colors.black,
            elevation!,
            false,
          );
        }
        if (boxShadow != null) {
          for (final box in boxShadow!) {
            context.canvas.drawRRect(rRect.shift(box.offset), box.toPaint());
          }
        }
        context.canvas.drawRRect(rRect, treatAsBone ? shaderPaint : surfacePaint);
      } else {
        if (drawElevation) {
          context.canvas.drawShadow(Path()..addRect(shiftedRect), Colors.black, elevation!, false);
        }
        if (boxShadow != null) {
          for (final box in boxShadow!) {
            context.canvas.drawRect(shiftedRect.shift(box.offset), box.toPaint());
          }
        }

        context.canvas.drawRect(shiftedRect, treatAsBone ? shaderPaint : surfacePaint);
      }
    }
    final borderToDraw = border;

    if (borderToDraw is Border) {
      final borderPaint = Paint()
        ..shader = shaderPaint.shader
        ..color = Colors.black
        ..style = PaintingStyle.stroke;
      if (borderToDraw.isUniform) {
        borderPaint.strokeWidth = borderToDraw.top.width;
        context.canvas.drawRRect(shiftedRect.toRRect(borderRadius ?? BorderRadius.zero), borderPaint);
      } else {
        paintBorder(
          context.canvas,
          shiftedRect,
          paint: borderPaint,
          top: borderToDraw.top,
          bottom: borderToDraw.bottom,
          left: borderToDraw.left,
          right: borderToDraw.right,
        );
      }
    }
    for (final descendent in descendents) {
      descendent.paint(context, offset, shaderPaint);
    }
  }

  void paintBorder(
    Canvas canvas,
    Rect rect, {
    required Paint paint,
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
  }) {
    final Path path = Path();

    switch (top.style) {
      case BorderStyle.solid:
        paint.color = top.color;
        path.reset();
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        if (top.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.right - right.width, rect.top + top.width);
          path.lineTo(rect.left + left.width, rect.top + top.width);
        }
        canvas.drawPath(path, paint);
      case BorderStyle.none:
        break;
    }

    switch (right.style) {
      case BorderStyle.solid:
        paint.color = right.color;
        path.reset();
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        if (right.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
          path.lineTo(rect.right - right.width, rect.top + top.width);
        }
        canvas.drawPath(path, paint);
      case BorderStyle.none:
        break;
    }

    switch (bottom.style) {
      case BorderStyle.solid:
        paint.color = bottom.color;
        path.reset();
        path.moveTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        if (bottom.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
          path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
        }
        canvas.drawPath(path, paint);
      case BorderStyle.none:
        break;
    }

    switch (left.style) {
      case BorderStyle.solid:
        paint.color = left.color;
        path.reset();
        path.moveTo(rect.left, rect.bottom);
        path.lineTo(rect.left, rect.top);
        if (left.width == 0.0) {
          paint.style = PaintingStyle.stroke;
        } else {
          paint.style = PaintingStyle.fill;
          path.lineTo(rect.left + left.width, rect.top + top.width);
          path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
        }
        canvas.drawPath(path, paint);
      case BorderStyle.none:
        break;
    }
  }
}

class TextBoneElement extends PaintableElement {
  final List<LineMetrics> lines;
  final double fontSize;
  final Offset offset;

  TextBoneElement({
    required this.offset,
    required this.lines,
    required this.fontSize,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final drawingOffset = this.offset + offset;
    var yOffset = drawingOffset.dy;
    for (final line in lines) {
      final rect = Rect.fromLTWH(
        drawingOffset.dx,
        yOffset,
        line.width,
        fontSize,
      );
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(fontSize / 2)),
        shaderPaint,
      );
      yOffset += line.height;
    }
  }
}

class RRectClipElement extends AncestorElement {
  final RRect clip;

  RRectClipElement({required this.clip, required super.descendents});

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRRect(false, offset, clip.middleRect, clip, (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

class RectClipElement extends AncestorElement {
  final Rect clip;
  final Offset offset;

  RectClipElement({
    required this.clip,
    required super.descendents,
    required this.offset,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRect(false, offset, clip.shift(this.offset), (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

class PathClipElement extends AncestorElement {
  final Path clip;
  final Offset offset;

  PathClipElement({
    required this.clip,
    required super.descendents,
    required this.offset,
  });

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipPath(false, offset, Rect.zero, clip.shift(this.offset), (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

class TransformElement extends AncestorElement {
  final Matrix4 matrix4;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final TextDirection textDirection;
  final Size size;
  final Offset offset;

  TransformElement({
    required this.matrix4,
    required super.descendents,
    required this.textDirection,
    required this.size,
    required this.offset,
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

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final translation = MatrixUtils.getAsTranslation(_effectiveTransform);
    if (translation != null) {
      for (final descendent in descendents) {
        descendent.paint(context, this.offset + offset + translation, shaderPaint);
      }
    } else {
      context.pushTransform(descendents.isNotEmpty, this.offset + offset, _effectiveTransform, (context, _) {
        for (final descendent in descendents) {
          descendent.paint(context, offset, shaderPaint);
        }
      });
    }
  }
}
