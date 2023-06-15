import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _defaultTextBoneBorderRadius = TextBoneBorderRadius.fromHeightFactor(.5);

class SkeletonizerThemeData {
  final PaintingEffect effect;
  final TextBoneBorderRadius textBorderRadius;
  final bool justifyMultiLineText;

  const SkeletonizerThemeData({
    this.effect = const ShimmerEffect(),
    this.justifyMultiLineText = true,
    this.textBorderRadius = _defaultTextBoneBorderRadius,
  });

  const SkeletonizerThemeData.light({
    this.effect = const ShimmerEffect(),
    this.justifyMultiLineText = true,
    this.textBorderRadius = _defaultTextBoneBorderRadius,
  });

  const SkeletonizerThemeData.dark({
    this.effect = const ShimmerEffect(
      baseColor: Color(0xFF3A3A3A),
      highlightColor: Color(0xFF424242),
    ),
    this.justifyMultiLineText = true,
    this.textBorderRadius = _defaultTextBoneBorderRadius,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkeletonizerThemeData &&
          runtimeType == other.runtimeType &&
          effect == other.effect &&
          justifyMultiLineText == other.justifyMultiLineText &&
          textBorderRadius == other.textBorderRadius;

  @override
  int get hashCode => effect.hashCode ^ textBorderRadius.hashCode ^ justifyMultiLineText.hashCode;
}

class TextBoneBorderRadius {
  final BorderRadiusGeometry? _borderRadius;
  final double? _heightPercentage;
  final bool usesHeightFactor;

  const TextBoneBorderRadius(
    BorderRadiusGeometry borderRadius,
  )   : _borderRadius = borderRadius,
        _heightPercentage = null,
        usesHeightFactor = false;

  const TextBoneBorderRadius.fromHeightFactor(
    double factor,
  )   : assert(factor >= 0 && factor <= 1),
        _borderRadius = null,
        _heightPercentage = factor,
        usesHeightFactor = true;

  double? get heightPercentage => _heightPercentage;

  BorderRadiusGeometry? get borderRadius => _borderRadius;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextBoneBorderRadius &&
          runtimeType == other.runtimeType &&
          _borderRadius == other._borderRadius &&
          _heightPercentage == other._heightPercentage &&
          usesHeightFactor == other.usesHeightFactor;

  @override
  int get hashCode => _borderRadius.hashCode ^ _heightPercentage.hashCode ^ usesHeightFactor.hashCode;
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
