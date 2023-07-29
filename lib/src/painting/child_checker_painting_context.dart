import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

 /// A [Canvas] that reports true if it was used to paint anything.
class ChildCheckerCanvas implements Canvas {
  /// Whether the [PaintingContext] has any paintable children.
  bool hasPaintableChild = false;

  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    hasPaintableChild = true;
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
  ) {
    hasPaintableChild = true;
  }

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
    hasPaintableChild = true;
  }

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawColor(ui.Color color, ui.BlendMode blendMode) {}

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    hasPaintableChild = true;
  }

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    hasPaintableChild = true;
  }

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawPaint(ui.Paint paint) {}

  @override
  void drawPath(ui.Path path, ui.Paint paint) {
    hasPaintableChild = true;
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
    hasPaintableChild = true;
  }

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    hasPaintableChild = true;
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    hasPaintableChild = true;
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
  ) {
    hasPaintableChild = true;
  }

  @override
  void drawShadow(
    ui.Path path,
    ui.Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    hasPaintableChild = true;
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

/// A [PaintingContext] that checks if a RenderObject has any
/// paintable children.
class ChildCheckerPaintingContext extends PaintingContext {
  /// Creates a [ChildCheckerPaintingContext] with the given [containerLayer] and [estimatedBounds].
  ChildCheckerPaintingContext(super.containerLayer, super.estimatedBounds);

  @override
  final ChildCheckerCanvas canvas = ChildCheckerCanvas();

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    child.paint(this, offset);
  }
}
