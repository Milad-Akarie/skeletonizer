import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('Skeletonizer Widget', () {
    testWidgets('renders child when enabled is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: false,
            child: Text('Visible'),
          ),
        ),
      );
      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('renders skeleton when enabled is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SoldColorEffect(),
            child: const Text('Skeletonized'),
          ),
        ),
      );
      expect(find.text('Skeletonized'), findsOneWidget);
      expect(find.byKey(const ValueKey('skeletonizer')), findsOneWidget);
    });

    testWidgets('applies custom effect and border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SoldColorEffect(color: Colors.red),
            textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(8)),
            child: const Text('Custom'),
          ),
        ),
      );
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('handles null/empty child gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SoldColorEffect(),
            child: const SizedBox.shrink(),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('toggles skeleton state rapidly', (tester) async {
      bool enabled = true;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Skeletonizer(
                enabled: enabled,
                effect: SoldColorEffect(),
                child: Text(enabled ? 'Skeleton' : 'Normal'),
              ),
            );
          },
        ),
      );
      expect(find.text('Skeleton'), findsOneWidget);
      // Toggle state
      enabled = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Skeletonizer(
                enabled: enabled,
                effect: SoldColorEffect(),
                child: Text(enabled ? 'Skeleton' : 'Normal'),
              ),
            );
          },
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('ignores pointer events when ignorePointers is true', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SoldColorEffect(),
            ignorePointers: true,
            child: GestureDetector(
              onTap: () => tapped = true,
              child: const Text('Tap me'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tap me'), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('allows pointer events when ignorePointers is false', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SoldColorEffect(),
            ignorePointers: false,
            child: GestureDetector(
              onTap: () => tapped = true,
              child: const Text('Tap me'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
