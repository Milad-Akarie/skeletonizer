import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// A [PaintingContext] that unites all the painted rectangles.
/// into a single rectangle.
class UnitingCanvas implements Canvas {
  /// The united rectangle of all the painted rectangles.
  var unitedRect = Rect.zero;

  /// The border radius of the biggest descendant of all the painted rectangles.
  BorderRadius? borderRadius;

  /// The biggest descendant of all the painted rectangles.
  Size biggestDescendant = Size.zero;

  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    final rect = offset & Size(paragraph.maxIntrinsicWidth, paragraph.height);
    unitedRect = unitedRect.expandToInclude(rect);
    if (rect.size > biggestDescendant) {
      biggestDescendant = rect.size;
      borderRadius = BorderRadius.circular(paragraph.height / 2);
    }
  }

  @override
  void clipPath(ui.Path path, {bool doAntiAlias = true}) {}

  @override
  void clipRRect(ui.RRect rrect, {bool doAntiAlias = true}) {}

  @override
  void clipRect(
    ui.Rect rect, {
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  }) {}

  @override
  void drawArc(
    ui.Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    ui.Paint paint,
  ) =>
      unitedRect = unitedRect.expandToInclude(rect);

  @override
  void drawAtlas(
    ui.Image atlas,
    List<ui.RSTransform> transforms,
    List<ui.Rect> rects,
    List<ui.Color>? colors,
    ui.BlendMode? blendMode,
    ui.Rect? cullRect,
    ui.Paint paint,
  ) {
    for (final rect in rects) {
      unitedRect = unitedRect.expandToInclude(rect);
    }
  }

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    final rect = Rect.fromCircle(center: c, radius: radius);
    unitedRect = unitedRect.expandToInclude(rect);
    if (rect.size > biggestDescendant) {
      biggestDescendant = rect.size;
      borderRadius = BorderRadius.circular(radius);
    }
  }

  @override
  void drawColor(ui.Color color, ui.BlendMode blendMode) {}

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(outer.outerRect);
  }

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(
      offset & Size(image.width.toDouble(), image.height.toDouble()),
    );
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    unitedRect = unitedRect.expandToInclude(dst);
  }

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    unitedRect = unitedRect.expandToInclude(src);
  }

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(Rect.fromPoints(p1, p2));
  }

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(rect);
  }

  @override
  void drawPaint(ui.Paint paint) {}

  @override
  void drawPath(ui.Path path, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(path.getBounds());
  }

  @override
  void drawPicture(ui.Picture picture) {}

  @override
  void drawPoints(
    ui.PointMode pointMode,
    List<ui.Offset> points,
    ui.Paint paint,
  ) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dx);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    unitedRect = unitedRect.expandToInclude(path.getBounds());
  }

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(rect);
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    unitedRect = unitedRect.expandToInclude(rrect.outerRect);
    if (rrect.outerRect.size > biggestDescendant) {
      biggestDescendant = rrect.outerRect.size;
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(rrect.tlRadiusX),
        topRight: Radius.circular(rrect.trRadiusX),
        bottomLeft: Radius.circular(rrect.blRadiusX),
        bottomRight: Radius.circular(rrect.brRadiusX),
      );
    }
  }

  @override
  void drawRawAtlas(
    ui.Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    ui.BlendMode? blendMode,
    ui.Rect? cullRect,
    ui.Paint paint,
  ) {}

  @override
  void drawRawPoints(
    ui.PointMode pointMode,
    Float32List points,
    ui.Paint paint,
  ) {}

  @override
  void drawShadow(
    ui.Path path,
    ui.Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    unitedRect = unitedRect.expandToInclude(path.getBounds());
  }

  @override
  void drawVertices(
    ui.Vertices vertices,
    ui.BlendMode blendMode,
    ui.Paint paint,
  ) {}

  @override
  int getSaveCount() => 0;

  @override
  void restore() {}

  @override
  void rotate(double radians) {}

  @override
  void save() {}

  @override
  void scale(double sx, [double? sy]) {}

  @override
  void skew(double sx, double sy) {}

  @override
  void transform(Float64List matrix4) {}

  @override
  void translate(double dx, double dy) {}

  @override
  ui.Rect getDestinationClipBounds() => Rect.zero;

  @override
  ui.Rect getLocalClipBounds() => Rect.zero;

  @override
  Float64List getTransform() => Float64List.fromList(const []);

  @override
  void restoreToCount(int count) {}

  @override
  void saveLayer(ui.Rect? bounds, ui.Paint paint) {}
}

/// A [PaintingContext] that unites all the painted rectangles.
class UnitingPaintingContext extends PaintingContext {
  /// Creates a [UnitingPaintingContext] with the given [containerLayer] and [estimatedBounds].
  UnitingPaintingContext(super.containerLayer, super.estimatedBounds);

  @override
  final UnitingCanvas canvas = UnitingCanvas();

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    child.paint(this, offset);
  }
}
