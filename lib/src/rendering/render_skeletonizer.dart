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
    required bool manual,
    RenderBox? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        _manual = manual,
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

  bool _manual;

  set manual(bool value) {
    if (_manual != value) {
      _manual = value;
      markNeedsPaint();
    }
  }

  @override
  bool get manual => _manual;

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
    required bool manual,
    RenderSliver? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
        _manual = manual,
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

  bool _manual;

  set manual(bool value) {
    if (_manual != value) {
      _manual = value;
      markNeedsPaint();
    }
  }

  @override
  bool get manual => _manual;

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
  bool get manual;

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final estimatedBounds = paintBounds.shift(offset);
    final shaderPaint = config.effect.createPaint(
      animationValue,
      estimatedBounds,
      textDirection,
    );
    final skeletonizerContext = SkeletonizerPaintingContext(
      layer: layer!,
      estimatedBounds: estimatedBounds,
      shaderPaint: shaderPaint,
      config: config,
      manual: manual,
    );
    super.paint(skeletonizerContext, offset);
    skeletonizerContext.stopRecordingIfNeeded();
  }
}
