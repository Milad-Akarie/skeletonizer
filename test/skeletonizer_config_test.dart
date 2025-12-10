import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('SkeletonizerConfigData', () {
    test('default constructor creates instance with default values', () {
      const config = SkeletonizerConfigData();

      expect(config.effect, isA<ShimmerEffect>());
      expect(config.justifyMultiLineText, isTrue);
      expect(config.ignoreContainers, isFalse);
      expect(config.containersColor, isNull);
      expect(config.enableSwitchAnimation, isFalse);
    });

    test('dark constructor creates instance with dark theme colors', () {
      const config = SkeletonizerConfigData.dark();

      expect(config.effect, isA<ShimmerEffect>());
      expect(config.justifyMultiLineText, isTrue);
      expect(config.ignoreContainers, isFalse);
    });

    test('copyWith creates a copy with updated values', () {
      const original = SkeletonizerConfigData();
      const newEffect = PulseEffect();

      final copy = original.copyWith(
        effect: newEffect,
        justifyMultiLineText: false,
        ignoreContainers: true,
        containersColor: Colors.red,
        enableSwitchAnimation: true,
      );

      expect(copy.effect, equals(newEffect));
      expect(copy.justifyMultiLineText, isFalse);
      expect(copy.ignoreContainers, isTrue);
      expect(copy.containersColor, equals(Colors.red));
      expect(copy.enableSwitchAnimation, isTrue);
    });

    test('copyWith preserves original values when not specified', () {
      const original = SkeletonizerConfigData(
        justifyMultiLineText: false,
        ignoreContainers: true,
      );

      final copy = original.copyWith(containersColor: Colors.blue);

      expect(copy.justifyMultiLineText, isFalse);
      expect(copy.ignoreContainers, isTrue);
      expect(copy.containersColor, equals(Colors.blue));
    });

    test('lerp interpolates between two configs', () {
      const config1 = SkeletonizerConfigData(
        justifyMultiLineText: true,
        ignoreContainers: false,
      );
      const config2 = SkeletonizerConfigData(
        justifyMultiLineText: false,
        ignoreContainers: true,
      );

      // At t=0.5, the boolean values switch based on t < 0.5 condition
      final lerpedAt0 = config1.lerp(config2, 0.0);
      expect(lerpedAt0.justifyMultiLineText, isTrue);
      expect(lerpedAt0.ignoreContainers, isFalse);

      final lerpedAt1 = config1.lerp(config2, 1.0);
      expect(lerpedAt1.justifyMultiLineText, isFalse);
      expect(lerpedAt1.ignoreContainers, isTrue);
    });

    test('lerp returns this when other is null', () {
      const config = SkeletonizerConfigData();
      final lerped = config.lerp(null, 0.5);

      expect(lerped, equals(config));
    });

    test('equality works correctly', () {
      const config1 = SkeletonizerConfigData();
      const config2 = SkeletonizerConfigData();
      const config3 = SkeletonizerConfigData(justifyMultiLineText: false);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('hashCode is consistent with equality', () {
      const config1 = SkeletonizerConfigData();
      const config2 = SkeletonizerConfigData();

      expect(config1.hashCode, equals(config2.hashCode));
    });
  });

  group('TextBoneBorderRadius', () {
    test('constructor with fixed border radius', () {
      final borderRadius = TextBoneBorderRadius(BorderRadius.circular(8));

      expect(borderRadius.borderRadius, equals(BorderRadius.circular(8)));
      expect(borderRadius.usesHeightFactor, isFalse);
      expect(borderRadius.heightPercentage, isNull);
    });

    test('fromHeightFactor constructor', () {
      const borderRadius = TextBoneBorderRadius.fromHeightFactor(0.5);

      expect(borderRadius.heightPercentage, equals(0.5));
      expect(borderRadius.usesHeightFactor, isTrue);
      expect(borderRadius.borderRadius, isNull);
    });

    test('fromHeightFactor with different border shapes', () {
      const roundedRect = TextBoneBorderRadius.fromHeightFactor(
        0.5,
        borderShape: TextBoneBorderShape.roundedRectangle,
      );
      const superellipse = TextBoneBorderRadius.fromHeightFactor(
        0.5,
        borderShape: TextBoneBorderShape.roundedSuperellipse,
      );

      expect(roundedRect.borderShape, TextBoneBorderShape.roundedRectangle);
      expect(superellipse.borderShape, TextBoneBorderShape.roundedSuperellipse);
    });

    test('lerp between two height factor based border radii', () {
      const br1 = TextBoneBorderRadius.fromHeightFactor(0.2);
      const br2 = TextBoneBorderRadius.fromHeightFactor(0.8);

      final lerped = br1.lerp(br2, 0.5);

      expect(lerped.usesHeightFactor, isTrue);
      expect(lerped.heightPercentage, closeTo(0.5, 0.01));
    });

    test('lerp between two fixed border radii', () {
      final br1 = TextBoneBorderRadius(BorderRadius.circular(4));
      final br2 = TextBoneBorderRadius(BorderRadius.circular(12));

      final lerped = br1.lerp(br2, 0.5);

      expect(lerped.usesHeightFactor, isFalse);
      expect(lerped.borderRadius, equals(BorderRadius.circular(8)));
    });

    test('lerp returns this when other is null', () {
      const br = TextBoneBorderRadius.fromHeightFactor(0.5);
      final lerped = br.lerp(null, 0.5);

      expect(lerped, equals(br));
    });

    test('lerp returns this when mixing height factor and fixed', () {
      const br1 = TextBoneBorderRadius.fromHeightFactor(0.5);
      final br2 = TextBoneBorderRadius(BorderRadius.circular(8));

      final lerped = br1.lerp(br2, 0.5);

      expect(lerped, equals(br1));
    });

    test('equality works correctly', () {
      const br1 = TextBoneBorderRadius.fromHeightFactor(0.5);
      const br2 = TextBoneBorderRadius.fromHeightFactor(0.5);
      const br3 = TextBoneBorderRadius.fromHeightFactor(0.3);

      expect(br1, equals(br2));
      expect(br1, isNot(equals(br3)));
    });

    test('hashCode is consistent with equality', () {
      const br1 = TextBoneBorderRadius.fromHeightFactor(0.5);
      const br2 = TextBoneBorderRadius.fromHeightFactor(0.5);

      expect(br1.hashCode, equals(br2.hashCode));
    });
  });

  group('SwitchAnimationConfig', () {
    test('default constructor creates instance with default values', () {
      const config = SwitchAnimationConfig();

      expect(config.duration, equals(const Duration(milliseconds: 300)));
      expect(config.switchInCurve, equals(Curves.linear));
      expect(config.switchOutCurve, equals(Curves.linear));
      expect(config.reverseDuration, isNull);
    });

    test('custom values are set correctly', () {
      const config = SwitchAnimationConfig(
        duration: Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        reverseDuration: Duration(milliseconds: 250),
      );

      expect(config.duration, equals(const Duration(milliseconds: 500)));
      expect(config.switchInCurve, equals(Curves.easeIn));
      expect(config.switchOutCurve, equals(Curves.easeOut));
      expect(config.reverseDuration, equals(const Duration(milliseconds: 250)));
    });

    test('equality works correctly', () {
      const config1 = SwitchAnimationConfig();
      const config2 = SwitchAnimationConfig();
      const config3 = SwitchAnimationConfig(
        duration: Duration(milliseconds: 500),
      );

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('hashCode is consistent with equality', () {
      const config1 = SwitchAnimationConfig();
      const config2 = SwitchAnimationConfig();

      expect(config1.hashCode, equals(config2.hashCode));
    });
  });

  group('SkeletonizerConfig widget', () {
    testWidgets('provides config data to descendants', (tester) async {
      const configData = SkeletonizerConfigData(
        justifyMultiLineText: false,
      );

      SkeletonizerConfigData? retrievedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: configData,
            child: Builder(
              builder: (context) {
                retrievedConfig = SkeletonizerConfig.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(retrievedConfig, equals(configData));
    });

    testWidgets('maybeOf returns null when no config is present', (tester) async {
      SkeletonizerConfigData? retrievedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              retrievedConfig = SkeletonizerConfig.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrievedConfig, isNull);
    });

    testWidgets('updateShouldNotify returns true when data changes', (tester) async {
      const configData1 = SkeletonizerConfigData();
      const configData2 = SkeletonizerConfigData(justifyMultiLineText: false);

      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: configData1,
            child: Builder(
              builder: (context) {
                SkeletonizerConfig.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, equals(1));

      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: configData2,
            child: Builder(
              builder: (context) {
                SkeletonizerConfig.maybeOf(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, equals(2));
    });
  });
}
