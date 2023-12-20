import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('md5gen Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(md5gen('abcdefg'), equals('7ac66c0f148de9519b8bd264312c4d64'));
    });
  });
}
