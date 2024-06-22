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
    required this.effect,
    required this.textBorderRadius,
    required this.justifyMultiLineText,
    required this.ignoreContainers,
    required this.containersColor,
    required this.enableSwitchAnimation,
    required this.switchAnimationConfig,
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
      enableSwitchAnimation:
          enableSwitchAnimation ?? this.enableSwitchAnimation,
      switchAnimationConfig:
          switchAnimationConfig ?? this.switchAnimationConfig,
    );
  }

  @override
  SkeletonizerConfigData lerp(SkeletonizerConfigData? other, double t) {
    if (other == null) return this;
    return SkeletonizerConfigData(
      effect: t < 0.5 ? effect : other.effect,
      textBorderRadius: t < 0.5 ? textBorderRadius : other.textBorderRadius,
      justifyMultiLineText:
          t < 0.5 ? justifyMultiLineText : other.justifyMultiLineText,
      ignoreContainers: t < 0.5 ? ignoreContainers : other.ignoreContainers,
      containersColor: t < 0.5 ? containersColor : other.containersColor,
      enableSwitchAnimation:
          t < 0.5 ? enableSwitchAnimation : other.enableSwitchAnimation,
      switchAnimationConfig:
          t < 0.5 ? switchAnimationConfig : other.switchAnimationConfig,
    );
  }
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

  /// Whether this is constructed using [fromHeightFactor]
  final bool usesHeightFactor;

  /// Builds TextBoneBorderRadius instance that
  /// uses default/fixed border radius
  const TextBoneBorderRadius(
    BorderRadiusGeometry borderRadius,
  )   : _borderRadius = borderRadius,
        _heightPercentage = null,
        usesHeightFactor = false;

  /// Builds TextBoneBorderRadius instance that
  /// uses a high factor to resolve used border radius
  const TextBoneBorderRadius.fromHeightFactor(
    double factor,
  )   : assert(factor >= 0 && factor <= 1),
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
          _heightPercentage == other._heightPercentage &&
          usesHeightFactor == other.usesHeightFactor;

  @override
  int get hashCode =>
      _borderRadius.hashCode ^
      _heightPercentage.hashCode ^
      usesHeightFactor.hashCode;
}

/// Provided the scoped [SkeletonizerConfigData] to descended widgets
class SkeletonizerConfig extends InheritedWidget {
  /// The Scoped config data
  final SkeletonizerConfigData data;

  /// Depends on the the nearest SkeletonizerConfigData if any
  static SkeletonizerConfigData? maybeOf(BuildContext context) {
    return Theme.of(context).extension<SkeletonizerConfigData>() ??
        skeletonizerConfigData;
  }

  /// Depends on the the nearest SkeletonizerConfigData if any otherwise it throws
  static SkeletonizerConfigData of(BuildContext context) {
    return Theme.of(context).extension<SkeletonizerConfigData>() ??
        skeletonizerConfigData;
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

  /// Default constructor
  const SwitchAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
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
          transitionBuilder == other.transitionBuilder;

  @override
  int get hashCode =>
      duration.hashCode ^
      switchInCurve.hashCode ^
      switchOutCurve.hashCode ^
      reverseDuration.hashCode ^
      transitionBuilder.hashCode;
}
