import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('BoneMock', () {
    test('chars generates repeated characters', () {
      expect(BoneMock.chars(5), equals('CCCCC'));
      expect(BoneMock.chars(3, 'X'), equals('XXX'));
      expect(BoneMock.chars(0), equals(''));
    });

    test('words generates repeated word string', () {
      expect(BoneMock.words(1), equals('Moock'));
      expect(BoneMock.words(3), equals('MoockMoockMoock'));
    });

    test('title returns expected value', () {
      expect(BoneMock.title, equals('MoockMoock'));
    });

    test('subtitle returns expected value', () {
      expect(BoneMock.subtitle, equals('MoockMoockMoock'));
    });

    test('name returns expected value', () {
      expect(BoneMock.name, equals('MoockMoock'));
    });

    test('fullName returns expected value', () {
      expect(BoneMock.fullName, equals('MoockMoockMoock'));
    });

    test('paragraph returns expected length', () {
      expect(BoneMock.paragraph.length, greaterThan(50));
    });

    test('longParagraph returns longer string than paragraph', () {
      expect(
        BoneMock.longParagraph.length,
        greaterThan(BoneMock.paragraph.length),
      );
    });

    test('date returns expected length', () {
      expect(BoneMock.date.length, equals(10));
    });

    test('time returns expected length', () {
      expect(BoneMock.time.length, equals(5));
    });

    test('phone returns expected length', () {
      expect(BoneMock.phone.length, equals(12));
    });

    test('email returns expected length', () {
      expect(BoneMock.email.length, equals(18));
    });

    test('address returns expected length', () {
      expect(BoneMock.address.length, equals(30));
    });

    test('city returns expected length', () {
      expect(BoneMock.city.length, equals(15));
    });

    test('country returns expected length', () {
      expect(BoneMock.country.length, equals(15));
    });
  });
}
