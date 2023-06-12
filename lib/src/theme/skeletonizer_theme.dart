import 'package:flutter/cupertino.dart';
import 'package:skeleton_builder/skeleton_builder.dart';

class SkeletonizerThemeData {
  final PaintingEffect effect;
  final Duration duration;

  const SkeletonizerThemeData.light({
    this.effect = const ShimmerEffect(),
    this.duration = const Duration(milliseconds: 2000),
  });

  const SkeletonizerThemeData.dark({
    this.effect = const ShimmerEffect(
      baseColor: Color(0xFF3A3A3A),
      highlightColor: Color(0xFF424242),
    ),
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkeletonizerThemeData && runtimeType == other.runtimeType && effect == other.effect;

  @override
  int get hashCode => effect.hashCode;
}

class SkeletonizerTheme extends InheritedWidget {
  final SkeletonizerThemeData data;

  static SkeletonizerThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonizerTheme>()?.data;
  }

  static SkeletonizerThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SkeletonizerTheme>();
    assert(() {
      if (scope == null) {
        throw FlutterError(
          'SkeletonizerTheme operation requested with a context that does not include a SkeletonizerTheme.\n'
          'The context used to push or pop routes from the Navigator must be that of a '
          'widget that is a descendant of a SkeletonizerTheme widget.',
        );
      }
      return true;
    }());
    return scope!.data;
  }

  const SkeletonizerTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(covariant SkeletonizerTheme oldWidget) {
    return data != oldWidget.data;
  }
}
