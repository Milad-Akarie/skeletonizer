import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/widgets/skeletonizer_base.dart';

class Skeletonizer extends StatefulWidget {
  const Skeletonizer({
    super.key,
    required this.child,
    required this.loading,
  });

  final Widget child;
  final bool loading;

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
  AnimationController? _shimmerController;
  late bool _loading = widget.loading;

  bool get loading => _loading;

  LinearGradient get shimmerGradient => LinearGradient(
        colors: false
            ? [Colors.red, Colors.blue, Colors.red]
            : const [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
        stops: const [0.1, 0.3, 0.4],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        transform: _SlidingGradientTransform(slidePercent: _shimmerController?.value ?? 0),
      );

  @override
  void initState() {
    super.initState();
    if(loading) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    // return;
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..addListener(_onShimmerChange)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 2000),
      );
  }


  @override
  void didUpdateWidget(covariant Skeletonizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loading != widget.loading) {
      _loading = widget.loading;
      if (!_loading) {
        _shimmerController?.stop(canceled: true);
        _shimmerController?.dispose();
      } else {
        _startAnimation();
      }
    }
  }

  @override
  void dispose() {
    _shimmerController?.removeListener(_onShimmerChange);
    _shimmerController?.dispose();
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.loading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonizerScope(
      state: this,
      child: SkeletonizerBase(
        loading: widget.loading,
        shimmer: shimmerGradient,
        child: widget.child,
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class SkeletonizerScope extends InheritedWidget {
  const SkeletonizerScope({super.key, required super.child, required this.state});

  final SkeletonizerState state;

  @override
  bool updateShouldNotify(covariant SkeletonizerScope oldWidget) {
    return state.loading != oldWidget.state.loading || state.shimmerGradient != oldWidget.state.shimmerGradient;
  }
}
