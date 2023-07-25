import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/utils.dart';

class SkeletonizerPaintingContext extends PaintingContext {
  SkeletonizerPaintingContext({
    required this.layer,
    required Rect estimatedBounds,
    required this.parentCanvas,
    required this.shaderPaint,
    required this.rootOffset,
  }) : super(layer, estimatedBounds);

  final ContainerLayer layer;
  final ui.Canvas parentCanvas;
  final Paint shaderPaint;
  final Offset rootOffset;
  final _rectMap = <Rect, RectConfig>{};

  Rect get maskRect => estimatedBounds.shift(rootOffset);

  ActualPaintingContext createActualContext(Rect estimatedBounds) {
    return ActualPaintingContext(
      layer,
      estimatedBounds,
      parentCanvas,
    );
  }


  TextDirection? textDirection ;

  @override
  ui.Canvas get canvas => SkeletonizerCanvas(
        parentCanvas,
        shaderPaint: shaderPaint,
        rectConfig: (rect) {
          return _rectMap[rect];
        },
      );

  @override
  PaintingContext createChildContext(ContainerLayer childLayer, ui.Rect bounds) {
    return SkeletonizerPaintingContext(
      layer: childLayer,
      estimatedBounds: bounds,
      parentCanvas: parentCanvas,
      shaderPaint: shaderPaint,
      rootOffset: rootOffset,
    );
  }

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (child is RenderDecoratedBox) {
      // print(child.child);
      _rectMap[offset & child.size] = RectConfig(
        treatAsBone: child.child?.hasSize != true,
        // overrideColor: Colors.blue,
      );
    }

    return child.paint(this, offset);
  }
}

class SkeletonizerCanvas implements Canvas {
  SkeletonizerCanvas(this.parent, {required this.shaderPaint, required this.rectConfig});

  final Paint shaderPaint;

  /// The parent [Canvas] that handles drawing operations
  final Canvas parent;

  RectConfig? Function(Rect rect) rectConfig;

  /// Draws a rectangle on the canvas where the [paragraph]
  /// would otherwise be rendered
  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    for (final line in paragraph.computeLineMetrics()) {
      parent.drawRRect(
        (offset & Size(line.width, line.height - line.descent)).toRRect(
          BorderRadius.circular(8),
        ),
        shaderPaint,
      );
    }
  }

  @override
  void clipPath(ui.Path path, {bool doAntiAlias = true}) => parent.clipPath(path, doAntiAlias: doAntiAlias);

  @override
  void clipRRect(ui.RRect rrect, {bool doAntiAlias = true}) => parent.clipRRect(rrect, doAntiAlias: doAntiAlias);

  @override
  void clipRect(
    ui.Rect rect, {
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  }) =>
      parent.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  @override
  void drawArc(
    ui.Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    ui.Paint paint,
  ) =>
      parent.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

  @override
  void drawAtlas(
    ui.Image atlas,
    List<ui.RSTransform> transforms,
    List<ui.Rect> rects,
    List<ui.Color>? colors,
    ui.BlendMode? blendMode,
    ui.Rect? cullRect,
    ui.Paint paint,
  ) =>
      parent.drawAtlas(
        atlas,
        transforms,
        rects,
        colors,
        blendMode,
        cullRect,
        paint,
      );

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    parent.drawCircle(c, radius, paint);
  }

  @override
  void drawColor(ui.Color color, ui.BlendMode blendMode) => parent.drawColor(color, blendMode);

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) => parent.drawDRRect(outer, inner, paint);

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    parent.drawImage(image, offset, paint);
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) =>
      parent.drawImageNine(image, center, dst, paint);

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) =>
      parent.drawImageRect(image, src, dst, paint);

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) => parent.drawLine(p1, p2, paint);

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) => parent.drawOval(rect, paint);

  @override
  void drawPaint(ui.Paint paint) => parent.drawPaint(paint);

  @override
  void drawPath(ui.Path path, ui.Paint paint) => parent.drawPath(path, paint);

  @override
  void drawPicture(ui.Picture picture) {
    parent.drawPicture(picture);
  }

  @override
  void drawPoints(
    ui.PointMode pointMode,
    List<ui.Offset> points,
    ui.Paint paint,
  ) =>
      parent.drawPoints(pointMode, points, paint);

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    final config = rectConfig(rect);
    if (config?.treatAsBone == true) {
      parent.drawRect(rect, shaderPaint);
    } else {
      if (config?.overrideColor != null) {
        paint.color = config!.overrideColor!;
      }
      parent.drawRect(rect, paint);
    }
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    final config = rectConfig(rrect.outerRect);
    print(config?.treatAsBone);
    if (config?.treatAsBone == true) {
      parent.drawRRect(rrect, shaderPaint);
    } else {
      if (config?.overrideColor != null) {
        paint.color = config!.overrideColor!;
      }
      parent.drawRRect(rrect, paint);
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
  ) =>
      parent.drawRawAtlas(
        atlas,
        rstTransforms,
        rects,
        colors,
        blendMode,
        cullRect,
        paint,
      );

  @override
  void drawRawPoints(
    ui.PointMode pointMode,
    Float32List points,
    ui.Paint paint,
  ) =>
      parent.drawRawPoints(pointMode, points, paint);

  @override
  void drawShadow(
    ui.Path path,
    ui.Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    parent.drawShadow(path, color, elevation, transparentOccluder);
  }

  @override
  void drawVertices(
    ui.Vertices vertices,
    ui.BlendMode blendMode,
    ui.Paint paint,
  ) =>
      parent.drawVertices(vertices, blendMode, paint);

  @override
  int getSaveCount() => parent.getSaveCount();

  @override
  void restore() => parent.restore();

  @override
  void rotate(double radians) => parent.rotate(radians);

  @override
  void save() => parent.save();

  @override
  void saveLayer(ui.Rect? bounds, ui.Paint paint) => parent.saveLayer(bounds, paint);

  @override
  void scale(double sx, [double? sy]) => parent.scale(sx, sy);

  @override
  void skew(double sx, double sy) => parent.skew(sx, sy);

  @override
  void transform(Float64List matrix4) => parent.transform(matrix4);

  @override
  void translate(double dx, double dy) => parent.translate(dx, dy);

  @override
  ui.Rect getDestinationClipBounds() => parent.getDestinationClipBounds();

  @override
  ui.Rect getLocalClipBounds() => parent.getLocalClipBounds();

  @override
  Float64List getTransform() => parent.getTransform();

  @override
  void restoreToCount(int count) => parent.restoreToCount(count);
}

class SkeletonizerLayer extends ContainerLayer {
  @override
  void addToScene(ui.SceneBuilder builder) {
    super.addToScene(builder);
    addChildrenToScene(builder);
  }
}

class ActualPaintingContext extends PaintingContext {
  ActualPaintingContext(
    super.containerLayer,
    super.estimatedBounds,
    this.canvas,
  );

  @override
  final ui.Canvas canvas;
}

class RectConfig {
  final bool treatAsBone;
  final Color? overrideColor;

  const RectConfig({
    this.treatAsBone = false,
    this.overrideColor,
  });
}
