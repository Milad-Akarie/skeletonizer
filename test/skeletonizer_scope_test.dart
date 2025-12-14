import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/widgets/skeletonizer.dart';

void main() {
  group('SkeletonizerScope', () {
    testWidgets('updateShouldNotify returns true when enabled changes', (
      tester,
    ) async {
      await tester.pumpWidget(
        const SkeletonizerScope(
          enabled: true,
          config: SkeletonizerConfigData(),
          isInsideZone: false,
          isZone: false,
          animationController: null,
          child: SizedBox(),
        ),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      final scope = context
          .dependOnInheritedWidgetOfExactType<SkeletonizerScope>();

      final newScope = SkeletonizerScope(
        enabled: false,
        config: const SkeletonizerConfigData(),
        isInsideZone: false,
        isZone: false,
        animationController: null,
        child: const SizedBox(),
      );

      expect(newScope.updateShouldNotify(scope!), isTrue);
    });

    testWidgets('updateShouldNotify returns true when config changes', (
      tester,
    ) async {
      final config1 = const SkeletonizerConfigData(containersColor: Colors.red);
      await tester.pumpWidget(
        SkeletonizerScope(
          enabled: true,
          config: config1,
          isInsideZone: false,
          isZone: false,
          animationController: null,
          child: const SizedBox(),
        ),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      final scope = context
          .dependOnInheritedWidgetOfExactType<SkeletonizerScope>();

      final config2 = const SkeletonizerConfigData(
        containersColor: Colors.blue,
      );
      final newScope = SkeletonizerScope(
        enabled: true,
        config: config2,
        isInsideZone: false,
        isZone: false,
        animationController: null,
        child: const SizedBox(),
      );

      expect(newScope.updateShouldNotify(scope!), isTrue);
    });

    // Add more tests for other properties...
  });

  group('SkeletonizerBuildData', () {
    test('equality and hashCode', () {
      final data1 = const SkeletonizerBuildData(
        enabled: true,
        config: SkeletonizerConfigData(),
        textDirection: TextDirection.ltr,
        animationValue: 0.5,
        ignorePointers: true,
        isZone: false,
        animationController: null,
        isInsideZone: false,
      );

      final data2 = const SkeletonizerBuildData(
        enabled: true,
        config: SkeletonizerConfigData(),
        textDirection: TextDirection.ltr,
        animationValue: 0.5,
        ignorePointers: true,
        isZone: false,
        animationController: null,
        isInsideZone: false,
      );

      final data3 = const SkeletonizerBuildData(
        enabled: false,
        config: SkeletonizerConfigData(),
        textDirection: TextDirection.ltr,
        animationValue: 0.5,
        ignorePointers: true,
        isZone: false,
        animationController: null,
        isInsideZone: false,
      );

      expect(data1, data2);
      expect(data1.hashCode, data2.hashCode);
      expect(data1, isNot(data3));
    });
  });

  group('Skeletonizer.of', () {
    testWidgets('throws FlutterError when no Skeletonizer found', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => Skeletonizer.of(context), throwsFlutterError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('returns scope when found', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            child: Builder(
              builder: (context) {
                expect(Skeletonizer.of(context), isNotNull);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
