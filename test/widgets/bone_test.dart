import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('Bone', () {
    testWidgets('renders with default values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(key: ValueKey('Bone-default')),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-default')), findsOneWidget);
    });

    testWidgets('renders with custom width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(key: ValueKey('Bone-size'), width: 100, height: 50),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-size')), findsOneWidget);
    });

    testWidgets('renders with custom border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(
              key: const ValueKey('Bone-radius'),
              width: 100,
              height: 50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-radius')), findsOneWidget);
    });

    testWidgets('renders with uniRadius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(
              key: ValueKey('Bone-uniRadius'),
              width: 100,
              height: 50,
              uniRadius: 8,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-uniRadius')), findsOneWidget);
    });

    testWidgets('renders with indent and indentEnd', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(
              key: ValueKey('Bone-indent'),
              width: 100,
              height: 50,
              indent: 10,
              indentEnd: 20,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-indent')), findsOneWidget);
    });

    testWidgets('renders with circle shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(
              key: ValueKey('Bone-shape-circle'),
              width: 40,
              height: 40,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-shape-circle')), findsOneWidget);
    });

    testWidgets('renders with zero border radius draws rect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone(
              key: const ValueKey('Bone-zero-radius'),
              width: 50,
              height: 50,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-zero-radius')), findsOneWidget);
    });
  });

  group('Bone.circle', () {
    testWidgets('renders circular bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.circle(key: ValueKey('Bone-circle'), size: 50),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-circle')), findsOneWidget);
    });

    testWidgets('renders with indent', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.circle(
              key: ValueKey('Bone-circle-indent'),
              size: 50,
              indent: 10,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-circle-indent')), findsOneWidget);
    });

    testWidgets('renders without size defaults to shape circle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.circle(key: ValueKey('Bone-circle-nosize')),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-circle-nosize')), findsOneWidget);
    });
  });

  group('Bone.square', () {
    testWidgets('renders square bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.square(key: ValueKey('Bone-square'), size: 50),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-square')), findsOneWidget);
    });

    testWidgets('renders with border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.square(
              key: const ValueKey('Bone-square-radius'),
              size: 50,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-square-radius')), findsOneWidget);
    });

    testWidgets('renders with uniRadius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.square(
              key: ValueKey('Bone-square-uni'),
              size: 50,
              uniRadius: 6,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-square-uni')), findsOneWidget);
    });

    testWidgets('renders with indentEnd', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.square(
              key: ValueKey('Bone-square-indentEnd'),
              size: 40,
              indentEnd: 12,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-square-indentEnd')), findsOneWidget);
    });
  });

  group('Bone.icon', () {
    testWidgets('renders icon bone with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.icon(key: ValueKey('Bone-icon')),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-icon')), findsOneWidget);
    });

    testWidgets('renders icon bone with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.icon(key: ValueKey('Bone-icon-size'), size: 32),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-icon-size')), findsOneWidget);
    });

    testWidgets('uses IconTheme size when not specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IconTheme(
            data: IconThemeData(size: 48),
            child: Skeletonizer.zone(
              effect: SolidColorEffect(),
              enabled: true,
              child: Bone.icon(key: ValueKey('Bone-icon-theme')),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-icon-theme')), findsOneWidget);
    });

    testWidgets('renders with indent variations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.icon(
              key: ValueKey('Bone-icon-indent'),
              size: 24,
              indent: 5,
              indentEnd: 7,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-icon-indent')), findsOneWidget);
    });
  });

  group('Bone.text', () {
    testWidgets('renders text bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.text(key: ValueKey('Bone-text'), words: 3),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text')), findsOneWidget);
    });

    testWidgets('renders with custom fontSize', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.text(
              key: ValueKey('Bone-text-font'),
              fontSize: 20,
              words: 2,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text-font')), findsOneWidget);
    });

    testWidgets('renders with custom width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.text(key: ValueKey('Bone-text-width'), width: 200),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text-width')), findsOneWidget);
    });

    testWidgets('renders with text style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.text(
              key: ValueKey('Bone-text-style'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              words: 2,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text-style')), findsOneWidget);
    });

    testWidgets('renders with different text alignments', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Column(
              children: [
                Bone.text(
                  key: ValueKey('Bone-text-left'),
                  textAlign: TextAlign.left,
                  words: 2,
                ),
                Bone.text(
                  key: ValueKey('Bone-text-center'),
                  textAlign: TextAlign.center,
                  words: 2,
                ),
                Bone.text(
                  key: ValueKey('Bone-text-right'),
                  textAlign: TextAlign.right,
                  words: 2,
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text-left')), findsOneWidget);
      expect(find.byKey(const ValueKey('Bone-text-center')), findsOneWidget);
      expect(find.byKey(const ValueKey('Bone-text-right')), findsOneWidget);
    });

    testWidgets('covers all textAlign values and fixed border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(6)),
            child: Column(
              children: [
                Bone.text(key: ValueKey('ta-start'), textAlign: TextAlign.start, words: 1),
                Bone.text(key: ValueKey('ta-end'), textAlign: TextAlign.end, words: 1),
                Bone.text(key: ValueKey('ta-justify'), textAlign: TextAlign.justify, words: 1),
                Bone.text(key: ValueKey('ta-center2'), textAlign: TextAlign.center, words: 1),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('ta-start')), findsOneWidget);
      expect(find.byKey(const ValueKey('ta-end')), findsOneWidget);
      expect(find.byKey(const ValueKey('ta-justify')), findsOneWidget);
    });

    testWidgets('covers heightFactor border radius inside Skeletonizer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.5),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Bone.text(key: ValueKey('text-heightFactor'), words: 2),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('text-heightFactor')), findsOneWidget);
    });

    testWidgets('covers uniRadius and borderRadius overrides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Column(
              children: [
                Bone.text(key: ValueKey('text-uni'), uniRadius: 8, words: 2),
                Bone.text(
                  key: ValueKey('text-br'),
                  borderRadius: BorderRadius.circular(8),
                  words: 2,
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('text-uni')), findsOneWidget);
      expect(find.byKey(const ValueKey('text-br')), findsOneWidget);
    });

    testWidgets('covers style height vertical padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: Bone.text(
              key: ValueKey('text-height'),
              style: TextStyle(fontSize: 14, height: 1.5),
              words: 2,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('text-height')), findsOneWidget);
    });

    testWidgets('covers DefaultTextStyle fallback', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 12),
              child: Bone.text(key: ValueKey('text-defaultStyle'), words: 2),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('text-defaultStyle')), findsOneWidget);
    });
  });

  group('Bone.multiText', () {
    testWidgets('renders multi-line text bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: SizedBox(
              width: 200,
              child: Bone.multiText(key: ValueKey('Bone-multitext'), lines: 3),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-multitext')), findsOneWidget);
    });

    testWidgets('renders with custom line count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: SizedBox(
              width: 200,
              child: Bone.multiText(
                key: ValueKey('Bone-multitext-lines'),
                lines: 5,
              ),
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('Bone-multitext-lines')),
        findsOneWidget,
      );
    });

    testWidgets('renders with custom fontSize', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: SizedBox(
              width: 200,
              child: Bone.multiText(
                key: ValueKey('Bone-multitext-font'),
                lines: 2,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-multitext-font')), findsOneWidget);
    });

    testWidgets('covers all textAlign mappings and fixed border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(5)),
            child: SizedBox(
              width: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Bone.multiText(key: ValueKey('mt-start'), textAlign: TextAlign.start, lines: 2),
                    Bone.multiText(key: ValueKey('mt-end'), textAlign: TextAlign.end, lines: 2),
                    Bone.multiText(key: ValueKey('mt-center'), textAlign: TextAlign.center, lines: 2),
                    Bone.multiText(key: ValueKey('mt-justify'), textAlign: TextAlign.justify, lines: 2),
                    Bone.multiText(key: ValueKey('mt-left'), textAlign: TextAlign.left, lines: 2),
                    Bone.multiText(key: ValueKey('mt-right'), textAlign: TextAlign.right, lines: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-start')), findsOneWidget);
      expect(find.byKey(const ValueKey('mt-end')), findsOneWidget);
    });

    testWidgets('covers heightFactor border radius and last line width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.5),
            child: SizedBox(
              width: 250,
              child: Bone.multiText(key: ValueKey('mt-heightFactor'), lines: 3),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-heightFactor')), findsOneWidget);
    });

    testWidgets('covers uniRadius override and custom width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: SizedBox(
              width: 200,
              child: Bone.multiText(
                key: ValueKey('mt-uni'),
                lines: 2,
                uniRadius: 10,
                width: 150,
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-uni')), findsOneWidget);
    });

    testWidgets('covers borderRadius override', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: SizedBox(
              width: 200,
              child: Bone.multiText(
                key: ValueKey('mt-br'),
                lines: 2,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-br')), findsOneWidget);
    });

    testWidgets('covers style and height calculations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: SolidColorEffect(),
            child: SizedBox(
              width: 200,
              child: Bone.multiText(
                key: ValueKey('mt-style'),
                lines: 2,
                style: TextStyle(fontSize: 16, height: 1.2),
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-style')), findsOneWidget);
    });

    testWidgets('single line multiText', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: SizedBox(
              width: 200,
              child: Bone.multiText(key: ValueKey('mt-single'), lines: 1),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('mt-single')), findsOneWidget);
    });
  });

  group('Bone.button', () {
    testWidgets('renders prominent button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(
              key: ValueKey('Bone-button-prominent'),
              type: BoneButtonType.prominent,
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('Bone-button-prominent')),
        findsOneWidget,
      );
    });

    testWidgets('renders plain button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(
              key: ValueKey('Bone-button-plain'),
              type: BoneButtonType.plain,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-plain')), findsOneWidget);
    });

    testWidgets('renders outlined button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(
              key: ValueKey('Bone-button-outlined'),
              type: BoneButtonType.outlined,
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('Bone-button-outlined')),
        findsOneWidget,
      );
    });

    testWidgets('renders with custom width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(
              key: ValueKey('Bone-button-size'),
              width: 150,
              height: 50,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-size')), findsOneWidget);
    });

    testWidgets('renders with words', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-words'), words: 3),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-words')), findsOneWidget);
    });

    testWidgets('covers resolver with shape variations and width logic', (tester) async {
      final resolver = BoneResolver(
        button: (context, type) {
          switch (type) {
            case BoneButtonType.prominent:
              return const BoneButtonSpec(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 100,
                height: 40,
                textStyle: TextStyle(fontSize: 18),
              );
            case BoneButtonType.outlined:
              return const BoneButtonSpec(shape: BeveledRectangleBorder(), width: 50, height: 50);
            case BoneButtonType.plain:
              return const BoneButtonSpec(shape: StadiumBorder(), width: 70, height: 30);
          }
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: Skeletonizer.zone(
              effect: const SolidColorEffect(),
              enabled: true,
              child: Column(
                children: [
                  const Bone.button(key: ValueKey('btn-res-prominent'), type: BoneButtonType.prominent),
                  const Bone.button(key: ValueKey('btn-res-outlined'), type: BoneButtonType.outlined),
                  const Bone.button(key: ValueKey('btn-res-plain'), type: BoneButtonType.plain),
                  const Bone.button(key: ValueKey('btn-res-words'), words: 2, type: BoneButtonType.prominent),
                  const Bone.button(key: ValueKey('btn-res-width'), width: 120, type: BoneButtonType.prominent),
                  Bone.button(key: const ValueKey('btn-res-uni'), uniRadius: 12, type: BoneButtonType.prominent),
                  Bone.button(key: ValueKey('btn-res-br'), borderRadius: BorderRadius.circular(12), type: BoneButtonType.prominent),
                  const Bone.button(key: ValueKey('btn-res-shape'), shape: BoxShape.circle, type: BoneButtonType.prominent),
                  const Bone.button(key: ValueKey('btn-res-height'), height: 60, type: BoneButtonType.plain),
                  const Bone.button(key: ValueKey('btn-res-indent'), indent: 8, indentEnd: 8, type: BoneButtonType.prominent),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('btn-res-prominent')), findsOneWidget);
      expect(find.byKey(const ValueKey('btn-res-words')), findsOneWidget);
      expect(find.byKey(const ValueKey('btn-res-width')), findsOneWidget);
    });

    testWidgets('covers null shape and fallback shape resolver', (tester) async {
      final resolverNull = BoneResolver(
        button: (c, t) => const BoneButtonSpec(shape: null, width: 60, height: 30),
      );
      final resolverBeveled = BoneResolver(
        button: (c, t) => const BoneButtonSpec(shape: BeveledRectangleBorder(), width: 60, height: 30),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              SkeletonizerConfig(
                data: SkeletonizerConfigData(boneResolver: resolverNull),
                child: const Skeletonizer.zone(
                  effect: SolidColorEffect(),
                  enabled: true,
                  child: Bone.button(key: ValueKey('btn-null-shape')),
                ),
              ),
              SkeletonizerConfig(
                data: SkeletonizerConfigData(boneResolver: resolverBeveled),
                child: const Skeletonizer.zone(
                  effect: SolidColorEffect(),
                  enabled: true,
                  child: Bone.button(key: ValueKey('btn-beveled-shape')),
                ),
              ),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('btn-null-shape')), findsOneWidget);
      expect(find.byKey(const ValueKey('btn-beveled-shape')), findsOneWidget);
    });

    testWidgets('covers words with textStyle null fallback', (tester) async {
      final resolver = BoneResolver(
        button: (c, t) => const BoneButtonSpec(width: 64, height: 32),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: const Skeletonizer.zone(
              effect: SolidColorEffect(),
              enabled: true,
              child: Bone.button(key: ValueKey('btn-words-fallback'), words: 4),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('btn-words-fallback')), findsOneWidget);
    });
  });

  group('Bone.iconButton', () {
    testWidgets('renders icon button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.iconButton(key: ValueKey('Bone-iconButton')),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-iconButton')), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.iconButton(
              key: ValueKey('Bone-iconButton-size'),
              size: 48,
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('Bone-iconButton-size')),
        findsOneWidget,
      );
    });

    testWidgets('renders with border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.iconButton(
              key: const ValueKey('Bone-iconButton-radius'),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('Bone-iconButton-radius')),
        findsOneWidget,
      );
    });

    testWidgets('covers resolver path without size', (tester) async {
      final resolver = BoneResolver(
        iconButton: (c, t) => const BoneIconButtonSpec(
          iconSize: 24,
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: const Skeletonizer.zone(
              effect: SolidColorEffect(),
              enabled: true,
              child: Bone.iconButton(key: ValueKey('iconBtn-resolver')),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('iconBtn-resolver')), findsOneWidget);
    });

    testWidgets('covers resolver with circle and stadium shapes', (tester) async {
      final resolverCircle = BoneResolver(
        iconButton: (c, t) => const BoneIconButtonSpec(shape: CircleBorder()),
      );
      final resolverStadium = BoneResolver(
        iconButton: (c, t) => const BoneIconButtonSpec(shape: StadiumBorder()),
      );
      final resolverNullPadding = BoneResolver(
        iconButton: (c, t) => const BoneIconButtonSpec(iconSize: null, padding: null, shape: BeveledRectangleBorder()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              SkeletonizerConfig(
                data: SkeletonizerConfigData(boneResolver: resolverCircle),
                child: const Skeletonizer.zone(
                  effect: SolidColorEffect(),
                  enabled: true,
                  child: Bone.iconButton(key: ValueKey('icon-circle')),
                ),
              ),
              SkeletonizerConfig(
                data: SkeletonizerConfigData(boneResolver: resolverStadium),
                child: const Skeletonizer.zone(
                  effect: SolidColorEffect(),
                  enabled: true,
                  child: Bone.iconButton(key: ValueKey('icon-stadium')),
                ),
              ),
              SkeletonizerConfig(
                data: SkeletonizerConfigData(boneResolver: resolverNullPadding),
                child: const Skeletonizer.zone(
                  effect: SolidColorEffect(),
                  enabled: true,
                  child: Bone.iconButton(key: ValueKey('icon-nullPad')),
                ),
              ),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('icon-circle')), findsOneWidget);
      expect(find.byKey(const ValueKey('icon-stadium')), findsOneWidget);
      expect(find.byKey(const ValueKey('icon-nullPad')), findsOneWidget);
    });

    testWidgets('covers uniRadius and borderRadius with resolver', (tester) async {
      final resolver = BoneResolver(
        iconButton: (c, t) => const BoneIconButtonSpec(shape: CircleBorder()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: Skeletonizer.zone(
              effect: const SolidColorEffect(),
              enabled: true,
              child: Column(
                children: [
                  const Bone.iconButton(key: ValueKey('icon-uni'), uniRadius: 10),
                  Bone.iconButton(key: const ValueKey('icon-br'), borderRadius: BorderRadius.circular(8)),
                  const Bone.iconButton(key: ValueKey('icon-size-uni'), size: 40, uniRadius: 8),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('icon-uni')), findsOneWidget);
      expect(find.byKey(const ValueKey('icon-br')), findsOneWidget);
    });

    testWidgets('covers prominent outlined plain types', (tester) async {
      final resolver = BoneResolver(
        iconButton: (c, t) {
          switch (t) {
            case BoneButtonType.prominent:
              return const BoneIconButtonSpec(shape: RoundedRectangleBorder());
            case BoneButtonType.outlined:
              return const BoneIconButtonSpec(shape: CircleBorder());
            case BoneButtonType.plain:
              return const BoneIconButtonSpec(shape: StadiumBorder());
          }
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: const Skeletonizer.zone(
              effect: SolidColorEffect(),
              enabled: true,
              child: Column(
                children: [
                  Bone.iconButton(key: ValueKey('icon-prom'), type: BoneButtonType.prominent),
                  Bone.iconButton(key: ValueKey('icon-out'), type: BoneButtonType.outlined),
                  Bone.iconButton(key: ValueKey('icon-plain'), type: BoneButtonType.plain),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('icon-prom')), findsOneWidget);
    });
  });

  group('BoneRenderObject', () {
    testWidgets('updateRenderObject with direction and decoration change', (tester) async {
      const d1 = BoxDecoration(color: Color(0xFF000000), borderRadius: BorderRadius.all(Radius.circular(4)));
      const d2 = BoxDecoration(color: Color(0xFF111111), borderRadius: BorderRadius.all(Radius.circular(8)));
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: BoneRenderObjectWidget(decoration: d1),
        ),
      );
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: BoneRenderObjectWidget(decoration: d2),
        ),
      );
      final ro = tester.renderObject(find.byType(BoneRenderObjectWidget)) as BoneRenderObject;
      expect(ro, isNotNull);
      ro.decoration = d2;
      ro.decoration = d2;
      ro.textDirection = TextDirection.rtl;
      ro.textDirection = TextDirection.rtl;
      ro.textDirection = TextDirection.ltr;
      ro.decoration = const BoxDecoration(color: Color(0xFF222222));
      await tester.pump();
    });

    testWidgets('paints with different decorations inside and outside skeletonizer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              const BoneRenderObjectWidget(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF000000)),
              ),
              const BoneRenderObjectWidget(
                decoration: BoxDecoration(borderRadius: BorderRadius.zero, color: Color(0xFF000000)),
              ),
              BoneRenderObjectWidget(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF000000)),
              ),
              BoneRenderObjectWidget(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF000000),
                  border: Border.all(color: Colors.red, width: 1),
                ),
              ),
              const BoneRenderObjectWidget(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF000000), border: Border.fromBorderSide(BorderSide(color: Colors.blue))),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(BoneRenderObjectWidget), findsNWidgets(5));
    });

    testWidgets('paints inside Skeletonizer painting context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer.zone(
            effect: const SolidColorEffect(),
            enabled: true,
            child: Column(
              children: [
                const Bone(key: ValueKey('bone-paint-circle'), width: 40, height: 40, shape: BoxShape.circle),
                Bone(key: ValueKey('bone-paint-rect'), width: 50, height: 30, borderRadius: BorderRadius.circular(8)),
                const Bone(key: ValueKey('bone-paint-zero'), width: 50, height: 30),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('bone-paint-circle')), findsOneWidget);
    });

    testWidgets('covers decoration null branch and border paint inside skeletonizer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            enabled: true,
            effect: const SolidColorEffect(),
            child: BoneRenderObjectWidget(
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(BoneRenderObjectWidget), findsOneWidget);
    });

    test('BoneRenderObject setters markNeedsPaint logic', () {
      final ro = BoneRenderObject(const BoxDecoration(color: Color(0xFF000000)), TextDirection.ltr);
      ro.decoration = const BoxDecoration(color: Color(0xFF111111));
      ro.decoration = const BoxDecoration(color: Color(0xFF111111));
      ro.textDirection = TextDirection.rtl;
      ro.textDirection = TextDirection.rtl;
      ro.textDirection = TextDirection.ltr;
      ro.decoration = null;
      expect(ro, isNotNull);
    });
  });

  group('BoneResolver', () {
    testWidgets('default BoneResolver returns defaults', (tester) async {
      const resolver = BoneResolver();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final btn = resolver.resolveButton(context, BoneButtonType.prominent);
              final icon = resolver.resolveIconButton(context, BoneButtonType.plain);
              expect(btn.width, 64);
              expect(btn.height, 32);
              expect(icon.iconSize, 24);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('custom BoneResolver callbacks', (tester) async {
      final resolver = BoneResolver(
        button: (c, t) => const BoneButtonSpec(width: 99, height: 44),
        iconButton: (c, t) => const BoneIconButtonSpec(iconSize: 33, padding: EdgeInsets.all(12)),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final btn = resolver.resolveButton(context, BoneButtonType.outlined);
              final icon = resolver.resolveIconButton(context, BoneButtonType.outlined);
              expect(btn.width, 99);
              expect(icon.iconSize, 33);
              expect(icon.padding, const EdgeInsets.all(12));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('BoneResolver with SkeletonizerConfig integration', (tester) async {
      final resolver = BoneResolver(
        button: (c, t) => BoneButtonSpec(shape: const BeveledRectangleBorder(), width: 80, height: 80),
        iconButton: (c, t) => const BoneIconButtonSpec(shape: StadiumBorder()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: SkeletonizerConfig(
            data: SkeletonizerConfigData(boneResolver: resolver),
            child: Skeletonizer.zone(
              effect: const SolidColorEffect(),
              enabled: true,
              child: const Column(
                children: [
                  Bone.button(key: ValueKey('resolver-int'), type: BoneButtonType.prominent),
                  Bone.iconButton(key: ValueKey('resolver-icon-int')),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('resolver-int')), findsOneWidget);
      expect(find.byKey(const ValueKey('resolver-icon-int')), findsOneWidget);
    });

    test('BoneButtonSpec defaults', () {
      const spec = BoneButtonSpec();
      expect(spec.width, 64);
      expect(spec.height, 32);
      expect(spec.shape, isA<RoundedRectangleBorder>());
    });

    test('BoneIconButtonSpec defaults', () {
      const spec = BoneIconButtonSpec();
      expect(spec.iconSize, 24);
      expect(spec.padding, isNull);
      expect(spec.shape, isNull);
    });
  });
}
