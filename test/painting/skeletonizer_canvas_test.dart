import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('SkeletonizerCanvas Drawing Methods', () {
    testWidgets('drawOval works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _OvalPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawLine works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _LinePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawPaint works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _PaintPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawPoints works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _PointsPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRawPoints works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _RawPointsPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawShadow respects ignoreContainers config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _ShadowPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawShadow ignored when ignoreContainers is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              ignoreContainers: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _ShadowPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawColor works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _ColorPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRect with transparent paint is skipped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransparentRectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawCircle with transparent paint is skipped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransparentCirclePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawPath with transparent paint is skipped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransparentPathPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRRect with transparent paint is skipped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransparentRRectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawDRRect with transparent paint is skipped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransparentDRRectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRect respects containersColor config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _RectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawCircle respects containersColor config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _CirclePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRRect respects containersColor config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _RRectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawPath respects containersColor config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _PathPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawDRRect respects containersColor config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _DRRectPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawParagraph with rounded rectangle border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(0.5),
              effect: const SolidColorEffect(),
              child: const Text('Test paragraph with rounded borders'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test paragraph with rounded borders'), findsOneWidget);
    });

    testWidgets('drawParagraph with superellipse border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              textBoneBorderRadius: const TextBoneBorderRadius(
                BorderRadius.all(Radius.circular(8)),
                borderShape: TextBoneBorderShape.roundedSuperellipse,
              ),
              effect: const SolidColorEffect(),
              child: const Text('Test with superellipse'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test with superellipse'), findsOneWidget);
    });

    testWidgets('drawParagraph with multiple lines', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: Skeletonizer(
                enabled: true,
                justifyMultiLineText: true,
                effect: const SolidColorEffect(),
                child: const Text('This is a very long text that will wrap into multiple lines for testing'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('drawParagraph without justifyMultiLineText', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: Skeletonizer(
                enabled: true,
                justifyMultiLineText: false,
                effect: const SolidColorEffect(),
                child: const Text('This is a very long text that will wrap into multiple lines'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('canvas transform operations work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _TransformPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('canvas clip operations work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _ClipPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawPicture works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _PicturePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawVertices works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _VerticesPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawArc works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _ArcPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('canvas save and restore work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _SaveRestorePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Skeleton.leaf creates LeafPaintingContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: Skeleton.leaf(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('LeafPaintingContext stops after first paint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: Skeleton.leaf(
                child: Column(
                  children: [
                    Container(width: 50, height: 50, color: Colors.red),
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('paintChild treats button semantics as leaf', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: ElevatedButton(onPressed: () {}, child: const Text('Button')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Button'), findsOneWidget);
    });

    testWidgets('zone mode uses super canvas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer.zone(
              enabled: true,
              effect: const SolidColorEffect(),
              child: Column(children: [const Text('Normal text'), Bone.text(words: 3), const Icon(Icons.star)]),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Normal text'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
    testWidgets('drawAtlas works correctly', (tester) async {
      ui.Image? image;
      await tester.runAsync(() async {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
        final picture = recorder.endRecording();
        image = await picture.toImage(10, 10);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _AtlasPainter(image!), size: const Size(100, 100)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRawAtlas works correctly', (tester) async {
      ui.Image? image;
      await tester.runAsync(() async {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
        final picture = recorder.endRecording();
        image = await picture.toImage(10, 10);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _RawAtlasPainter(image!), size: const Size(100, 100)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('canvas transform (matrix) works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _MatrixPainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('drawRSuperellipse works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Skeletonizer(
              enabled: true,
              effect: const SolidColorEffect(),
              child: CustomPaint(painter: _RSuperellipsePainter(), size: const Size(100, 100)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}

class _OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(const Rect.fromLTWH(10, 10, 80, 40), Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(const Offset(10, 10), const Offset(90, 90), Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = Colors.yellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PointsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(ui.PointMode.points, const [
      Offset(10, 10),
      Offset(20, 20),
      Offset(30, 30),
    ], Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RawPointsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = Float32List.fromList([10, 10, 20, 20, 30, 30]);
    canvas.drawRawPoints(ui.PointMode.points, points, Paint()..color = Colors.purple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRect(const Rect.fromLTWH(10, 10, 80, 80));
    canvas.drawShadow(path, Colors.black, 5.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ColorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.orange, BlendMode.srcOver);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransparentRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(const Rect.fromLTWH(10, 10, 80, 80), Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransparentCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(50, 50), 30, Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransparentPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRect(const Rect.fromLTWH(10, 10, 80, 80));
    canvas.drawPath(path, Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransparentRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 80), const Radius.circular(10)),
      Paint()..color = Colors.transparent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransparentDRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 80), const Radius.circular(10)),
      RRect.fromRectAndRadius(const Rect.fromLTWH(20, 20, 60, 60), const Radius.circular(5)),
      Paint()..color = Colors.transparent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(const Rect.fromLTWH(10, 10, 80, 80), Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(50, 50), 30, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 80), const Radius.circular(10)),
      Paint()..color = Colors.green,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(10, 10)
      ..lineTo(90, 10)
      ..lineTo(90, 90)
      ..lineTo(10, 90)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.purple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 80), const Radius.circular(10)),
      RRect.fromRectAndRadius(const Rect.fromLTWH(20, 20, 60, 60), const Radius.circular(5)),
      Paint()..color = Colors.orange,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(10, 10);
    canvas.rotate(0.5);
    canvas.scale(1.2);
    canvas.skew(0.1, 0.1);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 50, 50), Paint()..color = Colors.purple);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(10, 10, 80, 80));
    canvas.clipRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(20, 20, 60, 60), const Radius.circular(10)));
    final path = Path()..addOval(const Rect.fromLTWH(30, 30, 40, 40));
    canvas.clipPath(path);
    canvas.drawPaint(Paint()..color = Colors.cyan);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PicturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final recorder = ui.PictureRecorder();
    final pictureCanvas = Canvas(recorder);
    pictureCanvas.drawCircle(const Offset(25, 25), 20, Paint()..color = Colors.red);
    final picture = recorder.endRecording();
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VerticesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final vertices = ui.Vertices(ui.VertexMode.triangles, const [Offset(50, 10), Offset(10, 90), Offset(90, 90)]);
    canvas.drawVertices(vertices, BlendMode.srcOver, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(const Rect.fromLTWH(10, 10, 80, 80), 0, 3.14, true, Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SaveRestorePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(10, 10);
    final count = canvas.getSaveCount();
    canvas.drawRect(const Rect.fromLTWH(0, 0, 30, 30), Paint()..color = Colors.blue);
    canvas.restore();
    canvas.restoreToCount(count - 1);
    canvas.drawRect(const Rect.fromLTWH(50, 50, 30, 30), Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MatrixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.transform(Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]));
    canvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AtlasPainter extends CustomPainter {
  final ui.Image image;
  _AtlasPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawAtlas(
      image,
      [RSTransform(1, 0, 0, 0)],
      [Rect.fromLTWH(0, 0, 10, 10)],
      null,
      BlendMode.src,
      null,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RawAtlasPainter extends CustomPainter {
  final ui.Image image;
  _RawAtlasPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final xform = Float32List.fromList([1.0, 0.0, 0.0, 0.0]);
    final rects = Float32List.fromList([0.0, 0.0, 10.0, 10.0]);

    canvas.drawRawAtlas(image, xform, rects, null, BlendMode.src, null, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RSuperellipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rse = RSuperellipse.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 80), const Radius.circular(10));
    canvas.drawRSuperellipse(rse, Paint()..color = Colors.pink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
