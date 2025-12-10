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
      const effect = PulseEffect(
        from: Colors.red,
        to: Colors.blue,
      );

      expect(effect.from.value, equals(Colors.red.value));
      expect(effect.to.value, equals(Colors.blue.value));
    });

    test('createPaint returns a Paint with shader', () {
      const effect = PulseEffect();
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      final paint = effect.createPaint(0.5, rect, TextDirection.ltr);

      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });

    test('createPaint lerps between colors based on t value', () {
      const effect = PulseEffect(
        from: Colors.white,
        to: Colors.black,
      );
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
      const effect = SoldColorEffect();

      expect(effect.color, equals(const Color(0xFFF6F6F6)));
      expect(effect.duration, equals(Duration.zero));
    });

    test('custom color is applied correctly', () {
      const effect = SoldColorEffect(color: Colors.red);

      expect(effect.color.value, equals(Colors.red.value));
    });

    test('createPaint returns a Paint with shader', () {
      const effect = SoldColorEffect();
      const rect = Rect.fromLTWH(0, 0, 100, 100);

      final paint = effect.createPaint(0.5, rect, TextDirection.ltr);

      expect(paint, isA<Paint>());
      expect(paint.shader, isNotNull);
    });

    test('lerp interpolates between two SoldColorEffects', () {
      const effect1 = SoldColorEffect(color: Colors.white);
      const effect2 = SoldColorEffect(color: Colors.black);

      final lerped = effect1.lerp(effect2, 0.5) as SoldColorEffect;

      expect(lerped.color, equals(Color.lerp(Colors.white, Colors.black, 0.5)));
    });

    test('lerp returns this when other is not SoldColorEffect', () {
      const soldEffect = SoldColorEffect();
      const shimmerEffect = ShimmerEffect();

      final lerped = soldEffect.lerp(shimmerEffect, 0.5);

      expect(lerped, equals(soldEffect));
    });

    test('equality works correctly', () {
      const effect1 = SoldColorEffect();
      const effect2 = SoldColorEffect();
      const effect3 = SoldColorEffect(color: Colors.red);

      expect(effect1, equals(effect2));
      expect(effect1, isNot(equals(effect3)));
    });

    test('hashCode is consistent with equality', () {
      const effect1 = SoldColorEffect();
      const effect2 = SoldColorEffect();

      expect(effect1.hashCode, equals(effect2.hashCode));
    });
  });
}
