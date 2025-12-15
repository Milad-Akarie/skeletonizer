import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/uniting_painting_context.dart';

void main() {
  group('UnitingCanvas', () {
    late SkeletonizerConfigData config;
    late UnitingCanvas canvas;

    setUp(() {
      config = const SkeletonizerConfigData(
        justifyMultiLineText: true,
        effect: SolidColorEffect(),
      );
      canvas = UnitingCanvas(config);
    });

    test('initializes with default values', () {
      expect(
        canvas.unitedRect,
        Rect.fromLTRB(double.infinity, double.infinity, 0, 0),
      );
      expect(canvas.borderRadius, isNull);
      expect(canvas.biggestDescendant, Size.zero);
    });

    test('drawRect updates unitedRect', () {
      final rect = const Rect.fromLTWH(10, 10, 100, 50);
      canvas.drawRect(rect, Paint());

      expect(canvas.unitedRect, rect);
    });

    test('drawRect expands unitedRect when drawing multiple rects', () {
      final rect1 = const Rect.fromLTWH(10, 10, 100, 50);
      final rect2 = const Rect.fromLTWH(5, 5, 150, 80);

      canvas.drawRect(rect1, Paint());
      canvas.drawRect(rect2, Paint());

      expect(canvas.unitedRect, const Rect.fromLTWH(5, 5, 150, 80));
    });

    test('drawCircle updates unitedRect and tracks biggest descendant', () {
      final center = const Offset(50, 50);
      const radius = 25.0;

      canvas.drawCircle(center, radius, Paint());

      expect(
        canvas.unitedRect,
        Rect.fromCircle(center: center, radius: radius),
      );
      expect(canvas.biggestDescendant.width, radius * 2);
      expect(canvas.biggestDescendant.height, radius * 2);
      expect(canvas.borderRadius, BorderRadius.circular(radius));
    });

    test('drawRRect updates unitedRect and border radius', () {
      final rrect = RRect.fromRectAndCorners(
        const Rect.fromLTWH(0, 0, 100, 50),
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(12),
        bottomLeft: const Radius.circular(8),
        bottomRight: const Radius.circular(10),
      );

      canvas.drawRRect(rrect, Paint());

      expect(canvas.unitedRect, rrect.outerRect);
      expect(canvas.biggestDescendant, rrect.outerRect.size);
      expect(canvas.borderRadius!.topLeft, const Radius.circular(10));
      expect(canvas.borderRadius!.topRight, const Radius.circular(12));
    });

    test('drawOval updates unitedRect', () {
      const rect = Rect.fromLTWH(20, 20, 80, 40);
      canvas.drawOval(rect, Paint());

      expect(canvas.unitedRect, rect);
    });

    test('drawArc updates unitedRect', () {
      const rect = Rect.fromLTWH(10, 10, 100, 100);
      canvas.drawArc(rect, 0, 3.14, true, Paint());

      expect(canvas.unitedRect, rect);
    });

    test('drawLine updates unitedRect', () {
      const p1 = Offset(10, 10);
      const p2 = Offset(100, 50);

      canvas.drawLine(p1, p2, Paint());

      expect(canvas.unitedRect, Rect.fromPoints(p1, p2));
    });

    test('drawPath updates unitedRect', () {
      final path = Path()
        ..moveTo(10, 10)
        ..lineTo(100, 10)
        ..lineTo(100, 50)
        ..lineTo(10, 50)
        ..close();

      canvas.drawPath(path, Paint());

      expect(canvas.unitedRect, path.getBounds());
    });

    test('drawDRRect updates unitedRect', () {
      final outer = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 100, 100),
        const Radius.circular(10),
      );
      final inner = RRect.fromRectAndRadius(
        const Rect.fromLTWH(20, 20, 60, 60),
        const Radius.circular(5),
      );

      canvas.drawDRRect(outer, inner, Paint());

      expect(canvas.unitedRect, outer.outerRect);
    });

    test('drawPoints with multiple points updates unitedRect', () {
      final points = [
        const Offset(10, 10),
        const Offset(50, 20),
        const Offset(30, 40),
      ];

      canvas.drawPoints(ui.PointMode.polygon, points, Paint());

      expect(
        canvas.unitedRect,
        isNot(Rect.fromLTRB(double.infinity, double.infinity, 0, 0)),
      );
    });

    test('drawPoints with empty list does not update unitedRect', () {
      final originalRect = canvas.unitedRect;
      canvas.drawPoints(ui.PointMode.polygon, [], Paint());

      expect(canvas.unitedRect, originalRect);
    });

    test('drawShadow updates unitedRect', () {
      final path = Path()..addRect(const Rect.fromLTWH(10, 10, 100, 50));

      canvas.drawShadow(path, Colors.black, 5.0, true);

      expect(canvas.unitedRect, path.getBounds());
    });

    test('clip methods do not throw', () {
      expect(() => canvas.clipPath(Path(), doAntiAlias: true), returnsNormally);
      expect(() => canvas.clipRect(Rect.zero), returnsNormally);
      expect(() => canvas.clipRRect(RRect.zero), returnsNormally);
    });

    test('transform methods do not throw', () {
      expect(() => canvas.save(), returnsNormally);
      expect(() => canvas.restore(), returnsNormally);
      expect(() => canvas.translate(10, 10), returnsNormally);
      expect(() => canvas.rotate(1.5), returnsNormally);
      expect(() => canvas.scale(2.0, 2.0), returnsNormally);
      expect(() => canvas.skew(0.5, 0.5), returnsNormally);
    });

    test('getSaveCount returns 0', () {
      expect(canvas.getSaveCount(), 0);
    });

    test('getDestinationClipBounds returns Rect.zero', () {
      expect(canvas.getDestinationClipBounds(), Rect.zero);
    });

    test('getLocalClipBounds returns Rect.zero', () {
      expect(canvas.getLocalClipBounds(), Rect.zero);
    });

    test('biggestDescendant tracks largest shape - circle wins', () {
      // Draw a small rect
      canvas.drawRect(const Rect.fromLTWH(0, 0, 50, 30), Paint());
      expect(canvas.biggestDescendant, Size.zero);

      // Draw a larger circle
      canvas.drawCircle(const Offset(100, 100), 50, Paint());
      expect(canvas.biggestDescendant, const Size(100, 100));
      expect(canvas.borderRadius, BorderRadius.circular(50));
    });

    test('biggestDescendant tracks largest shape - rrect wins', () {
      // Draw a small circle
      canvas.drawCircle(const Offset(50, 50), 20, Paint());
      expect(canvas.biggestDescendant, const Size(40, 40));

      // Draw a larger rrect
      final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 200, 100),
        const Radius.circular(15),
      );
      canvas.drawRRect(rrect, Paint());
      expect(canvas.biggestDescendant, const Size(200, 100));
    });
  });

  group('UnitingPaintingContext', () {
    late SkeletonizerConfigData config;
    late ContainerLayer containerLayer;

    setUp(() {
      config = const SkeletonizerConfigData(
        justifyMultiLineText: true,
        effect: SolidColorEffect(),
      );
      containerLayer = OffsetLayer();
    });

    test('creates canvas with config', () {
      final context = UnitingPaintingContext(
        containerLayer,
        const Rect.fromLTWH(0, 0, 100, 100),
        config,
      );

      expect(context.canvas, isA<UnitingCanvas>());
    });

    test('createChildContext returns UnitingPaintingContext', () {
      final context = UnitingPaintingContext(
        containerLayer,
        const Rect.fromLTWH(0, 0, 100, 100),
        config,
      );

      final childLayer = OffsetLayer();
      final childContext = context.createChildContext(
        childLayer,
        const Rect.fromLTWH(10, 10, 50, 50),
      );

      expect(childContext, isA<UnitingPaintingContext>());
    });
  });

  group('SkeletonizerPaintingContext - integration', () {
    testWidgets('works with skeleton enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeletonizer(enabled: true, child: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('works with multiple children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              child: Column(
                children: [Text('Line 1'), Text('Line 2'), Icon(Icons.star)],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('paints skeleton effect when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('UnitingCanvas additional coverage', () {
    late SkeletonizerConfigData config;
    late UnitingCanvas canvas;

    setUp(() {
      config = const SkeletonizerConfigData(
        justifyMultiLineText: true,
        effect: SolidColorEffect(),
      );
      canvas = UnitingCanvas(config);
    });

    test('drawImage updates unitedRect', () async {
      final recorder = ui.PictureRecorder();
      final c = Canvas(recorder);
      c.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
      final picture = recorder.endRecording();
      final image = await picture.toImage(10, 10);

      const offset = Offset(10, 10);
      canvas.drawImage(image, offset, Paint());

      expect(canvas.unitedRect, const Rect.fromLTWH(10, 10, 10, 10));
    });

    test('drawImageNine updates unitedRect', () async {
      final recorder = ui.PictureRecorder();
      final c = Canvas(recorder);
      c.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
      final picture = recorder.endRecording();
      final image = await picture.toImage(10, 10);

      const center = Rect.fromLTWH(2, 2, 6, 6);
      const dst = Rect.fromLTWH(10, 10, 100, 100);

      canvas.drawImageNine(image, center, dst, Paint());

      expect(canvas.unitedRect, dst);
    });

    test('drawImageRect updates unitedRect', () async {
      final recorder = ui.PictureRecorder();
      final c = Canvas(recorder);
      c.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
      final picture = recorder.endRecording();
      final image = await picture.toImage(10, 10);

      const src = Rect.fromLTWH(0, 0, 10, 10);
      const dst = Rect.fromLTWH(10, 10, 50, 50);

      canvas.drawImageRect(image, src, dst, Paint());

      expect(canvas.unitedRect, src);
    });

    test('drawRSuperellipse updates unitedRect', () {
      final rse = RSuperellipse.fromRectAndRadius(
        const Rect.fromLTWH(10, 10, 100, 50),
        const Radius.circular(10),
      );

      canvas.drawRSuperellipse(rse, Paint());

      expect(canvas.unitedRect, rse.outerRect);
    });

    test('drawParagraph updates unitedRect', () {
      final builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(textAlign: TextAlign.start, fontSize: 14),
      );
      builder.addText('Hello World');
      final paragraph = builder.build();
      paragraph.layout(const ui.ParagraphConstraints(width: 100));

      canvas.drawParagraph(paragraph, const Offset(10, 10));

      expect(canvas.unitedRect.isInfinite, isFalse);
      expect(canvas.unitedRect.left, 10.0);
    });

    test('drawAtlas updates unitedRect', () async {
      final recorder = ui.PictureRecorder();
      final c = Canvas(recorder);
      c.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
      final picture = recorder.endRecording();
      final image = await picture.toImage(10, 10);

      final rects = [
        const Rect.fromLTWH(10, 10, 10, 10),
        const Rect.fromLTWH(30, 30, 10, 10),
      ];
      final transforms = [
        ui.RSTransform(1, 0, 10, 10),
        ui.RSTransform(1, 0, 30, 30),
      ];

      canvas.drawAtlas(image, transforms, rects, null, null, null, Paint());

      expect(canvas.unitedRect.contains(const Offset(15, 15)), isTrue);
      expect(canvas.unitedRect.contains(const Offset(35, 35)), isTrue);
    });
  });
}
