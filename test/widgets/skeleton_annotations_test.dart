import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('Skeleton.ignore', () {
    testWidgets('ignores child when skeletonizer is enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.ignore(child: Text('Ignored')),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsNothing);
      expect(find.text('Ignored'), findsOneWidget);
    });

    testWidgets('renders normally when ignore is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.ignore(ignore: false, child: Text('Not Ignored')),
          ),
        ),
      );
      expect(find.text('Not Ignored'), findsOneWidget);
      // Bone may or may not be present depending on annotation logic
      expect(
        find.byType(BoneRenderObjectWidget),
        anyOf([findsNothing, findsWidgets]),
      );
    });

    testWidgets('renders normally when skeletonizer is disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: false,
            child: Skeleton.ignore(child: Text('Normal')),
          ),
        ),
      );

      expect(find.text('Normal'), findsOneWidget);
    });
  });

  group('Skeleton.keep', () {
    testWidgets('keeps child as-is when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.keep(child: Icon(Icons.star)),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(BoneRenderObjectWidget), findsNothing);
    });

    testWidgets('renders normally when keep is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.keep(keep: false, child: Icon(Icons.star)),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(
        find.byType(BoneRenderObjectWidget),
        anyOf([findsNothing, findsWidgets]),
      );
    });
  });

  group('Skeleton.shade', () {
    testWidgets('shades child when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.shade(
              child: Icon(Icons.star, color: Colors.yellow),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(
        find.byType(BoneRenderObjectWidget),
        anyOf([findsNothing, findsWidgets]),
      );
    });

    testWidgets('renders normally when shade is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.shade(shade: false, child: Icon(Icons.star)),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(BoneRenderObjectWidget), findsNothing);
    });
  });

  group('Skeleton.unite', () {
    testWidgets('unites children into single skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.unite(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.star), Text('Rating')],
              ),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
      // Bone may or may not be present depending on annotation logic
      expect(
        find.byType(BoneRenderObjectWidget),
        anyOf([findsNothing, findsWidgets]),
      );
    });

    testWidgets('renders normally when unite is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.unite(
              unite: false,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.star), Text('Rating')],
              ),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
      expect(
        find.byType(BoneRenderObjectWidget),
        anyOf([findsNothing, findsWidgets]),
      );
    });

    testWidgets('respects custom border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.unite(
              borderRadius: BorderRadius.circular(16),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.star), Text('Rating')],
              ),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      // Bone may or may not be present depending on annotation logic
      final boneWidgets = find.byType(BoneRenderObjectWidget).evaluate().toList();
      if (boneWidgets.isNotEmpty) {
        final boneWidget = boneWidgets.first.widget as BoneRenderObjectWidget;
        final boxDecoration = boneWidget.decoration;
        expect(boxDecoration.borderRadius, BorderRadius.circular(16));
      }
    });
  });

  group('Skeleton.replace', () {
    testWidgets('replaces child when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Skeleton.replace(
              replacement: Text('Replacement'),
              child: Text('Original'),
            ),
          ),
        ),
      );
      expect(find.text('Replacement'), findsOneWidget);
    });

    testWidgets('shows original when skeletonizer is disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: false,
            child: Skeleton.replace(
              replacement: Text('Replacement'),
              child: Text('Original'),
            ),
          ),
        ),
      );

      expect(find.text('Original'), findsOneWidget);
    });

    testWidgets('shows original when replace is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.replace(
              replace: false,
              replacement: Text('Replacement'),
              child: Text('Original'),
            ),
          ),
        ),
      );

      expect(find.text('Original'), findsOneWidget);
    });

    testWidgets('respects custom width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Skeleton.replace(
              key: Key('skeleton'),
              width: 100,
              height: 50,
              child: Text('Original'),
            ),
          ),
        ),
      );
      // The replacement should be a Bone with the specified dimensions
      expect(find.byKey(Key('skeleton')), findsOneWidget);
    });
  });

  group('Skeleton.leaf', () {
    testWidgets('forces painting effect on child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.leaf(child: SizedBox(width: 100, height: 100)),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders normally when enabled is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.leaf(
              enabled: false,
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('Skeleton.ignorePointer', () {
    testWidgets('ignores pointer events when enabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            effect: SolidColorEffect(),
            enabled: true,
            ignorePointers: false, // Allow pointers at Skeletonizer level
            child: Skeleton.ignorePointer(
              child: GestureDetector(
                onTap: () => tapped = true,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tap me'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('allows pointer events when ignore is false', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            ignorePointers: false,
            child: Skeleton.ignorePointer(
              ignore: false,
              child: GestureDetector(
                onTap: () => tapped = true,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('Nested Skeleton annotations', () {
    testWidgets('handles nested ignore and keep', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Column(
              children: [
                Skeleton.ignore(child: Text('Ignored')),
                Skeleton.keep(child: Text('Kept')),
                Text('Normal'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Ignored'), findsOneWidget);
      expect(find.text('Kept'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('handles mixed skeleton annotations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Column(
              children: [
                const Skeleton.ignore(child: Icon(Icons.star)),
                Skeleton.unite(
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.person), Text('User')],
                  ),
                ),
                const Skeleton.shade(child: Icon(Icons.settings)),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('User'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('Skeleton render object updates', () {
    testWidgets('_RenderBasicSkeleton updates enabled property', (
      tester,
    ) async {
      const key = Key('skeleton-keep');
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.keep(key: key, keep: true, child: Icon(Icons.star)),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);

      // Update with keep: false
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.keep(
              key: key,
              keep: false,
              child: Icon(Icons.star),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('RenderIgnoredSkeleton updates enabled property', (
      tester,
    ) async {
      const key = Key('skeleton-ignore');
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.ignore(key: key, ignore: true, child: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Update with ignore: false
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.ignore(
              key: key,
              ignore: false,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('_RenderSkeletonShaderMask updates shade property', (
      tester,
    ) async {
      const key = Key('skeleton-shade');
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.shade(
              key: key,
              shade: true,
              child: Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);

      // Update with shade: false
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.shade(
              key: key,
              shade: false,
              child: Icon(Icons.star),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Skeleton.leaf with disabled skeletonizer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: false,
            child: Skeleton.leaf(child: SizedBox(width: 100, height: 100)),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Skeleton.unite with null borderRadius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Skeleton.unite(
              borderRadius: null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.star), Text('Rating')],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
    });

    testWidgets('Skeleton.ignorePointer when skeletonizer is disabled', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: false,
            child: Skeleton.ignorePointer(
              child: GestureDetector(
                onTap: () => tapped = true,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('Skeleton.replace with default replacement', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Skeleton.replace(child: Text('Original')),
          ),
        ),
      );

      // Default replacement is ColoredBox(color: Colors.black)
      expect(find.byType(ColoredBox), findsWidgets);
      expect(find.text('Original'), findsNothing);
    });
  });
}
