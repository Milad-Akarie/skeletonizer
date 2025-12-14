import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('Skeletonizer Render Integration', () {
    testWidgets('respects textDirection LTR', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Skeletonizer(
                enabled: true,
                effect: SoldColorEffect(),
                child: Text('LTR Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('LTR Test'), findsOneWidget);
    });

    testWidgets('respects textDirection RTL', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Skeletonizer(
                enabled: true,
                effect: SoldColorEffect(),
                child: Text('RTL Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('RTL Test'), findsOneWidget);
    });

    testWidgets('ignorePointers blocks pointer events', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              ignorePointers: true,
              effect: const SoldColorEffect(),
              child: GestureDetector(
                onTap: () => tapped = true,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('allows pointer events when ignorePointers is false', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              ignorePointers: false,
              effect: const SoldColorEffect(),
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

    testWidgets('updates when config changes', (tester) async {
      const key = Key('skeletonizer');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              key: key,
              enabled: true,
              effect: SoldColorEffect(),
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Update with new config
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              key: key,
              enabled: true,
              effect: PulseEffect(),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('zone mode works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer.zone(
              enabled: true,
              effect: const SoldColorEffect(),
              child: Column(
                children: [const Text('Normal Text'), Bone.text(words: 3)],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Normal Text'), findsOneWidget);
    });

    testWidgets('works with animated values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: PulseEffect(duration: Duration(milliseconds: 500)),
              child: Text('Animated Test'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Animated Test'), findsOneWidget);

      // Advance animation
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Animated Test'), findsOneWidget);
    });

    testWidgets('handles complex widget trees', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SoldColorEffect(),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('John Doe'),
                    subtitle: Text('john@example.com'),
                  ),
                  Row(
                    children: [
                      Container(width: 50, height: 50, color: Colors.blue),
                      const SizedBox(width: 10),
                      const Text('Content'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('Skeletonizer.sliver Integration', () {
    testWidgets('works with sliver lists', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Skeletonizer.sliver(
                  enabled: true,
                  effect: const SoldColorEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      const ListTile(title: Text('Item 1')),
                      const ListTile(title: Text('Item 2')),
                      const ListTile(title: Text('Item 3')),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SliverSkeletonizer), findsOneWidget);
    });

    testWidgets('handles sliver grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Skeletonizer.sliver(
                  enabled: true,
                  effect: const SoldColorEffect(),
                  child: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    delegate: SliverChildListDelegate([
                      Container(color: Colors.red, child: const Text('1')),
                      Container(color: Colors.blue, child: const Text('2')),
                      Container(color: Colors.green, child: const Text('3')),
                      Container(color: Colors.yellow, child: const Text('4')),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SliverSkeletonizer), findsOneWidget);
    });

    testWidgets('sliver respects textDirection RTL', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomScrollView(
                slivers: [
                  SliverSkeletonizer(
                    enabled: true,
                    effect: const SoldColorEffect(),
                    child: SliverList(
                      delegate: SliverChildListDelegate(const [
                        ListTile(title: Text('RTL Item')),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('RTL Item'), findsOneWidget);
    });

    testWidgets('sliver updates when config changes', (tester) async {
      const key = Key('sliver-skeletonizer');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonizer(
                  key: key,
                  enabled: true,
                  effect: const SoldColorEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate(const [
                      ListTile(title: Text('Test')),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Update with new config
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonizer(
                  key: key,
                  enabled: true,
                  effect: const PulseEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate(const [
                      ListTile(title: Text('Test')),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('sliver ignorePointers blocks hit testing', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonizer(
                  enabled: true,
                  ignorePointers: true,
                  effect: const SoldColorEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      GestureDetector(
                        onTap: () => tapped = true,
                        child: const ListTile(title: Text('Tap me')),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('sliver allows hit testing when ignorePointers is false', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonizer(
                  enabled: true,
                  ignorePointers: false,
                  effect: const SoldColorEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      GestureDetector(
                        onTap: () => tapped = true,
                        child: const ListTile(title: Text('Tap me')),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('sliver zone mode works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonizer.zone(
                  enabled: true,
                  effect: const SoldColorEffect(),
                  child: SliverList(
                    delegate: SliverChildListDelegate([
                      const ListTile(title: Text('Normal Text')),
                      ListTile(title: Bone.text(words: 3)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Normal Text'), findsOneWidget);
    });
  });
}
