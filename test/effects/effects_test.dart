import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('ShimmerEffect', () {
    test('default constructor creates effect with default colors', () {
      const effect = ShimmerEffect();

      expect(effect.duration, equals(const Duration(milliseconds: 2000)));
      expect(effect.lowerBound, equals(-0.5));
      expect(effect.upperBound, equals(1.5));
      expect(effect.begin, equals(const AlignmentDirectional(-1.0, -0.3)));
      expect(effect.end, equals(const AlignmentDirectional(1.0, 0.3)));
    });

    test('custom colors are applied correctly', () {
      const effect = ShimmerEffect(
        baseColor: Colors.red,
        highlightColor: Colors.blue,
      );

      expect(effect.colors, contains(Colors.red));
      expect(effect.colors, contains(Colors.blue));
    });

    test('custom alignment is applied correctly', () {
      const effect = ShimmerEffect(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      expect(effect.begin, equals(Alignment.topLeft));
      expect(effect.end, equals(Alignment.bottomRight));
    });

    test('createPaint returns a Paint with shader', () {
      const effect = ShimmerEffect();
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      final paint = effect.createPaint(0.5, rect, TextDirection.ltr);

      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });

    test('createPaint produces correct Paint for various t and rect', () {
      const effect = ShimmerEffect(
        baseColor: Colors.red,
        highlightColor: Colors.blue,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      // Test with different t values and rects
      const rect1 = Rect.fromLTWH(0, 0, 100, 100);
      const rect2 = Rect.fromLTWH(10, 10, 50, 50);
      final paint1 = effect.createPaint(0.0, rect1, TextDirection.ltr);
      final paint2 = effect.createPaint(1.0, rect1, TextDirection.ltr);
      final paint3 = effect.createPaint(0.5, rect2, TextDirection.rtl);
      expect(paint1, isA<Paint>());
      expect(paint1.shader, isNotNull);
      expect(paint2, isA<Paint>());
      expect(paint2.shader, isNotNull);
      expect(paint3, isA<Paint>());
      expect(paint3.shader, isNotNull);
      // Ensure different t produces different shaders
      expect(paint1.shader, isNot(equals(paint2.shader)));
    });

    test('raw constructor allows full customization', () {
      const effect = ShimmerEffect.raw(
        colors: [Colors.red, Colors.green, Colors.blue],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror,
        duration: Duration(milliseconds: 1500),
      );

      expect(effect.colors, equals([Colors.red, Colors.green, Colors.blue]));
      expect(effect.stops, equals([0.0, 0.5, 1.0]));
      expect(effect.tileMode, equals(TileMode.mirror));
      expect(effect.duration, equals(const Duration(milliseconds: 1500)));
    });

    test('equality works correctly', () {
      const effect1 = ShimmerEffect();
      const effect2 = ShimmerEffect();
      const effect3 = ShimmerEffect(baseColor: Colors.red);

      expect(effect1, equals(effect2));
      expect(effect1, isNot(equals(effect3)));
    });

    test('hashCode is consistent with equality', () {
      const effect1 = ShimmerEffect();
      const effect2 = ShimmerEffect();

      expect(effect1.hashCode, equals(effect2.hashCode));
    });

    group('ShimmerEffect additional coverage', () {
      test('colors and stops default and custom', () {
        const effectDefault = ShimmerEffect();
        expect(effectDefault.colors, isA<List<Color>>());
        expect(effectDefault.stops, [0.1, 0.3, 0.4]);
        const effectCustom = ShimmerEffect.raw(
          colors: [Colors.red, Colors.green],
          stops: [0.0, 1.0],
        );
        expect(effectCustom.colors, [Colors.red, Colors.green]);
        expect(effectCustom.stops, [0.0, 1.0]);
      });

      test('tileMode property is set correctly', () {
        const effect = ShimmerEffect.raw(
          colors: [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );
        expect(effect.tileMode, TileMode.repeated);
      });

      test('createPaint works with both LTR and RTL', () {
        const effect = ShimmerEffect();
        const rect = Rect.fromLTWH(0, 0, 100, 100);
        final paintLtr = effect.createPaint(0.5, rect, TextDirection.ltr);
        final paintRtl = effect.createPaint(0.5, rect, TextDirection.rtl);
        expect(paintLtr, isA<Paint>());
        expect(paintRtl, isA<Paint>());
      });

      test('runtimeType and hashCode differ for different configs', () {
        const effect1 = ShimmerEffect();
        const effect2 = ShimmerEffect(
          baseColor: Colors.red,
          highlightColor: Colors.blue,
        );
        expect(effect1.hashCode, isNot(equals(effect2.hashCode)));
        expect(effect1.runtimeType, equals(effect2.runtimeType));
      });

      test('toString returns type information', () {
        const effectDefault = ShimmerEffect();
        const effectCustom = ShimmerEffect(
          baseColor: Colors.red,
          highlightColor: Colors.blue,
          duration: Duration(milliseconds: 1234),
        );
        expect(effectDefault.toString(), contains('ShimmerEffect'));
        expect(effectCustom.toString(), contains('ShimmerEffect'));
      });

      test(
        'lerp returns value-equal effect at t=0 and t=1 (duration from first)',
        () {
          const effect1 = ShimmerEffect(
            baseColor: Colors.red,
            highlightColor: Colors.blue,
            duration: Duration(milliseconds: 1000),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          const effect2 = ShimmerEffect(
            baseColor: Colors.green,
            highlightColor: Colors.yellow,
            duration: Duration(milliseconds: 2000),
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          );
          final lerped0 = effect1.lerp(effect2, 0.0) as ShimmerEffect;
          final lerped1 = effect1.lerp(effect2, 1.0) as ShimmerEffect;
          // Compare all fields for lerped0
          expect(lerped0.colors[0].toARGB32(), effect1.colors[0].toARGB32());
          expect(lerped0.colors[1].toARGB32(), effect1.colors[1].toARGB32());
          expect(lerped0.colors[2].toARGB32(), effect1.colors[2].toARGB32());
          expect(lerped0.duration, effect1.duration);
          expect(lerped0.begin, effect1.begin);
          expect(lerped0.end, effect1.end);
          // Compare all fields for lerped1 (duration from effect1)
          expect(
            lerped1.colors[0].toARGB32(),
            Color.lerp(Colors.red, Colors.green, 1.0)!.toARGB32(),
          );
          expect(
            lerped1.colors[1].toARGB32(),
            Color.lerp(Colors.blue, Colors.yellow, 1.0)!.toARGB32(),
          );
          expect(
            lerped1.colors[2].toARGB32(),
            Color.lerp(Colors.red, Colors.green, 1.0)!.toARGB32(),
          );
          expect(lerped1.duration, effect1.duration);
          expect(lerped1.begin, effect2.begin);
          expect(lerped1.end, effect2.end);
        },
      );

      test('lerp returns this if other is not ShimmerEffect', () {
        const effect = ShimmerEffect();
        const notShimmer = PulseEffect();
        final lerped = effect.lerp(notShimmer, 0.5);
        expect(lerped, equals(effect));
      });

      test('equality and hashCode for identical and different configs', () {
        const effect1 = ShimmerEffect(
          baseColor: Colors.red,
          highlightColor: Colors.blue,
          duration: Duration(milliseconds: 1000),
        );
        const effect2 = ShimmerEffect(
          baseColor: Colors.red,
          highlightColor: Colors.blue,
          duration: Duration(milliseconds: 1000),
        );
        const effect3 = ShimmerEffect(
          baseColor: Colors.green,
          highlightColor: Colors.yellow,
          duration: Duration(milliseconds: 2000),
        );
        expect(effect1, equals(effect2));
        expect(effect1.hashCode, equals(effect2.hashCode));
        expect(effect1, isNot(equals(effect3)));
        expect(effect1.hashCode, isNot(equals(effect3.hashCode)));
      });
    });
  });

  group('PulseEffect', () {
    test('default constructor creates effect with default values', () {
      const effect = PulseEffect();

      expect(effect.duration, equals(const Duration(milliseconds: 1000)));
      expect(effect.from, equals(const Color(0xFFf4f4f4)));
      expect(effect.to, equals(const Color(0xFFe5e5e5)));
      expect(effect.reverse, isTrue);
    });

    test('custom colors are applied correctly', () {
      const effect = PulseEffect(from: Colors.red, to: Colors.blue);
      expect(effect.from.toARGB32(), equals(Colors.red.toARGB32()));
      expect(effect.to.toARGB32(), equals(Colors.blue.toARGB32()));
    });

    test('createPaint returns a Paint with shader', () {
      const effect = PulseEffect();
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      final paint = effect.createPaint(0.5, rect, TextDirection.ltr);

      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });

    test('createPaint lerps between colors based on t value', () {
      const effect = PulseEffect(from: Colors.white, to: Colors.black);
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      // These should create different shaders
      final paint0 = effect.createPaint(0.0, rect, TextDirection.ltr);
      final paint1 = effect.createPaint(1.0, rect, TextDirection.ltr);

      expect(paint0.shader, isNotNull);
      expect(paint1.shader, isNotNull);
    });

    test('lerp interpolates between two PulseEffects', () {
      const effect1 = PulseEffect(from: Colors.white, to: Colors.white);
      const effect2 = PulseEffect(from: Colors.black, to: Colors.black);

      final lerped = effect1.lerp(effect2, 0.5) as PulseEffect;

      expect(lerped.from, equals(Color.lerp(Colors.white, Colors.black, 0.5)));
      expect(lerped.to, equals(Color.lerp(Colors.white, Colors.black, 0.5)));
    });

    test('lerp returns this when other is not PulseEffect', () {
      const pulseEffect = PulseEffect();
      const shimmerEffect = ShimmerEffect();

      final lerped = pulseEffect.lerp(shimmerEffect, 0.5);

      expect(lerped, equals(pulseEffect));
    });

    test('equality works correctly', () {
      const effect1 = PulseEffect();
      const effect2 = PulseEffect();
      const effect3 = PulseEffect(from: Colors.red);

      expect(effect1, equals(effect2));
      expect(effect1, isNot(equals(effect3)));
    });

    test('hashCode is consistent with equality', () {
      const effect1 = PulseEffect();
      const effect2 = PulseEffect();

      expect(effect1.hashCode, equals(effect2.hashCode));
    });
  });

  group('SoldColorEffect', () {
    test('default constructor creates effect with default color', () {
      const effect = SolidColorEffect();

      expect(effect.color, equals(const Color(0xFFF6F6F6)));
      expect(effect.duration, equals(Duration.zero));
    });

    test('custom color is applied correctly', () {
      const effect = SolidColorEffect(color: Colors.red);

      expect(effect.color.toARGB32(), equals(Colors.red.toARGB32()));
    });

    test('createPaint returns a Paint with shader', () {
      const effect = SolidColorEffect();
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      final paint = effect.createPaint(0.5, rect, TextDirection.ltr);

      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });

    test('lerp interpolates between two SoldColorEffects', () {
      const effect1 = SolidColorEffect(color: Colors.white);
      const effect2 = SolidColorEffect(color: Colors.black);

      final lerped = effect1.lerp(effect2, 0.5) as SolidColorEffect;

      expect(lerped.color, equals(Color.lerp(Colors.white, Colors.black, 0.5)));
    });

    test('lerp returns this when other is not SoldColorEffect', () {
      const soldEffect = SolidColorEffect();
      const shimmerEffect = ShimmerEffect();

      final lerped = soldEffect.lerp(shimmerEffect, 0.5);

      expect(lerped, equals(soldEffect));
    });

    test('equality works correctly', () {
      const effect1 = SolidColorEffect();
      const effect2 = SolidColorEffect();
      const effect3 = SolidColorEffect(color: Colors.red);

      expect(effect1, equals(effect2));
      expect(effect1, isNot(equals(effect3)));
    });

    test('hashCode is consistent with equality', () {
      const effect1 = SolidColorEffect();
      const effect2 = SolidColorEffect();

      expect(effect1.hashCode, equals(effect2.hashCode));
    });
  });

  group('ShimmerEffect isVertical logic', () {
    test('isVertical is true when beginX and endX are 0', () {
      final effect = ShimmerEffect(
        begin: Alignment(0, -1),
        end: Alignment(0, 1),
      );
      // Should trigger isVertical = true
      final paint = effect.createPaint(
        0.5,
        Rect.fromLTWH(0, 0, 10, 10),
        TextDirection.ltr,
      );
      expect(paint, isA<Paint>());
      // No direct way to check isVertical, but this ensures the code path is covered
    });
    test('isVertical is false when beginX or endX is not 0', () {
      final effect = ShimmerEffect(
        begin: Alignment(-1, 0),
        end: Alignment(1, 0),
      );
      // Should trigger isVertical = false
      final paint = effect.createPaint(
        0.5,
        Rect.fromLTWH(0, 0, 10, 10),
        TextDirection.ltr,
      );
      expect(paint, isA<Paint>());
    });
  });

  group('RawShimmerEffect', () {
    test('constructs with required and optional parameters', () {
      final effect = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
        lowerBound: -1.0,
        upperBound: 2.0,
        duration: Duration(milliseconds: 1234),
      );
      expect(effect.colors, [Colors.red, Colors.green, Colors.blue]);
      expect(effect.stops, [0.0, 0.5, 1.0]);
      expect(effect.begin, Alignment.topLeft);
      expect(effect.end, Alignment.bottomRight);
      expect(effect.tileMode, TileMode.mirror);
      expect(effect.lowerBound, -1.0);
      expect(effect.upperBound, 2.0);
      expect(effect.duration, Duration(milliseconds: 1234));
    });

    test('equality and hashCode', () {
      final effect1 = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
      );
      final effect2 = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
      );
      final effect3 = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.yellow],
      );
      expect(effect1, equals(effect2));
      expect(effect1.hashCode, equals(effect2.hashCode));
      expect(effect1, isNot(equals(effect3)));
    });

    test('lerp between two RawShimmerEffects', () {
      final effect1 = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.clamp,
        duration: Duration(milliseconds: 1000),
      );
      final effect2 = RawShimmerEffect(
        colors: [Colors.yellow, Colors.purple, Colors.orange],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        tileMode: TileMode.mirror,
        duration: Duration(milliseconds: 2000),
      );
      final lerped = effect1.lerp(effect2, 0.5) as RawShimmerEffect;
      expect(lerped.colors.length, 3);
      expect(lerped.colors[0], Color.lerp(Colors.red, Colors.yellow, 0.5));
      expect(lerped.colors[1], Color.lerp(Colors.green, Colors.purple, 0.5));
      expect(lerped.colors[2], Color.lerp(Colors.blue, Colors.orange, 0.5));
      expect(
        lerped.begin,
        AlignmentGeometry.lerp(Alignment.topLeft, Alignment.bottomLeft, 0.5),
      );
      expect(
        lerped.end,
        AlignmentGeometry.lerp(Alignment.bottomRight, Alignment.topRight, 0.5),
      );
      // tileMode and duration are from effect1
      expect(lerped.tileMode, effect1.tileMode);
      expect(lerped.duration, effect1.duration);
    });

    test('lerp returns this if other is not RawShimmerEffect', () {
      final effect = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
      );
      final notRaw = ShimmerEffect();
      final lerped = effect.lerp(notRaw, 0.5);
      expect(lerped, equals(effect));
    });

    test('createPaint produces Paint with shader', () {
      final effect = RawShimmerEffect(
        colors: [Colors.red, Colors.green, Colors.blue],
      );
      final paint = effect.createPaint(
        0.5,
        Rect.fromLTWH(0, 0, 100, 100),
        TextDirection.ltr,
      );
      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });
  });
}
