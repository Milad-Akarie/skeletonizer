import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/widgets/skeletonizer_render_object_widget.dart';

void main() {
  group('Skeletonizer Widget', () {
    testWidgets('renders child when enabled is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(enabled: false, child: Text('Visible')),
        ),
      );
      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('renders skeleton when enabled is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
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
            effect: SolidColorEffect(color: Colors.red),
            textBoneBorderRadius: TextBoneBorderRadius(
              BorderRadius.circular(8),
            ),
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
            effect: SolidColorEffect(),
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
                effect: SolidColorEffect(),
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
                effect: SolidColorEffect(),
                child: Text(enabled ? 'Skeleton' : 'Normal'),
              ),
            );
          },
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('ignores pointer events when ignorePointers is true', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
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

    testWidgets('allows pointer events when ignorePointers is false', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
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

    testWidgets('renders with custom shimmer effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: ShimmerEffect(
              baseColor: Colors.green,
              highlightColor: Colors.yellow,
              duration: Duration(milliseconds: 500),
            ),
            child: const Text('Shimmer'),
          ),
        ),
      );
      expect(find.text('Shimmer'), findsOneWidget);
    });

    testWidgets('renders with custom pulse effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: PulseEffect(from: Colors.purple, to: Colors.orange),
            child: const Text('Pulse'),
          ),
        ),
      );
      expect(find.text('Pulse'), findsOneWidget);
    });

    testWidgets('renders with RawShimmerEffect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: RawShimmerEffect(
              colors: [Colors.red, Colors.blue, Colors.green],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.mirror,
              duration: Duration(milliseconds: 800),
            ),
            child: const Text('RawShimmer'),
          ),
        ),
      );
      expect(find.text('RawShimmer'), findsOneWidget);
    });

    testWidgets('renders with custom textBoneBorderRadius and ignores effect', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            textBoneBorderRadius: TextBoneBorderRadius(
              BorderRadius.circular(16),
            ),
            child: const Text('Radius'),
          ),
        ),
      );
      expect(find.text('Radius'), findsOneWidget);
    });

    testWidgets('renders with multiple children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Column(children: const [Text('Child1'), Text('Child2')]),
          ),
        ),
      );
      expect(find.text('Child1'), findsOneWidget);
      expect(find.text('Child2'), findsOneWidget);
    });

    testWidgets('renders with empty Container child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Container(),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('renders with ListView child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: ListView(
              children: const [Text('ListItem1'), Text('ListItem2')],
            ),
          ),
        ),
      );
      expect(find.text('ListItem1'), findsOneWidget);
      expect(find.text('ListItem2'), findsOneWidget);
    });

    testWidgets('renders SliverSkeletonizer in CustomScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              height: 400,
              child: CustomScrollView(
                slivers: [
                  SliverSkeletonizer(
                    enabled: true,
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text('Item #$index')),
                        childCount: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('Item #0'), findsOneWidget);
      expect(find.text('Item #1'), findsOneWidget);
      expect(find.text('Item #2'), findsOneWidget);
      expect(find.byType(SliverSkeletonizerRenderObjectWidget), findsWidgets);
    });

    testWidgets('renders SliverSkeletonizer.zone in CustomScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              height: 400,
              child: CustomScrollView(
                slivers: [
                  SliverSkeletonizer.zone(
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text('ZoneItem #$index')),
                        childCount: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('ZoneItem #0'), findsOneWidget);
      expect(find.text('ZoneItem #1'), findsOneWidget);
      expect(find.byType(SliverSkeletonizerRenderObjectWidget), findsWidgets);
    });

    testWidgets(
      'renders normal sliver children when SliverSkeletonizer is disabled',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: SizedBox(
                height: 400,
                child: CustomScrollView(
                  slivers: [
                    SliverSkeletonizer(
                      enabled: false,
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Material(
                            child: ListTile(title: Text('Normal #$index')),
                          ),
                          childCount: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.text('Normal #0'), findsOneWidget);
        expect(find.text('Normal #1'), findsOneWidget);
        expect(find.byType(BoneRenderObjectWidget), findsNothing);
      },
    );
  });

  group('Bone widget', () {
    testWidgets('renders default rectangle bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone(width: 80, height: 20)),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    testWidgets('renders circle bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.circle(size: 40)),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    testWidgets('renders square bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone.square(
              size: 50,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    testWidgets('renders bone with borderRadius and uniRadius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(
              width: 60,
              height: 20,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(width: 60, height: 20, uniRadius: 12),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    testWidgets('renders bone with indent and indentEnd', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(width: 60, height: 20, indent: 5, indentEnd: 7),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    testWidgets('renders text bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.text(words: 3)),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsWidgets);
    });

    testWidgets('renders multiText bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.multiText(lines: 2)),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsWidgets);
    });

    testWidgets('renders button bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone.button(
              width: 100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsWidgets);
    });

    testWidgets('renders icon bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.icon(size: 32)),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsWidgets);
    });

    testWidgets('renders iconButton bone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone.iconButton(
              size: 32,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
      expect(find.byType(BoneRenderObjectWidget), findsWidgets);
    });

    testWidgets('Bone rectangle dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone(width: 80, height: 20)),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 80);
      expect(sizedBox.height, 20);
    });

    testWidgets('Bone circle dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.circle(size: 40)),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 40);
      expect(sizedBox.height, 40);
    });

    testWidgets('Bone square dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone.square(
              size: 50,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 50);
      expect(sizedBox.height, 50);
    });

    testWidgets('Bone indent and indentEnd', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(width: 60, height: 20, indent: 5, indentEnd: 7),
          ),
        ),
      );
      final padding = tester.widget<Padding>(find.byType(Padding));
      final edgeInsets = padding.padding as EdgeInsetsDirectional;
      expect(edgeInsets.start, 5);
      expect(edgeInsets.end, 7);
    });

    testWidgets('Bone borderRadius, uniRadius, shape, and padding', (
      tester,
    ) async {
      // borderRadius
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(
              width: 60,
              height: 20,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
      final boneWidget = tester.widget<BoneRenderObjectWidget>(
        find.byType(BoneRenderObjectWidget),
      );
      final boxDecoration = boneWidget.decoration;
      expect(boxDecoration.borderRadius, BorderRadius.circular(10));
      expect(boxDecoration.shape, BoxShape.rectangle);
      // uniRadius
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(width: 60, height: 20, uniRadius: 12),
          ),
        ),
      );
      final boneWidget2 = tester.widget<BoneRenderObjectWidget>(
        find.byType(BoneRenderObjectWidget),
      );
      final boxDecoration2 = boneWidget2.decoration;
      expect(boxDecoration2.borderRadius, BorderRadius.circular(12));
      expect(boxDecoration2.shape, BoxShape.rectangle);
      // shape: circle
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(enabled: true, child: Bone.circle(size: 30)),
        ),
      );
      final boneWidget3 = tester.widget<BoneRenderObjectWidget>(
        find.byType(BoneRenderObjectWidget),
      );
      final boxDecoration3 = boneWidget3.decoration;
      expect(boxDecoration3.shape, BoxShape.circle);
      // padding: indent and indentEnd
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            child: Bone(width: 60, height: 20, indent: 8, indentEnd: 12),
          ),
        ),
      );
      final padding = tester.widget<Padding>(find.byType(Padding));
      final edgeInsets = padding.padding as EdgeInsetsDirectional;
      expect(edgeInsets.start, 8);
      expect(edgeInsets.end, 12);
    });
  });
}
