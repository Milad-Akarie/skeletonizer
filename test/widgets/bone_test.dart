import 'package:flutter/material.dart';
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
            child: Bone.circle(key: ValueKey('Bone-circle-indent'), size: 50, indent: 10),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-circle-indent')), findsOneWidget);
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
            child: Bone.text(key: ValueKey('Bone-text-font'), fontSize: 20, words: 2),
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
                Bone.text(key: ValueKey('Bone-text-left'), textAlign: TextAlign.left, words: 2),
                Bone.text(key: ValueKey('Bone-text-center'), textAlign: TextAlign.center, words: 2),
                Bone.text(key: ValueKey('Bone-text-right'), textAlign: TextAlign.right, words: 2),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-text-left')), findsOneWidget);
      expect(find.byKey(const ValueKey('Bone-text-center')), findsOneWidget);
      expect(find.byKey(const ValueKey('Bone-text-right')), findsOneWidget);
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
              child: Bone.multiText(key: ValueKey('Bone-multitext-lines'), lines: 5),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-multitext-lines')), findsOneWidget);
    });

    testWidgets('renders with custom fontSize', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: SizedBox(
              width: 200,
              child: Bone.multiText(key: ValueKey('Bone-multitext-font'), lines: 2, fontSize: 18),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-multitext-font')), findsOneWidget);
    });
  });

  group('Bone.button', () {
    testWidgets('renders elevated button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-elevated'), type: BoneButtonType.elevated),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-elevated')), findsOneWidget);
    });

    testWidgets('renders filled button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-filled'), type: BoneButtonType.filled),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-filled')), findsOneWidget);
    });

    testWidgets('renders text button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-text'), type: BoneButtonType.text),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-text')), findsOneWidget);
    });

    testWidgets('renders outlined button bone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-outlined'), type: BoneButtonType.outlined),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-button-outlined')), findsOneWidget);
    });

    testWidgets('renders with custom width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeletonizer.zone(
            effect: SolidColorEffect(),
            enabled: true,
            child: Bone.button(key: ValueKey('Bone-button-size'), width: 150, height: 50),
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
            child: Bone.iconButton(key: ValueKey('Bone-iconButton-size'), size: 48),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('Bone-iconButton-size')), findsOneWidget);
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
      expect(find.byKey(const ValueKey('Bone-iconButton-radius')), findsOneWidget);
    });
  });
}
