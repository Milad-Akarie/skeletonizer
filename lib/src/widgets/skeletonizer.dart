import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect.dart';
import 'package:skeletonizer/src/skeletonizer_config.dart';
import 'package:skeletonizer/src/widgets/skeletonizer_render_object_widget.dart';

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

  /// The color of the container elements
  /// this includes [Container], [Card], [DecoratedBox] ..etc
  ///
  /// if null the actual color will be used
  final Color? containersColor;

  /// Whether to ignore pointer events
  ///
  /// defaults to true
  final bool ignorePointers;

  final bool _manual;

  /// Default constructor
  const Skeletonizer._({
    super.key,
    required this.child,
    this.enabled = true,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
    this.containersColor,
    this.ignorePointers = true,
  }) : _manual = false;

  /// Creates a Skeletonizer widget that only shades [Bone] widgets
  const Skeletonizer._fromBones({
    super.key,
    required this.child,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
    this.containersColor,
    this.ignorePointers = true,
  })  : _manual = true,
        enabled = true;

  /// Creates a [Skeletonizer] widget
  const factory Skeletonizer({
    Key? key,
    required Widget child,
    bool enabled,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool ignorePointers,
  }) = _Skeletonizer;

  /// Creates a Skeletonizer widget that only shades [Bone] widgets
  const factory Skeletonizer.bones({
    Key? key,
    required Widget child,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool ignorePointers,
  }) = _Skeletonizer.bones;

  /// Creates a [SliverSkeletonizer] widget
  const factory Skeletonizer.sliver({
    Key? key,
    required Widget child,
    bool enabled,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool ignorePointers,
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
      containersColor: widget.containersColor,
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
          ignorePointers: widget.ignorePointers,
          manual: widget._manual,
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
    super.containersColor,
    super.ignorePointers,
  }) : super._();

  const _Skeletonizer.bones({
    required super.child,
    super.key,
    super.effect,
    super.textBoneBorderRadius,
    super.ignoreContainers,
    super.justifyMultiLineText,
    super.containersColor,
    super.ignorePointers,
  }) : super._fromBones();

  @override
  Widget build(BuildContext context, SkeletonizerBuildData data) {
    return SkeletonizerScope(
      enabled: data.enabled,
      config: data.config,
      child: data.enabled ? SkeletonizerRenderObjectWidget(data: data, child: child) : child,
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
    super.containersColor,
    super.ignorePointers,
  }) : super._();

  /// Creates a Skeletonizer widget that only shades [Bone] widgets
  const SliverSkeletonizer.bones({
    required super.child,
    super.key,
    super.effect,
    super.textBoneBorderRadius,
    super.ignoreContainers,
    super.justifyMultiLineText,
    super.containersColor,
    super.ignorePointers,
  }) : super._fromBones();

  @override
  Widget build(BuildContext context, SkeletonizerBuildData data) {
    return SkeletonizerScope(
      enabled: data.enabled,
      config: data.config,
      child: data.enabled ? SliverSkeletonizerRenderObjectWidget(data: data, child: child) : child,
    );
  }
}

/// The data that is passed to the [SkeletonizerRenderObjectWidget]
class SkeletonizerBuildData {
  /// Default constructor
  const SkeletonizerBuildData({
    required this.enabled,
    required this.config,
    required this.brightness,
    required this.textDirection,
    required this.animationValue,
    required this.ignorePointers,
    required this.manual,
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

  /// Whether to ignore pointer events
  ///
  /// defaults to true
  final bool ignorePointers;

  /// When true, the only [Bone] widgets will be shaded
  final bool manual;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkeletonizerBuildData &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          config == other.config &&
          brightness == other.brightness &&
          manual == other.manual &&
          textDirection == other.textDirection &&
          animationValue == other.animationValue &&
          ignorePointers == other.ignorePointers;

  @override
  int get hashCode =>
      enabled.hashCode ^
      config.hashCode ^
      brightness.hashCode ^
      textDirection.hashCode ^
      animationValue.hashCode ^
      manual.hashCode ^
      ignorePointers.hashCode;
}

/// Provides the skeletonizer activation information
/// to the descent widgets
class SkeletonizerScope extends InheritedWidget {
  /// Default constructor
  const SkeletonizerScope({
    super.key,
    required super.child,
    required this.enabled,
    required this.config,
  });

  /// Whether skeletonizing is enabled
  final bool enabled;

  /// The current skeletonizer configuration
  final SkeletonizerConfigData config;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return enabled != oldWidget.enabled || config != oldWidget.config;
  }
}
