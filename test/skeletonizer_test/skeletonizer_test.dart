import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/src/painting/painting.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';
import 'package:skeletonizer/src/utils.dart';
import 'package:skeletonizer/src/widgets/skeletonizer.dart';

void main() {
  testWidgets('Card widgets should be resolved to ContainerElements', (tester) async {
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 1,
          margin: const EdgeInsets.all(4),
        ),
      ),
    );
    expect(
      [
        ContainerElement(
          descendents: const [],
          elevation: 1,
          color: Colors.white,
          rect: const Rect.fromLTRB(4, 4, 4, 4),
          borderRadius: BorderRadius.circular(4),
        )
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('Card widgets with child should be resolved to ContainerElements with descendants', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 20,
          width: 100,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 1,
            margin: EdgeInsets.zero,
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(text: text),
            ),
          ),
        ),
      ),
    );
    expect(
      [
        ContainerElement(
          descendents: [_toTextElement(text)],
          elevation: 1,
          color: Colors.white,
          rect: const Rect.fromLTRB(0, 0, 100, 20),
          borderRadius: BorderRadius.circular(4),
        )
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('Material widgets should be resolved to ContainerElements', (tester) async {
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          elevation: 1,
        ),
      ),
    );
    expect(
      [
        ContainerElement(
          descendents: const [],
          elevation: 1,
          color: Colors.white,
          rect: Rect.zero,
          borderRadius: BorderRadius.circular(4),
        )
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('Container widgets should be resolved to ContainerElements', (tester) async {
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle, border: Border(), boxShadow: [BoxShadow()]),
        ),
      ),
    );
    expect(
      [
        ContainerElement(
          descendents: const [],
          color: Colors.white,
          rect: const Rect.fromLTRB(0, 0, 100, 100),
          boxShape: BoxShape.circle,
          border: const Border(),
          boxShadow: [const BoxShadow()],
        )
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('ColoredBox widgets should be resolved to ContainerElements', (tester) async {
    final skeletonizer = await tester.pumpSkeletonizerApp(
      const Align(
        alignment: Alignment.topLeft,
        child: ColoredBox(color: Colors.white),
      ),
    );
    expect(
      [
        ContainerElement(
          descendents: const [],
          color: Colors.white,
          rect: Rect.zero,
        )
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('Text widgets should be resolved to TextElements', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: RichText(text: text),
      ),
    );
    expect(
      [_toTextElement(text)],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('ClipRRect widgets should be resolved to RRectClipElements', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child:
              SizedBox(width: 100, height: 20, child: Align(alignment: Alignment.topLeft, child: RichText(text: text))),
        ),
      ),
    );
    expect(
      [
        ClipRRectElement(
            offset: Offset.zero,
            descendents: [_toTextElement(text)],
            clip: const Rect.fromLTRB(0, 0, 100, 20).toRRect(
              BorderRadius.circular(4),
            ))
      ],
      skeletonizer.paintableElements,
    );
  });

  testWidgets('ClipRect widgets should be resolved to RectClipElements', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: ClipRect(
          child:
              SizedBox(width: 100, height: 20, child: Align(alignment: Alignment.topLeft, child: RichText(text: text))),
        ),
      ),
    );
    expect(
      [
        ClipRectElement(
          offset: Offset.zero,
          descendents: [_toTextElement(text)],
          rect: const Rect.fromLTRB(0, 0, 100, 20),
        )
      ],
      skeletonizer.paintableElements,
    );
  });
  testWidgets('ClipOval widgets should be resolved to OvalClipElements', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: ClipRect(
          child:
          SizedBox(width: 100, height: 20, child: Align(alignment: Alignment.topLeft, child: RichText(text: text))),
        ),
      ),
    );
    expect(
      [
        ClipRectElement(
          offset: Offset.zero,
          descendents: [_toTextElement(text)],
          rect: const Rect.fromLTRB(0, 0, 100, 20),
        )
      ],
      skeletonizer.paintableElements,
    );
  });


  testWidgets('ClipPath widgets should be resolved to PathClipElements', (tester) async {
    const text = TextSpan(text: 'foo', style: TextStyle(fontSize: 14));
    final skeletonizer = await tester.pumpSkeletonizerApp(
      Align(
        alignment: Alignment.topLeft,
        child: ClipPath(
          clipper: _PathClip(),
          child: SizedBox(
            width: 100,
            height: 20,
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(text: text),
            ),
          ),
        ),
      ),
    );
    expect(
      [
        ClipPathElement(
          offset: Offset.zero,
          descendents: [_toTextElement(text)],
          clip: _PathClip().getClip(Size.zero),
        )
      ],
      skeletonizer.paintableElements,
    );
  });
}

class _PathClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(10, 10);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

TextElement _toTextElement(TextSpan text) {
  final painter = TextPainter(
    text: text,
    textDirection: TextDirection.ltr,
  )..layout();
  return TextElement(
    offset: Offset.zero,
    lines: painter.computeLineMetrics(),
    fontSize: text.style?.fontSize ?? 14,
    textAlign: TextAlign.start,
    textSize: painter.size,
    borderRadius: BorderRadius.circular(14 * .5),
    textDirection: TextDirection.ltr,
  );
}

extension WidgetTesterX on WidgetTester {
  Future<RenderSkeletonizer> pumpSkeletonizerApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Skeletonizer(
          child: widget,
        ),
      ),
    );
    return skeletonizer;
  }

  RenderSkeletonizer get skeletonizer =>
      allRenderObjects.firstWhere((e) => e is RenderSkeletonizer) as RenderSkeletonizer;
}
