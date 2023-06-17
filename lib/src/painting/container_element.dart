import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/utils.dart';

class ContainerElement extends AncestorElement {
  final double? elevation;
  final BoxBorder? border;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BoxShape boxShape;
  @override
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
  }) : super(offset: rect.topLeft);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContainerElement &&
          runtimeType == other.runtimeType &&
          elevation == other.elevation &&
          border == other.border &&
          color == other.color &&
          const ListEquality().equals(boxShadow, other.boxShadow)  &&
          boxShape == other.boxShape &&
          super == (other) &&
          rect == other.rect &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode =>
      elevation.hashCode ^
      border.hashCode ^
      color.hashCode ^
      const ListEquality().hash(boxShadow) ^
      boxShape.hashCode ^
      rect.hashCode ^
      borderRadius.hashCode ^
      super.hashCode;


  @override
  String toString() {
    return 'ContainerElement{elevation: $elevation, border: $border, color: $color, boxShadow: $boxShadow, boxShape: $boxShape, rect: $rect, borderRadius: $borderRadius}, descendents: $descendents';
  }

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

    if (border is Border) {
      _paintBorder(shaderPaint, border as Border, context, shiftedRect);
    }
    for (final descendent in descendents) {
      descendent.paint(context, offset, shaderPaint);
    }
  }

  void _paintBorder(Paint shaderPaint, Border borderToDraw, PaintingContext context, Rect shiftedRect) {
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
