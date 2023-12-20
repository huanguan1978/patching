import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('isPasswordSecure Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(isPasswordSecure('Vignesh123!'), isTrue);
      expect(isPasswordSecure('vignesh123'), isFalse);
      expect(isPasswordSecure('VIGNESH123!'), isFalse);
      expect(isPasswordSecure('vignesh@'), isFalse);
      expect(isPasswordSecure('12345678?'), isFalse);
    });
  });
}
