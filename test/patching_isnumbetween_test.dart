import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('isNumBetween Test', () {
      // expect(awesome.isAwesome, isTrue);

      expect(isNumBetween(2, 1, 10), isTrue);
      expect(isNumBetween(2.0, 1.0, 10.0), isTrue);
      expect(isNumBetween(2, 1.0, 10.0), isTrue);
      expect(isNumBetween(2.5, 1, 10.5), isTrue);
      expect(isNumBetween(11, 1, 10), isFalse);
    });
  });
}
