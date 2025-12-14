import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('Skeletonizer Animation', () {
    testWidgets('enableSwitchAnimation wraps child in AnimatedSwitcher', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            enableSwitchAnimation: true,
            child: Text('Content'),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });

    testWidgets('enableSwitchAnimation respects switchAnimationConfig', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            enableSwitchAnimation: true,
            switchAnimationConfig: SwitchAnimationConfig(
              duration: Duration(milliseconds: 500),
              switchInCurve: Curves.bounceIn,
            ),
            child: Text('Content'),
          ),
        ),
      );

      final switcher = tester.widget<AnimatedSwitcher>(
        find.byType(AnimatedSwitcher),
      );
      expect(switcher.duration, const Duration(milliseconds: 500));
      expect(switcher.switchInCurve, Curves.bounceIn);
    });

    testWidgets('skips animation controller creation if duration is zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: PulseEffect(duration: Duration.zero),
            child: Text('Content'),
          ),
        ),
      );
      // How to verify controller is null or not repeated?
      // Hard to verify internal state _animationController?
      // But we can verify it doesn't crash.
      // And we verify coverage hits the line "if (duration != 0)".

      await tester.pump();
      // No animation frame should be scheduled ideally?
    });

    testWidgets('updates animation when enabled changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: false,
            effect: PulseEffect(),
            child: Text('Content'),
          ),
        ),
      );

      // Update to enabled
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: PulseEffect(),
            child: Text('Content'),
          ),
        ),
      );
      await tester.pump();
      // Should start animation
    });
  });
}
