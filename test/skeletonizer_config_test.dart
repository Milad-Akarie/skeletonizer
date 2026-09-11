import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('SkeletonizerConfigData', () {
    test('stores and copies the bone resolver', () {
      final resolver = _TestBoneResolver();
      final config = SkeletonizerConfigData(boneResolver: resolver);
      final copy = config.copyWith();

      expect(config.boneResolver, same(resolver));
      expect(copy.boneResolver, same(resolver));
    });

    test('stores and copies brightness', () {
      const config = SkeletonizerConfigData(brightness: Brightness.dark);
      final copy = config.copyWith();

      expect(config.brightness, Brightness.dark);
      expect(copy.brightness, Brightness.dark);
    });

    test('default constructor creates instance with default values', () {
      const config = SkeletonizerConfigData();

      expect(config.justifyMultiLineText, isTrue);
      expect(config.ignoreContainers, isFalse);
      expect(config.containersColor, isNull);
      expect(config.boneResolver, isNull);
      expect(config.brightness, isNull);
      expect(config.enableSwitchAnimation, isFalse);
    });

    test('resolveEffect resolves the painting effect for a brightness', () {
      const config = SkeletonizerConfigData();

      expect(config.resolveEffect(Brightness.light), isA<ShimmerEffect>());
      expect(config.resolveEffect(Brightness.dark), isA<ShimmerEffect>());
    });

    test('a deprecated effect overrides the effect resolver', () {
      // ignore: deprecated_member_use_from_same_package
      const config = SkeletonizerConfigData(effect: PulseEffect());

      expect(
        config.resolveEffect(Brightness.light),
        equals(const PulseEffect()),
      );
      expect(
        config.resolveEffect(Brightness.dark),
        equals(const PulseEffect()),
      );
    });

    test('effectResolver resolves the painting effect', () {
      const config = SkeletonizerConfigData(
        effectResolver: _solidColorEffectResolver,
      );

      expect(config.resolveEffect(Brightness.light), isA<SolidColorEffect>());
      expect(config.resolveEffect(Brightness.dark), isA<SolidColorEffect>());
    });

    test('copyWith creates a copy with updated values', () {
      const original = SkeletonizerConfigData();

      final copy = original.copyWith(
        justifyMultiLineText: false,
        ignoreContainers: true,
        containersColor: Colors.red,
        brightness: Brightness.dark,
        enableSwitchAnimation: true,
      );

      expect(copy.justifyMultiLineText, isFalse);
      expect(copy.ignoreContainers, isTrue);
      expect(copy.containersColor, equals(Colors.red));
      expect(copy.brightness, Brightness.dark);
      expect(copy.enableSwitchAnimation, isTrue);
    });

    test('copyWith replaces the deprecated effect', () {
      // ignore: deprecated_member_use_from_same_package
      const original = SkeletonizerConfigData(effect: PulseEffect());

      // ignore: deprecated_member_use_from_same_package
      final copy = original.copyWith(effect: const SolidColorEffect());

      expect(copy.resolveEffect(Brightness.dark), equals(const SolidColorEffect()));
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

    testWidgets('maybeOf returns null when no config is present', (
      tester,
    ) async {
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

    testWidgets('updateShouldNotify returns true when data changes', (
      tester,
    ) async {
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

  group('Additional coverage for SkeletonizerConfig', () {
    test('const constructor accepts the deprecated effect parameter', () {
      // ignore: deprecated_member_use_from_same_package
      const config = SkeletonizerConfigData(
        effect: ShimmerEffect(),
        textBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.5),
        justifyMultiLineText: true,
        ignoreContainers: false,
        containersColor: null,
        enableSwitchAnimation: false,
        switchAnimationConfig: SwitchAnimationConfig(),
      );
      expect(config.resolveEffect(Brightness.dark), isA<ShimmerEffect>());
      expect(config, isA<SkeletonizerConfigData>());
    });

    testWidgets('SkeletonizerConfig.of throws when no config is present', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                () => SkeletonizerConfig.of(context),
                throwsA(isA<FlutterError>()),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('SkeletonizerConfig.wrap returns a new widget', (tester) async {
      final key = GlobalKey();
      const configData = SkeletonizerConfigData();
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            key: key,
            data: configData,
            child: const SizedBox(),
          ),
        ),
      );
      final context = key.currentContext;
      expect(context, isNotNull);
      final config = context!.widget as SkeletonizerConfig;
      final wrapped = config.wrap(context, const SizedBox());
      expect(wrapped, isA<SkeletonizerConfig>());
    });

    test('TextBoneBorderRadius with different border shapes', () {
      const br1 = TextBoneBorderRadius.fromHeightFactor(
        0.5,
        borderShape: TextBoneBorderShape.roundedRectangle,
      );
      const br2 = TextBoneBorderRadius.fromHeightFactor(
        0.5,
        borderShape: TextBoneBorderShape.roundedSuperellipse,
      );
      expect(br1.borderShape, isNot(br2.borderShape));
    });

    test(
      'SwitchAnimationConfig with custom transition and layout builders',
      () {
        final config = SwitchAnimationConfig(
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          layoutBuilder:
              (currentChild, previousChildren) => Stack(
                children: [
                  if (currentChild != null) currentChild,
                  ...previousChildren,
                ],
              ),
        );
        expect(config.transitionBuilder, isNotNull);
        expect(config.layoutBuilder, isNotNull);
      },
    );
  });
}

PaintingEffect _solidColorEffectResolver(Brightness brightness) => const SolidColorEffect();

class _TestBoneResolver implements BoneResolver {
  @override
  BoneButtonSpec resolveButton(BuildContext context, BoneButtonType type) {
    return BoneButtonSpec(shape: const RoundedRectangleBorder());
  }

  @override
  BoneIconButtonSpec resolveIconButton(BuildContext context, BoneButtonType type) {
    return const BoneIconButtonSpec(iconSize: 24.0, padding: EdgeInsets.all(8));
  }
}
