import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/utils.dart';

/// A painting context that draws a skeleton of of widgets
/// that draw information on the canvas like Text, Icons, Images ..etc
class SkeletonizerPaintingContext extends PaintingContext {
  /// Default constructor
  SkeletonizerPaintingContext({
    required this.layer,
    required Rect estimatedBounds,
    required this.shaderPaint,
    required this.config,
    required this.manual,
  }) : super(layer, estimatedBounds);

  /// The [SkeletonizerConfigData] that controls the skeletonization process
  final SkeletonizerConfigData config;

  /// Whether the skeletonization is manual
  final bool manual;

  /// The layer of the context
  final ContainerLayer layer;

  /// The [Paint] that is used to draw the skeleton
  final Paint shaderPaint;

  late final _treatedAsLeaf = <Offset, bool>{};

  /// Creates a default child painting context
  void createDefaultContext(Rect rect, Painter paint) {
    final context = PaintingContext(layer, rect);
    paint(context, rect.topLeft);
    context.stopRecordingIfNeeded();
  }

  /// Creates a child [LeafPaintingContext]
  void createLeafContext(Rect rect, Painter painter) {
    final context = LeafPaintingContext(
      layer: layer,
      shaderPaint: shaderPaint,
      config: config,
      estimatedBounds: rect,
    );
    painter(context, rect.topLeft);
    context.stopRecordingIfNeeded();
  }

  bool _didPaint = false;

  @override
  ui.Canvas get canvas => manual ? super.canvas : SkeletonizerCanvas(super.canvas, this);

  @override
  PaintingContext createChildContext(ContainerLayer childLayer, ui.Rect bounds) {
    return SkeletonizerPaintingContext(
      layer: childLayer,
      estimatedBounds: bounds,
      shaderPaint: shaderPaint,
      config: config,
      manual: manual,
    );
  }

  @override
  void stopRecordingIfNeeded() {
    super.stopRecordingIfNeeded();
    _didPaint = false;
    _treatedAsLeaf.clear();
  }

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (!manual && child is RenderObjectWithChildMixin) {
      final key = child.paintBounds.shift(offset).center;
      final subChild = child.child;
      var treatAaLeaf = subChild == null || (subChild is RenderIgnoredSkeleton && subChild.enabled);
      if (child is RenderSemanticsAnnotations) {
        treatAaLeaf |= child.properties.button == true;
      }
      _treatedAsLeaf[key] = treatAaLeaf;
    }
    child.paint(this, offset);
  }
}

/// A [Canvas] that draws a skeleton that represents the actual content
class SkeletonizerCanvas implements Canvas {
  /// Default constructor
  SkeletonizerCanvas(this.parent, this.context);

  /// The [SkeletonizerPaintingContext] that controls the skeletonization process
  final SkeletonizerPaintingContext context;

  Paint get _shaderPaint => context.shaderPaint;

  SkeletonizerConfigData get _config => context.config;

  /// The parent [Canvas] that handles drawing operations
  final Canvas parent;

  /// Draws a rectangle on the canvas where the [paragraph]
  /// would otherwise be rendered
  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    context._didPaint = true;
    final lines = paragraph.computeLineMetrics();

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      /// approximating the font size
      final fontSize = line.ascent - line.descent;

      /// approximating the font descent
      final fontDescent = line.ascent >= line.height ? 0 : fontSize * .2;

