import 'package:flutter/material.dart';
import 'package:skeletonizer/src/effects/painting_effect_base.dart';
import 'package:skeletonizer/src/theme/skeletonizer_theme.dart';
import 'package:skeletonizer/src/widgets/skeletonizer_base.dart';

class Skeletonizer extends StatefulWidget {
  const Skeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
    this.effect,
  });

  final Widget child;
  final bool enabled;
  final PaintingEffect? effect;

  @override
  State<Skeletonizer> createState() => SkeletonizerState();

  static SkeletonizerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>();
  }

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
}

class SkeletonizerState extends State<Skeletonizer> with TickerProviderStateMixin<Skeletonizer> {
  AnimationController? _animationController;
  late bool _enabled = widget.enabled;

  bool get enabled => _enabled;

  PaintingEffect? _effect;
  SkeletonizerThemeData? _themeData;

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
    _themeData = SkeletonizerTheme.maybeOf(context) ??
        (isDarkMode ? const SkeletonizerThemeData.dark() : const SkeletonizerThemeData.light());
    final effect = widget.effect ?? _themeData!.effect;
    if (_effect != effect) {
      _effect = effect;
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
    if (widget.effect != oldWidget.effect) {
      _setupEffect();
    }
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
    assert(_effect != null);
    assert(_themeData != null);
    return SkeletonizerScope(
      enabled: _enabled,
      child: SkeletonizerBase(
        enabled: widget.enabled,
        effect: _effect!,
        themeData: _themeData!,
        brightness: _brightness,
        textDirection: _textDirection,
        animationValue: _animationController?.value ?? 0,
        child: widget.child,
      ),
    );
  }
}

class SkeletonizerScope extends InheritedWidget {
  const SkeletonizerScope({super.key, required super.child, required this.enabled});

  final bool enabled;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
