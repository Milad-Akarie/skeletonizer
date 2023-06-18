import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';
import 'package:skeletonizer/src/skeletonizer_config.dart';
import 'package:skeletonizer/src/widgets/skeletonizer_base.dart';

/// Paints a skeleton of the [child] widget
///
/// if [enabled] is set the false the child
/// will be painted normally
class Skeletonizer extends StatefulWidget {
  /// The widget to be skeletonized
  final Widget child;

  /// Whether skeletonizing is enabled
  final bool enabled;

  /// The painting effect to apply
  /// on the skeletonized elements
  final PaintingEffect? effect;

  /// The [TextElement] border radius config
  final TextBoneBorderRadius? textBoneBorderRadius;

  /// Whether to ignore container elements and only paint
  /// the dependents
  final bool? ignoreContainers;

  /// Whether to justify multi line text bones
  final bool? justifyMultiLineText;

  /// Default constructor
  const Skeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
  });

  @override
  State<Skeletonizer> createState() => SkeletonizerState();

  /// Depends on the the nearest SkeletonizerScope if any
  static SkeletonizerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>();
  }

  /// Depends on the the nearest SkeletonizerScope if any otherwise it throws
  static SkeletonizerScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>();
    assert(() {
      if (scope == null) {
        throw FlutterError(
          'Skeletonizer operation requested with a context that does not include a Skeletonizer.\n'
          'The context used to push or pop routes from the Navigator must be that of a '
          'widget that is a descendant of a Skeletonizer widget.',
        );
      }
      return true;
    }());
    return scope!;
  }
}

/// The state of [Skeletonizer] widget
class SkeletonizerState extends State<Skeletonizer>
    with TickerProviderStateMixin<Skeletonizer> {
  AnimationController? _animationController;
  late bool _enabled = widget.enabled;

  SkeletonizerConfigData? _config;

  PaintingEffect? get _effect => _config?.effect;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupEffect();
  }

  Brightness _brightness = Brightness.light;
  TextDirection _textDirection = TextDirection.ltr;

  void _setupEffect() {
    _brightness = Theme.of(context).brightness;
    _textDirection = Directionality.of(context);
    final isDarkMode = _brightness == Brightness.dark;
    var config = SkeletonizerConfig.maybeOf(context) ??
        (isDarkMode
            ? const SkeletonizerConfigData.dark()
            : const SkeletonizerConfigData.light());
    config = config.copyWith(
      effect: widget.effect,
      textBorderRadius: widget.textBoneBorderRadius,
      ignoreContainers: widget.ignoreContainers,
      justifyMultiLineText: widget.justifyMultiLineText,
    );
    if (config != _config) {
      _config = config;
      _stopAnimation();
      if (widget.enabled) {
        _startAnimation();
      }
    }
  }

  void _stopAnimation() {
    _animationController
      ?..removeListener(_onShimmerChange)
      ..stop(canceled: true)
      ..dispose();
    _animationController = null;
  }

  void _startAnimation() {
    assert(_effect != null);
    if (_effect!.duration.inMilliseconds != 0) {
      _animationController = AnimationController.unbounded(vsync: this)
        ..addListener(_onShimmerChange)
        ..repeat(
          reverse: _effect!.reverse,
          min: _effect!.lowerBound,
          max: _effect!.upperBound,
          period: _effect!.duration,
        );
    }
  }

  @override
  void didUpdateWidget(covariant Skeletonizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _enabled = widget.enabled;
      if (!_enabled) {
        _animationController?.reset();
        _animationController?.stop(canceled: true);
      } else {
        _startAnimation();
      }
    }
    _setupEffect();
  }

  @override
  void dispose() {
    _animationController?.removeListener(_onShimmerChange);
    _animationController?.dispose();
    super.dispose();
  }

  void _onShimmerChange() {
    if (mounted && widget.enabled) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(_config != null);
    return SkeletonizerScope(
      enabled: _enabled,
      child: SkeletonizerBase(
        enabled: widget.enabled,
        config: _config!,
        brightness: _brightness,
        textDirection: _textDirection,
        animationValue: _animationController?.value ?? 0,
        child: widget.child,
      ),
    );
  }
}

/// Provides the skeletonizer activation information
/// to the descent widgets
class SkeletonizerScope extends InheritedWidget {
  /// Default constructor
  const SkeletonizerScope(
      {super.key, required super.child, required this.enabled});

  /// Whether skeletonizing is enabled
  final bool enabled;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