      final lineStart = line.left.round();
      final lineEnd = (line.left + line.width).round();
      final isNotCentered = lineStart == 0 || lineEnd == paragraph.width;
      final shouldJustify =
          _config.justifyMultiLineText && isNotCentered && (lines.length > 1 && i < (lines.length - 1));
      final width = shouldJustify ? paragraph.width : line.width;
      final rect = Rect.fromLTWH(
        shouldJustify ? offset.dx : line.left + offset.dx,
        offset.dy + line.baseline - fontSize,
        width,
        fontSize + fontDescent,
      );
      final borderRadius = _config.textBorderRadius.usesHeightFactor
          ? BorderRadius.circular((fontSize + fontDescent) * _config.textBorderRadius.heightPercentage!)
          : _config.textBorderRadius.borderRadius?.resolve(TextDirection.ltr);
      if (borderRadius != null) {
        parent.drawRRect(borderRadius.toRRect(rect), _shaderPaint);
      } else {
        parent.drawRect(rect, _shaderPaint);
      }
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
  void drawColor(ui.Color color, ui.BlendMode blendMode) {
    context._didPaint = true;
    parent.drawColor(color, blendMode);
  }

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) {
    if (paint.color.opacity == 0) return;
    context._didPaint = true;
    final treatAsBone = context._treatedAsLeaf[outer.center] ?? false;
    if (treatAsBone) {
      parent.drawDRRect(
        outer,
        inner,
        paint.copyWith(
          shader: _shaderPaint.shader,
        ),
      );
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawDRRect(
          outer,
          inner,
          paint.copyWith(
            color: _config.containersColor!,
          ),
        );
      } else {
        parent.drawDRRect(outer, inner, paint);
      }
    }
  }

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    context._didPaint = true;
    parent.drawRect(
      (offset & Size(image.width.toDouble(), image.height.toDouble())),
      _shaderPaint,
    );
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRect(dst, _shaderPaint);
  }

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRect(dst, _shaderPaint);
  }

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) {
    context._didPaint = true;
    parent.drawLine(p1, p2, paint);
  }

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) {
    context._didPaint = true;
    parent.drawOval(rect, paint);
  }

  @override
  void drawPaint(ui.Paint paint) {
    context._didPaint = true;
    parent.drawPaint(paint);
  }

  @override
  void drawPicture(ui.Picture picture) {
    context._didPaint = true;
    parent.drawPicture(picture);
  }

  @override
  void drawPoints(
    ui.PointMode pointMode,
    List<ui.Offset> points,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawPoints(pointMode, points, paint);
  }

  @override
  void drawPath(ui.Path path, ui.Paint paint) {
    if (paint.color.opacity == 0) return;
    context._didPaint = true;
    final treatAsBone = context._treatedAsLeaf[path.getBounds().center] ?? false;

    if (treatAsBone) {
      parent.drawPath(path, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawPath(path, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawPath(path, paint);
      }
    }
  }

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    if (paint.color.opacity == 0) return;
    context._didPaint = true;
    final treatAsBone = context._treatedAsLeaf[rect.center] ?? false;
    if (treatAsBone) {
      parent.drawRect(rect, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawRect(rect, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawRect(rect, paint);
      }
    }
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    if (paint.color.opacity == 0) return;
    context._didPaint = true;
    final treatAsBone = context._treatedAsLeaf[rrect.center] ?? false;
    if (treatAsBone) {
      parent.drawRRect(rrect, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawRRect(rrect, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawRRect(rrect, paint);
      }
    }
  }

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    if (paint.color.opacity == 0) return;
    context._didPaint = true;
    final treatAsBone = context._treatedAsLeaf[c] ?? false;
    if (treatAsBone) {
      parent.drawCircle(c, radius, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawCircle(c, radius, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawCircle(c, radius, paint);
      }
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
  ) {
    context._didPaint = true;
    parent.drawRawAtlas(
      atlas,
      rstTransforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawRawPoints(
    ui.PointMode pointMode,
    Float32List points,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRawPoints(pointMode, points, _shaderPaint);
  }

  @override
  void drawShadow(
    ui.Path path,
    ui.Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    if (!_config.ignoreContainers) {
      context._didPaint = true;
      parent.drawShadow(path, color, elevation, transparentOccluder);
    }
  }

  @override
  void drawVertices(
    ui.Vertices vertices,
    ui.BlendMode blendMode,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawVertices(vertices, blendMode, _shaderPaint);
  }

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

/// A [PaintingContext] that marks all children as leafs
/// and stops painting after first paintable child
class LeafPaintingContext extends SkeletonizerPaintingContext {
  /// Default constructor
  LeafPaintingContext({
    required super.layer,
    required super.estimatedBounds,
    required super.shaderPaint,
    required super.config,
  }) : super(manual: false);

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (!_didPaint) {
      _treatedAsLeaf[child.paintBounds.shift(offset).center] = true;
      child.paint(this, offset);
    }
  }
}
