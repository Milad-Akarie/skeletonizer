import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _defaultTextBoneBorderRadius = TextBoneBorderRadius.fromHeightFactor(.5);

/// The immutable configuration data for the skeletonizer theme.
@immutable
class SkeletonizerConfigData extends ThemeExtension<SkeletonizerConfigData> {
  /// Constructs a [SkeletonizerConfigData] instance with the given properties.
  ///
  /// - [effect]: The painting effect to apply on the skeletonized elements.
  /// - [textBorderRadius]: The border radius configuration for text elements.
  /// - [justifyMultiLineText]: Whether to justify multi-line text bones.
  /// - [ignoreContainers]: Whether to ignore container elements and only paint the dependents.
  /// - [containersColor]: The color of the container elements. If null, the actual color will be used.
  /// - [enableSwitchAnimation]: Whether to enable switch animation between the skeleton and the actual widget.
  /// - [switchAnimationConfig]: The configuration for the switch animation.
  const SkeletonizerConfigData({
    this.effect = const ShimmerEffect(),
    this.textBorderRadius = _defaultTextBoneBorderRadius,
    this.justifyMultiLineText = true,
    this.ignoreContainers = false,
    this.containersColor,
    this.enableSwitchAnimation = false,
    this.switchAnimationConfig = const SwitchAnimationConfig(),
  });

  /// Constructs a [SkeletonizerConfigData] instance with the given properties for light theme.
  @Deprecated('use the default constructor instead')
  const factory SkeletonizerConfigData.light({
    PaintingEffect effect,
    TextBoneBorderRadius textBorderRadius,
    bool justifyMultiLineText,
    bool ignoreContainers,
    Color? containersColor,
    bool enableSwitchAnimation,
    SwitchAnimationConfig switchAnimationConfig,
  }) = SkeletonizerConfigData;

  /// Constructs a [SkeletonizerConfigData] instance with the given properties for dark theme.
  const SkeletonizerConfigData.dark({
    this.effect = const ShimmerEffect(
      baseColor: Color(0xFF3A3A3A),
      highlightColor: Color(0xFF424242),
    ),
    this.textBorderRadius = _defaultTextBoneBorderRadius,
    this.justifyMultiLineText = true,
    this.ignoreContainers = false,
    this.containersColor,
    this.enableSwitchAnimation = false,
    this.switchAnimationConfig = const SwitchAnimationConfig(),
  });

  /// The painting effect to apply
  /// on the skeletonized elements
  final PaintingEffect effect;

  /// The [TextElement] border radius config
  final TextBoneBorderRadius textBorderRadius;

  /// Whether to justify multi line text bones
  final bool justifyMultiLineText;

  /// Whether to ignore container elements and only paint
  /// the dependents
  final bool ignoreContainers;

  /// The color of the container elements
  /// this includes [Container], [Card], [DecoratedBox] ..etc
  ///
  /// if null the actual color will be used
  final Color? containersColor;

  /// Whether to enable switch animation
  ///
  /// This will animate the switch between the skeleton and the actual widget
  final bool enableSwitchAnimation;

  /// The switch animation config
  ///
  /// This will be used if [enableSwitchAnimation] is true
  final SwitchAnimationConfig switchAnimationConfig;

