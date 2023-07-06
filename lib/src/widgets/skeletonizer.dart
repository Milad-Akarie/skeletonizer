import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';
import 'package:skeletonizer/src/skeletonizer_config.dart';
import 'package:skeletonizer/src/widgets/skeletonizer_base.dart';

/// Paints a skeleton of the [child] widget
///
/// if [enabled] is set the false the child
/// will be painted normally
abstract class Skeletonizer extends StatefulWidget {
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
  const Skeletonizer._({
    super.key,
    required this.child,
    this.enabled = true,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
  });

  /// Creates a [Skeletonizer] widget
  const factory Skeletonizer({
    Key? key,
    required Widget child,
    bool enabled,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
  }) = _Skeletonizer;


  /// Creates a [SliverSkeletonizer] widget
  const factory Skeletonizer.sliver({
    Key? key,
    required Widget child,
    bool enabled,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
  }) = SliverSkeletonizer;


  @override
  State<Skeletonizer> createState() => SkeletonizerState();

  /// Depends on the the nearest SkeletonizerScope if any
  static SkeletonizerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>();
  }

  /// Depends on the the nearest SkeletonizerScope if any otherwise it throws
  static SkeletonizerScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>();
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

  /// Delegates the build to the [SkeletonizerState]
  Widget build(BuildContext context, SkeletonizerBuildData data);
}

/// The state of [Skeletonizer] widget
class SkeletonizerState extends State<Skeletonizer> with TickerProviderStateMixin<Skeletonizer> {
  AnimationController? _animationController;

  late bool _enabled = widget.enabled;

  SkeletonizerConfigData? _config;

  double get _animationValue => _animationController?.value ?? 0.0;

  PaintingEffect? get _effect => _config?.effect;

  Brightness _brightness = Brightness.light;
  TextDirection _textDirection = TextDirection.ltr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupEffect();
  }

  void _setupEffect() {
    _brightness = Theme.of(context).brightness;
    _textDirection = Directionality.of(context);
    final isDarkMode = _brightness == Brightness.dark;
    var resolvedConfig = SkeletonizerConfig.maybeOf(context) ??
        (isDarkMode ? const SkeletonizerConfigData.dark() : const SkeletonizerConfigData.light());

    resolvedConfig = resolvedConfig.copyWith(
      effect: widget.effect,
      textBorderRadius: widget.textBoneBorderRadius,
      ignoreContainers: widget.ignoreContainers,
      justifyMultiLineText: widget.justifyMultiLineText,
    );
    if (resolvedConfig != _config) {
      _config = resolvedConfig;
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
  Widget build(BuildContext context) => widget.build(
        context,
        SkeletonizerBuildData(
          enabled: _enabled,
          config: _config!,
          brightness: _brightness,
          textDirection: _textDirection,
          animationValue: _animationValue,
        ),
      );
}

class _Skeletonizer extends Skeletonizer {
  const _Skeletonizer({
    required super.child,
    super.key,
    super.enabled = true,
    super.effect,
    super.textBoneBorderRadius,
    super.ignoreContainers,
    super.justifyMultiLineText,
  }) : super._();

  @override
  Widget build(BuildContext context, SkeletonizerBuildData data) {
    return SkeletonizerScope(
      enabled: data.enabled,
      child: SkeletonizerBase(
        enabled: data.enabled,
        config: data.config,
        brightness: data.brightness,
        textDirection: data.textDirection,
        animationValue: data.animationValue,
        child: child,
      ),
    );
  }
}

/// A [Skeletonizer] widget that can be used in a [CustomScrollView]
class SliverSkeletonizer extends Skeletonizer {
  /// Creates a [SliverSkeletonizer] widget
  const SliverSkeletonizer({
    required super.child,
    super.key,
    super.enabled = true,
    super.effect,
    super.textBoneBorderRadius,
    super.ignoreContainers,
    super.justifyMultiLineText,
  }) : super._();

  @override
  Widget build(BuildContext context, SkeletonizerBuildData data) {
    return SkeletonizerScope(
      enabled: data.enabled,
      child: SliverSkeletonizerBase(
        enabled: data.enabled,
        config: data.config,
        brightness: data.brightness,
        textDirection: data.textDirection,
        animationValue: data.animationValue,
        child: child,
      ),
    );
  }
}

/// The data that is passed to the [SkeletonizerBase]
class SkeletonizerBuildData {
  /// Default constructor
  const SkeletonizerBuildData({
    required this.enabled,
    required this.config,
    required this.brightness,
    required this.textDirection,
    required this.animationValue,
  });

  /// Whether skeletonizing is enabled
  final bool enabled;
  /// The skeletonizer configuration
  final SkeletonizerConfigData config;
  /// The brightness of the theme
  final Brightness brightness;
  /// The text direction of the theme
  final TextDirection textDirection;
  /// The animation value
  final double animationValue;
}

/// Provides the skeletonizer activation information
/// to the descent widgets
class SkeletonizerScope extends InheritedWidget {
  /// Default constructor
  const SkeletonizerScope({super.key, required super.child, required this.enabled});

  /// Whether skeletonizing is enabled
  final bool enabled;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
