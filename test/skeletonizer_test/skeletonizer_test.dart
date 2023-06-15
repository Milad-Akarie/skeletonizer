import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/src/painting/painting.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';
import 'package:skeletonizer/src/widgets/skeletonizer.dart';

void main() {
  testWidgets('', (tester) async {
    final skeletonizer = await tester.pumpSkeletonizerApp(
      const Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Hello',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );

    final painter = TextPainter(
      text: const TextSpan(text: 'Hello',style: TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
    )..layout();


   final acutal = skeletonizer.paintableElements.first as TextElement;

    print(acutal == TextElement(
        offset: Offset.zero,
        lines: painter.computeLineMetrics(),
        fontSize: 14,
        textSize: painter.size,
        borderRadius: BorderRadius.circular(14 * .5)
    ));
    // expect(
    //   [
    //     TextElement(
    //       offset: Offset.zero,
    //       lines: painter.computeLineMetrics(),
    //       fontSize: 14,
    //       textSize: painter.size,
    //       borderRadius: BorderRadius.circular(14 * .5)
    //     )
    //   ],
    //   skeletonizer.paintableElements,
    // );
  });
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
