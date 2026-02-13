import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/src/utils/utils.dart';

void main() {
  group('PaintX extension', () {
    test('copyWith creates a copy with updated color', () {
      final original =
          Paint()
            ..color = Colors.red
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke;

      final copy = original.copyWith(color: Colors.blue);

      expect(copy.color.toARGB32(), equals(Colors.blue.toARGB32()));
      expect(copy.strokeWidth, equals(2.0));
      expect(copy.style, equals(PaintingStyle.stroke));
    });

    test('copyWith creates a copy with shader', () {
      final original = Paint()..color = Colors.red;

      final shader = const LinearGradient(
        colors: [Colors.red, Colors.blue],
      ).createShader(const Rect.fromLTWH(0, 0, 100, 100));

      final copy = original.copyWith(shader: shader);

      expect(copy.shader, equals(shader));
      // When shader is provided, color is set to black
      expect(copy.color.toARGB32(), equals(Colors.black.toARGB32()));
    });

    test('copyWith preserves all paint properties', () {
      final original =
          Paint()
            ..color = Colors.red
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.bevel
            ..isAntiAlias = true
            ..filterQuality = FilterQuality.high
            ..invertColors = false
            ..blendMode = BlendMode.multiply;

      final copy = original.copyWith(color: Colors.green);

      expect(copy.color.toARGB32(), equals(Colors.green.toARGB32()));
      expect(copy.strokeWidth, equals(3.0));
      expect(copy.style, equals(PaintingStyle.stroke));
      expect(copy.strokeCap, equals(StrokeCap.round));
      expect(copy.strokeJoin, equals(StrokeJoin.bevel));
      expect(copy.isAntiAlias, isTrue);
      expect(copy.filterQuality, equals(FilterQuality.high));
      expect(copy.invertColors, isFalse);
      expect(copy.blendMode, equals(BlendMode.multiply));
    });

    test('copyWith without arguments preserves original values', () {
      final original =
          Paint()
            ..color = Colors.purple
            ..strokeWidth = 5.0;

      final copy = original.copyWith();

      expect(copy.color.toARGB32(), equals(Colors.purple.toARGB32()));
      expect(copy.strokeWidth, equals(5.0));
    });
  });

  group('OffsetsSet extension', () {
    test('containsFuzzy returns true for exact match', () {
      final offsets = <Offset>{const Offset(10, 20), const Offset(30, 40)};

      expect(offsets.containsFuzzy(const Offset(10, 20)), isTrue);
      expect(offsets.containsFuzzy(const Offset(30, 40)), isTrue);
    });

    test('containsFuzzy returns true for close matches within tolerance', () {
      final offsets = <Offset>{const Offset(10, 20)};

      expect(offsets.containsFuzzy(const Offset(10.05, 20.05)), isTrue);
      expect(offsets.containsFuzzy(const Offset(9.95, 19.95)), isTrue);
    });

    test('containsFuzzy returns false for matches outside tolerance', () {
      final offsets = <Offset>{const Offset(10, 20)};

      expect(offsets.containsFuzzy(const Offset(10.2, 20.2)), isFalse);
      expect(offsets.containsFuzzy(const Offset(9.8, 19.8)), isFalse);
    });

    test('containsFuzzy respects custom tolerance', () {
      final offsets = <Offset>{const Offset(10, 20)};

      expect(
        offsets.containsFuzzy(const Offset(10.5, 20.5), tolerance: 1.0),
        isTrue,
      );
      expect(
        offsets.containsFuzzy(const Offset(10.5, 20.5), tolerance: 0.1),
        isFalse,
      );
    });

    test('containsFuzzy returns false for empty set', () {
      final offsets = <Offset>{};

      expect(offsets.containsFuzzy(const Offset(10, 20)), isFalse);
    });

    test('containsFuzzy handles negative offsets', () {
      final offsets = <Offset>{const Offset(-10, -20)};

      expect(offsets.containsFuzzy(const Offset(-10, -20)), isTrue);
      expect(offsets.containsFuzzy(const Offset(-10.05, -20.05)), isTrue);
    });
  });
}
