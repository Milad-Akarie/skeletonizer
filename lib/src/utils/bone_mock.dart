/// A class that provides mock data for generating fake
class BoneMock {
  static const String _word = 'Moock';

  /// Returns a string of [charNo] length with [char] repeated
  static String chars(int charNo, [String char = 'C']) => char * charNo;

  /// Returns a string of [words] length with [_word] repeated
  static String words(int words) => _word * words;

  /// Returns a string of [sentences] length with [_word] repeated
  static String title = _word * 2;

  /// Returns a string of [sentences] length with [_word] repeated
  static String get subtitle => _word * 3;

  /// Returns a string of [sentences] length with [_word] repeated
  static String name = _word * 2;

  /// Returns a string of [sentences] length with [_word] repeated
  static String fullName = _word * 3;

  /// Returns a string of [sentences] length with [_word] repeated
  static String get paragraph => _word * 20;

  /// Returns a string of [sentences] length with [_word] repeated
  static String get longParagraph => _word * 50;

  /// Returns a string of [sentences] length with [_word] repeated
  static String date = chars(10);

  /// Returns a string of [sentences] length with [_word] repeated
  static String time = chars(5);

  /// Returns a string of [sentences] length with [_word] repeated
  static String phone = chars(12);

  /// Returns a string of [sentences] length with [_word] repeated
  static String email = chars(18);

  /// Returns a string of [sentences] length with [_word] repeated
  static String address = chars(30);

  /// Returns a string of [sentences] length with [_word] repeated
  static String city = chars(15);

  /// Returns a string of [sentences] length with [_word] repeated
  static String country = chars(15);
}
