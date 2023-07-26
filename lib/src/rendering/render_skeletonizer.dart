import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';

/// Builds a renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
class RenderSkeletonizer extends RenderProxyBox with _RenderSkeletonBase<RenderBox> {
  /// Default constructor
  RenderSkeletonizer({
    required bool enabled,
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    RenderBox? child,
    required SkeletonizerConfigData config,
  })  : _animationValue = animationValue,
        _enabled = enabled,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
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

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      markNeedsPaint();
    }
  }

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
    return !_enabled && super.hitTest(result, position: position);
  }
}

/// Builds a sliver renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
class RenderSliverSkeletonizer extends RenderProxySliver with _RenderSkeletonBase<RenderSliver> {
  /// Default constructor
  RenderSliverSkeletonizer({
    required bool enabled,
    required TextDirection textDirection,
    required double animationValue,
    required Brightness brightness,
    RenderSliver? child,
    required SkeletonizerConfigData config,
  })  : _animationValue = animationValue,
        _enabled = enabled,
        _textDirection = textDirection,
        _brightness = brightness,
        _config = config,
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

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      markNeedsPaint();
    }
  }

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
  bool hitTest(SliverHitTestResult result, {required double mainAxisPosition, required double crossAxisPosition}) {
    if (_enabled) return false;
    return super.hitTest(result, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
  }
}

/// Builds a renderer object that overrides the painting operation
/// by stripping the original renderers to a list of [PaintableElement]
mixin _RenderSkeletonBase<R extends RenderObject> on RenderObjectWithChildMixin<R> {
  /// The text direction used to resolve Directional geometries
  TextDirection get textDirection;

  /// The resolved skeletonizer theme data
  SkeletonizerConfigData get config;

  /// The selected brightness
  Brightness get brightness;

  /// Whether the skeletonizer is enabled
  bool get enabled;

  /// The value to animate painting effects
  double get animationValue;

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!enabled) {
      return super.paint(context, offset);
    }
    final paint = config.effect.createPaint(animationValue, offset & paintBounds.size);
    final skeletonizerContext = SkeletonizerPaintingContext(
      layer: layer!,
      estimatedBounds: paintBounds,
      parentCanvas: context.canvas,
      shaderPaint: paint,
      rootOffset: offset,
      config: config,
    );
    super.paint(skeletonizerContext, offset);
  }
}
