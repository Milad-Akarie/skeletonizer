import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/effects/painting_effect_base.dart';
import 'package:skeleton_builder/src/theme/skeletonizer_theme.dart';
import 'package:skeleton_builder/src/widgets/skeletonizer_base.dart';

class Skeletonizer extends StatefulWidget {
  const Skeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
    this.duration,
    this.effect,
  });

  final Widget child;
  final bool enabled;
  final PaintingEffect? effect;
  final Duration? duration;

  @override
  State<Skeletonizer> createState() => SkeletonizerState();

  static SkeletonizerState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonizerScope>()?.state;
  }

  static SkeletonizerState of(BuildContext context) {
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
    return scope!.state;
  }
}

class SkeletonizerState extends State<Skeletonizer> with TickerProviderStateMixin<Skeletonizer> {
  AnimationController? _animationController;
  late bool _enabled = widget.enabled;

  bool get enabled => _enabled;

  PaintingEffect? _effect;
  Duration? _duration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupEffect();
  }

  Brightness _brightness = Brightness.light;
  TextDirection _textDirection = TextDirection.rtl;

  void _setupEffect() {
     _brightness = Theme.of(context).brightness;
    _textDirection = Directionality.of(context);
    final isDarkMode = _brightness == Brightness.dark;
    final themeData = SkeletonizerTheme.maybeOf(context) ??
        (isDarkMode ? const SkeletonizerThemeData.dark() : const SkeletonizerThemeData.light());
    final effect = widget.effect ?? themeData.effect;
    final duration = widget.duration ?? themeData.duration;
    if (_effect != effect || _duration != duration) {
      _effect = effect;
      _duration = duration;
      _stopAnimation();
      if (widget.enabled) {
        _startAnimation();
      }
    }
  }

  void _stopAnimation() {
    _animationController?.removeListener(_onShimmerChange);
    _animationController?.stop(canceled: true);
  }

  @override
  void initState() {
    super.initState();
    // if (enabled) {
    //   _startAnimation();
    // }
  }

  void _startAnimation() {
    assert(_effect != null);
    assert(_duration != null);
    // return;
    _animationController = AnimationController.unbounded(vsync: this)
      ..addListener(_onShimmerChange)
      ..repeat(
        min: _effect!.lowerBound,
        max: _effect!.upperBound,
        reverse: _effect!.reverse,
        period: _duration,
      );
  }

  @override
  void didUpdateWidget(covariant Skeletonizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _enabled = widget.enabled;
      if (!_enabled) {
        _animationController?.stop(canceled: true);
        _animationController?.dispose();
      } else {
        _startAnimation();
      }
    }
    if (widget.effect != oldWidget.effect || widget.duration != oldWidget.duration) {
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
    return SkeletonizerScope(
      state: this,
      child: SkeletonizerBase(
        enabled: widget.enabled,
        effect: _effect!,
        brightness: _brightness,
        textDirection: _textDirection,
        animationValue: _animationController?.value ?? 0,
        child: widget.child,
      ),
    );
  }
}

class SkeletonizerScope extends InheritedWidget {
  const SkeletonizerScope({super.key, required super.child, required this.state});

  final SkeletonizerState state;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return state.enabled != oldWidget.state.enabled;
  }
}
