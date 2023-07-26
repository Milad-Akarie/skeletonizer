import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/utils.dart';

class SkeletonizerPaintingContext extends PaintingContext {
  SkeletonizerPaintingContext({
    required this.layer,
    required Rect estimatedBounds,
    required this.parentCanvas,
    required this.shaderPaint,
    required this.rootOffset,
    required this.config,
  }) : super(layer, estimatedBounds);

  final SkeletonizerConfigData config;
  final ContainerLayer layer;
  final ui.Canvas parentCanvas;
  final Paint shaderPaint;
  final Offset rootOffset;
  final _treatedAsBone = <Offset, bool>{};

  Rect get maskRect => estimatedBounds.shift(rootOffset);

  ActualPaintingContext createActualContext(Rect estimatedBounds) {
    return ActualPaintingContext(
      layer,
      estimatedBounds,
      parentCanvas,
    );
  }

  TextDirection? textDirection;

  @override
  ui.Canvas get canvas => SkeletonizerCanvas(
        parentCanvas,
        shaderPaint: shaderPaint,
        config: config,
        shouldTreatAsBone: (center) {
          return _treatedAsBone[center] ?? false;
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
      config: config,
    );
  }

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (child is RenderObjectWithChildMixin) {
      final subChild = child.child;
      final treatAsBone = subChild == null || subChild is RenderIgnoredSkeleton;
      _treatedAsBone[child.paintBounds.shift(offset).center] = treatAsBone;
    }

    return child.paint(this, offset);
  }
}

class SkeletonizerCanvas implements Canvas {
  SkeletonizerCanvas(
    this.parent, {
    required this.shaderPaint,
    required this.shouldTreatAsBone,
    required this.config,
  });

  final Paint shaderPaint;

  final SkeletonizerConfigData config;

  /// The parent [Canvas] that handles drawing operations
  final Canvas parent;

  bool Function(Offset center) shouldTreatAsBone;

  /// Draws a rectangle on the canvas where the [paragraph]
  /// would otherwise be rendered
  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    final lines = paragraph.computeLineMetrics();
    final box = paragraph.getBoxesForRange(0, 1).first;

    final height = box.bottom - box.top;
    var yOffset = offset.dy;
    print(height);

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final shouldJustify = config.justifyMultiLineText && (lines.length > 1 && i < (lines.length - 1));
      final width = shouldJustify ? paragraph.width : line.width;
      final rect = Rect.fromLTWH(
        shouldJustify ? offset.dx : line.left + offset.dx,
        yOffset + line.descent,
        width,
        height,
      );

      final borderRadius = config.textBorderRadius.usesHeightFactor
          ? BorderRadius.circular(height / 2)
          : config.textBorderRadius.borderRadius;
      if (borderRadius != null) {
        parent.drawRRect(rect.toRRect(borderRadius.resolve(null)), shaderPaint);
      } else {
        parent.drawRect(rect, shaderPaint);
      }
      yOffset += line.height;
    }
    parent.drawParagraph(paragraph, offset);
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
  void drawColor(ui.Color color, ui.BlendMode blendMode) => parent.drawColor(color, blendMode);

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) => parent.drawDRRect(outer, inner, shaderPaint);

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    parent.drawRect(
      (offset & Size(image.width.toDouble(), image.height.toDouble())),
      shaderPaint,
    );
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    parent.drawRect(dst, shaderPaint);
  }

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) =>
      parent.drawRect(dst, shaderPaint);

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) => parent.drawLine(p1, p2, paint);

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) => parent.drawOval(rect, paint);

  @override
  void drawPaint(ui.Paint paint) => parent.drawPaint(paint);

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
  void drawPath(ui.Path path, ui.Paint paint) {
    final treatAsBone = shouldTreatAsBone(path.getBounds().center);
    if (treatAsBone) {
      parent.drawPath(path, shaderPaint);
    } else if (!config.ignoreContainers) {
      final effectivePaint = Paint()..color = paint.color;
      if (config.containersColor != null && paint.color.opacity != 0) {
        effectivePaint.color = config.containersColor!;
      }
      parent.drawPath(path, effectivePaint);
    }
  }

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    final treatAsBone = shouldTreatAsBone(rect.center);
    if (treatAsBone) {
      parent.drawRect(rect, shaderPaint);
    } else if (!config.ignoreContainers) {
      final effectivePaint = Paint()..color = paint.color;
      if (config.containersColor != null && paint.color.opacity != 0) {
        effectivePaint.color = config.containersColor!;
      }
      parent.drawRect(rect, effectivePaint);
    }
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    final treatAsBone = shouldTreatAsBone(rrect.center);
    if (treatAsBone) {
      parent.drawRRect(rrect, shaderPaint);
    } else if (!config.ignoreContainers) {
      final effectivePaint = Paint()..color = paint.color;
      if (config.containersColor != null && paint.color.opacity != 0) {
        effectivePaint.color = config.containersColor!;
      }
      parent.drawRRect(rrect, effectivePaint);
    }
  }

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    final treatAsBone = shouldTreatAsBone(c);
    if (treatAsBone) {
      parent.drawCircle(c, radius, shaderPaint);
    } else if (!config.ignoreContainers) {
      final effectivePaint = Paint()..color = paint.color;
      if (config.containersColor != null && paint.color.opacity != 0) {
        effectivePaint.color = config.containersColor!;
      }
      parent.drawCircle(c, radius, effectivePaint);
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
    if (!config.ignoreContainers) {
      parent.drawShadow(path, color, elevation, transparentOccluder);
    }
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
