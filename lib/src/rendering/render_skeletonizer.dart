import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';

/// Builds a renderer object that overrides the painting operation
/// and provides a [SkeletonizerPaintingContext] to paint the skeleton effect
class RenderSkeletonizer extends RenderProxyBox
    with _RenderSkeletonBase<RenderBox> {
  /// Default constructor
  RenderSkeletonizer({
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    required SkeletonizerConfigData config,
    required bool ignorePointers,
    required bool isZone,
    RenderBox? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        _isZone = isZone,
        _ignorePointers = ignorePointers,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  Brightness _brightness;

  @override
  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
      markNeedsPaint();
    }
  }

  bool _isZone;

  set isZone(bool value) {
    if (_isZone != value) {
      _isZone = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isZone => _isZone;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_ignorePointers) return false;
    return super.hitTest(result, position: position);
  }
}

/// Creates a Zoned version of [RenderSkeletonizer] that only shades [Bone] widgets or descendants Skeletonizer widgets
class ZonedRenderSkeletonizer extends RenderSkeletonizer
    with _ZonedRenderSkeletonBase<RenderBox> {
  /// Default constructor
  ZonedRenderSkeletonizer({
    required super.textDirection,
    required super.animationValue,
    required super.brightness,
    required super.config,
    required super.ignorePointers,
    required super.isZone,
    required this.shouldRecreateShader,
  });

  /// Whether the shader paint should be recreated for the sub Skeletonizer widget
  @override
  final bool shouldRecreateShader;
}

/// Builds a sliver renderer object that overrides the painting operation
/// and provides a [SkeletonizerPaintingContext] to paint the skeleton effect
class RenderSliverSkeletonizer extends RenderProxySliver
    with _RenderSkeletonBase<RenderSliver> {
  /// Default constructor
  RenderSliverSkeletonizer({
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    required SkeletonizerConfigData config,
    required bool ignorePointers,
    required bool isZone,
    RenderSliver? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        _isZone = isZone,
        _ignorePointers = ignorePointers,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  Brightness _brightness;

  @override
  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
    }
  }

  bool _isZone;

  set isZone(bool value) {
    if (_isZone != value) {
      _isZone = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isZone => _isZone;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (_ignorePointers) return false;
    return super.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }
}

/// Creates a Zoned version of [RenderSliverSkeletonizer] that only shades [Bone] widgets or descendants Skeletonizer widgets
class ZonedSliverRenderSkeletonizer extends RenderSliverSkeletonizer
    with _ZonedRenderSkeletonBase<RenderSliver> {
  /// Default constructor
  ZonedSliverRenderSkeletonizer({
    required super.textDirection,
    required super.animationValue,
    required super.brightness,
    required super.config,
    required super.ignorePointers,
    required super.isZone,
    required this.shouldRecreateShader,
  });

  @override
  final bool shouldRecreateShader;
}

mixin _ZonedRenderSkeletonBase<R extends RenderObject>
    on _RenderSkeletonBase<R> {
  bool get shouldRecreateShader;

  @override
  SkeletonizerPaintingContext createSkeletonizerContext(
      PaintingContext context, Offset offset) {
    assert(context is SkeletonizerPaintingContext);
    final skeletonizerContext = context as SkeletonizerPaintingContext;
    final Paint shaderPaint;
    if (shouldRecreateShader) {
      shaderPaint = config.effect.createPaint(
        context.animationValue,
        context.estimatedBounds,
        textDirection,
      );
    } else {
      shaderPaint = skeletonizerContext.shaderPaint;
    }
    return SkeletonizerPaintingContext(
      layer: skeletonizerContext.layer,
      animationValue: animationValue,
      estimatedBounds: paintBounds.shift(offset),
      shaderPaint: shaderPaint,
      config: config,
      isZone: isZone,
    );
  }
}

mixin _RenderSkeletonBase<R extends RenderObject>
    on RenderObjectWithChildMixin<R> {
  /// The text direction used to resolve Directional geometries
  TextDirection get textDirection;

  /// The resolved skeletonizer theme data
  SkeletonizerConfigData get config;

  /// The selected brightness
  Brightness get brightness;

  /// The value to animate painting effects
  double get animationValue;

  /// if true, only [Bone] widgets will be shaded
  bool get isZone;

  @override
  bool get isRepaintBoundary => true;

  SkeletonizerPaintingContext createSkeletonizerContext(
    PaintingContext context,
    Offset offset,
  ) {
    final estimatedBounds = paintBounds.shift(offset);
    final shaderPaint = config.effect.createPaint(
      animationValue,
      estimatedBounds,
      textDirection,
    );
    return SkeletonizerPaintingContext(
      layer: layer!,
      animationValue: animationValue,
      estimatedBounds: estimatedBounds,
      shaderPaint: shaderPaint,
      config: config,
      isZone: isZone,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final skeletonizerContext = createSkeletonizerContext(context, offset);
    super.paint(skeletonizerContext, offset);
    skeletonizerContext.stopRecordingIfNeeded();
  }
}
