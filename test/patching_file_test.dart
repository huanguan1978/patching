import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A file group of tests', () {
    final files = ['/etc/hosts', '/etc/notexist'];

    setUp(() {
      // Additional setup goes here.
    });

    test('fileExists Test', () {
      final exists = fileExists(files);
      expect(exists, contains('/etc/hosts'));
      expect(exists, isNot(contains('/etc/notexist')));
    });

    test('fileSizes Test', () {
      final sizes = fileSizes(files);
      expect(sizes, greaterThan(0));
    });

    test('fileNumbering Test', () {
      expect(fileNumbering('abc.jpg'), equals('abc_1.jpg'));
      expect(fileNumbering('abc_1.jpg'), equals('abc_2.jpg'));
    });

    // group_lastline
  });
}