  @override
  SkeletonizerConfigData copyWith({
    PaintingEffect? effect,
    TextBoneBorderRadius? textBorderRadius,
    bool? justifyMultiLineText,
    bool? ignoreContainers,
    Color? containersColor,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) {
    return SkeletonizerConfigData(
      effect: effect ?? this.effect,
      textBorderRadius: textBorderRadius ?? this.textBorderRadius,
      justifyMultiLineText: justifyMultiLineText ?? this.justifyMultiLineText,
      ignoreContainers: ignoreContainers ?? this.ignoreContainers,
      containersColor: containersColor ?? this.containersColor,
      enableSwitchAnimation: enableSwitchAnimation ?? this.enableSwitchAnimation,
      switchAnimationConfig: switchAnimationConfig ?? this.switchAnimationConfig,
    );
  }

  @override
  SkeletonizerConfigData lerp(SkeletonizerConfigData? other, double t) {
    if (other == null) return this;
    return SkeletonizerConfigData(
      effect: effect.lerp(other.effect, t),
      textBorderRadius: textBorderRadius.lerp(other.textBorderRadius, t),
      justifyMultiLineText: t < 0.5 ? justifyMultiLineText : other.justifyMultiLineText,
      ignoreContainers: t < 0.5 ? ignoreContainers : other.ignoreContainers,
      containersColor: t < 0.5 ? containersColor : other.containersColor,
      enableSwitchAnimation: t < 0.5 ? enableSwitchAnimation : other.enableSwitchAnimation,
      switchAnimationConfig: t < 0.5 ? switchAnimationConfig : other.switchAnimationConfig,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkeletonizerConfigData &&
          runtimeType == other.runtimeType &&
          effect == other.effect &&
          textBorderRadius == other.textBorderRadius &&
          justifyMultiLineText == other.justifyMultiLineText &&
          ignoreContainers == other.ignoreContainers &&
          containersColor == other.containersColor &&
          enableSwitchAnimation == other.enableSwitchAnimation &&
          switchAnimationConfig == other.switchAnimationConfig;

  @override
  int get hashCode => Object.hash(
    effect,
    textBorderRadius,
    justifyMultiLineText,
    ignoreContainers,
    containersColor,
    enableSwitchAnimation,
    switchAnimationConfig,
  );
}

/// Singleton instance for skeletonizer theme configurations.
const SkeletonizerConfigData skeletonizerConfigData = SkeletonizerConfigData(
  effect: ShimmerEffect(),
  textBorderRadius: _defaultTextBoneBorderRadius,
  justifyMultiLineText: true,
  ignoreContainers: false,
  containersColor: null,
  enableSwitchAnimation: false,
  switchAnimationConfig: SwitchAnimationConfig(),
);

/// Holds border radius information
/// for [TextElement]
class TextBoneBorderRadius {
  final BorderRadiusGeometry? _borderRadius;
  final double? _heightPercentage;

  /// The shape of the border
  final TextBoneBorderShape borderShape;

  /// Whether this is constructed using [fromHeightFactor]
  final bool usesHeightFactor;

  /// Builds TextBoneBorderRadius instance that
  /// uses default/fixed border radius
  const TextBoneBorderRadius(
    BorderRadiusGeometry borderRadius, {
    this.borderShape = TextBoneBorderShape.roundedRectangle,
  }) : _borderRadius = borderRadius,
       _heightPercentage = null,
       usesHeightFactor = false;

  /// Builds TextBoneBorderRadius instance that
  /// uses a high factor to resolve used border radius
  const TextBoneBorderRadius.fromHeightFactor(
    double factor, {
    this.borderShape = TextBoneBorderShape.roundedRectangle,
  }) : assert(factor >= 0 && factor <= 1),
       _borderRadius = null,
       _heightPercentage = factor,
       usesHeightFactor = true;

  /// This defines the value of border radius
  /// based on the font size e.g
  /// fontSize: 14
  /// heightPercentage: .5
  /// border radius =>  14 * .5 = 7
  double? get heightPercentage => _heightPercentage;

  /// The fixed border radius
  BorderRadiusGeometry? get borderRadius => _borderRadius;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextBoneBorderRadius &&
          runtimeType == other.runtimeType &&
          _borderRadius == other._borderRadius &&
          borderShape == other.borderShape &&
          _heightPercentage == other._heightPercentage &&
          usesHeightFactor == other.usesHeightFactor;

  @override
  int get hashCode =>
      _borderRadius.hashCode ^ _heightPercentage.hashCode ^ usesHeightFactor.hashCode ^ borderShape.hashCode;

  /// Linearly interpolate between two [TextBoneBorderRadius]
  TextBoneBorderRadius lerp(TextBoneBorderRadius? other, double t) {
    if (other == null) return this;
    if (usesHeightFactor && other.usesHeightFactor) {
      return TextBoneBorderRadius.fromHeightFactor(
        lerpDouble(_heightPercentage!, other._heightPercentage!, t)!,
        borderShape: borderShape == other.borderShape ? borderShape : other.borderShape,
      );
    } else if (!usesHeightFactor && !other.usesHeightFactor) {
      return TextBoneBorderRadius(
        BorderRadiusGeometry.lerp(_borderRadius, other._borderRadius, t)!,
        borderShape: borderShape == other.borderShape ? borderShape : other.borderShape,
      );
    } else {
      return this;
    }
  }
}

/// Enum to define the type of border for text bones
enum TextBoneBorderShape {
  /// Rectangular border shape
  roundedRectangle,

  /// Superellipse border shape
  roundedSuperellipse,
}

/// Provided the scoped [SkeletonizerConfigData] to descended widgets
class SkeletonizerConfig extends InheritedTheme {
  /// The Scoped config data
  final SkeletonizerConfigData data;

  /// The [SkeletonizerConfigData] instance of the closest ancestor Theme.extension
  /// if exists, otherwise null.
  static SkeletonizerConfigData? maybeOf(BuildContext context) {
    final SkeletonizerConfig? inherited = context.dependOnInheritedWidgetOfExactType<SkeletonizerConfig>();
    return inherited?.data ?? Theme.of(context).extension<SkeletonizerConfigData>();
  }

  /// The [SkeletonizerConfigData] instance of the closest ancestor Theme.extension
  /// if not found it will throw an exception
  static SkeletonizerConfigData of(BuildContext context) {
    final SkeletonizerConfig? inherited = context.dependOnInheritedWidgetOfExactType<SkeletonizerConfig>();
    late final fromThemeExtension = Theme.of(context).extension<SkeletonizerConfigData>();
    assert(() {
      if (inherited == null && fromThemeExtension == null) {
        throw FlutterError(
          'SkeletonizerConfig.of() called with a context that does not contain a SkeletonizerConfigData.\n'
          'try wrapping the context with SkeletonizerConfig widget or provide the data using Theme.extension',
        );
      }
      return true;
    }());
    return inherited?.data ?? fromThemeExtension!;
  }

  /// Default constructor
  const SkeletonizerConfig({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(covariant SkeletonizerConfig oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return SkeletonizerConfig(data: data, child: child);
  }
}

/// Holds the configuration for the switch animation
class SwitchAnimationConfig {
  /// The duration of the switch animation
  final Duration duration;

  /// The curve of the switch in animation
  final Curve switchInCurve;

  /// The curve of the switch out animation
  final Curve switchOutCurve;

  /// The duration of the reverse switch animation
  final Duration? reverseDuration;

  /// The transition builder
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// The layout builder
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  /// Default constructor
  const SwitchAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.reverseDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwitchAnimationConfig &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          switchInCurve == other.switchInCurve &&
          switchOutCurve == other.switchOutCurve &&
          reverseDuration == other.reverseDuration &&
          transitionBuilder == other.transitionBuilder &&
          layoutBuilder == other.layoutBuilder;

  @override
  int get hashCode =>
      duration.hashCode ^
      switchInCurve.hashCode ^
      switchOutCurve.hashCode ^
      reverseDuration.hashCode ^
      transitionBuilder.hashCode ^
      layoutBuilder.hashCode;
}
