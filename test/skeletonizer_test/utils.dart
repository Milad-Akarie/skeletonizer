import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/rendering/render_skeletonizer.dart';

extension WidgetTesterX on WidgetTester {
  Future<RenderSkeletonizer> pumpSkeletonizerApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Skeletonizer(
          effect: const SoldColorEffect(color: Colors.green),
          child: widget,
        ),
      ),
    );
    return skeletonizer;
  }

  RenderSkeletonizer get skeletonizer =>
      allRenderObjects.firstWhere((e) => e is RenderSkeletonizer) as RenderSkeletonizer;
}
