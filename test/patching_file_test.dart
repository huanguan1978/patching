import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A file group of tests', () {
    final files = ['/etc/hosts', '/etc/notexist'];

    setUp(() {
      // Additional setup goes here.
    });

    test('fileDelete Test', () {
      final filename = r'/tmp/temp_notexist.txt';
      final deleted = fileDelete(filename);
      expect(deleted, isFalse);
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

    test('fileNameNumbering Test', () {
      expect(fileNameNumbering('abc.jpg'), equals('abc_1.jpg'));
      expect(fileNameNumbering('abc_1.jpg'), equals('abc_2.jpg'));
    });

    test('filePatternNumbering Test', () {
      var names = ['abc.jpg', 'def.jpg', 'abc.htm', 'abc_1.jpg', 'abc_2.jpg'];
      expect(filePatternNumbering(names, 'abc.jpg'), equals('abc_2.jpg'));
      expect(filePatternNumbering(names, 'notfound.htm'), isEmpty);
    });

    // group_lastline
  });
}
