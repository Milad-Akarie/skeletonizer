import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';
import 'package:skeletonizer/src/utils.dart';

/// Holds painting information for container-type widgets
/// e.g [Card],[Material],[Container],[ColoredBox]..
class ContainerElement extends AncestorElement {
  /// The elevation of the container
  final double? elevation;

  /// The Border of the container
  final BoxBorder? border;

  /// The color of the container
  final Color? color;

  /// The boxShadow of the container
  final List<BoxShadow>? boxShadow;

  /// The shape of the container
  final BoxShape boxShape;
  @override
  final Rect rect;

  /// The borderRadius of the container
  final BorderRadius? borderRadius;

  /// Whether to ignore the container and only paint
  /// dependents
  final bool drawContainer;

  /// Default constructor
  ContainerElement({
    required super.descendents,
    this.elevation,
    required this.rect,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxShadow,
    this.drawContainer = true,
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
          drawContainer == other.drawContainer &&
          color == other.color &&
          const ListEquality().equals(boxShadow, other.boxShadow) &&
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
      drawContainer.hashCode ^
      borderRadius.hashCode ^
      super.hashCode;

  @override
  String toString() {
    return 'ContainerElement{elevation: $elevation, border: $border, color: $color, boxShadow: $boxShadow, boxShape: $boxShape, rect: $rect, borderRadius: $borderRadius}, descendents: $descendents';
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    final shiftedRect = rect.shift(offset);
    final hasDescendents = descendents.isNotEmpty;
    if (drawContainer || !hasDescendents) {
      if (color != null) {
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
            hasDescendents ? surfacePaint : shaderPaint,
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
          context.canvas.drawRRect(
            rRect,
            hasDescendents ? surfacePaint : shaderPaint,
          );
        } else {
          if (drawElevation) {
            context.canvas.drawShadow(Path()..addRect(shiftedRect), Colors.black, elevation!, false);
          }
          if (boxShadow != null) {
            for (final box in boxShadow!) {
              context.canvas.drawRect(shiftedRect.shift(box.offset), box.toPaint());
            }
          }
          context.canvas.drawRect(
            shiftedRect,
            hasDescendents ? surfacePaint : shaderPaint,
          );
        }
      }
      if (border is Border) {
        _paintBorder(shaderPaint, border as Border, context, shiftedRect);
      }
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
      _paintPresentBorders(
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

  void _paintPresentBorders(
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
