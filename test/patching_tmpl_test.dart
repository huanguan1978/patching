import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
//    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('shellPython Test', () {
      final pyscript = 'testpy1.py';
      shellPython(pyscript).then((shellResult) {
        expect(shellResult.exitCode, equals(0));
        expect(shellResult.stderr, isEmpty);
        expect(shellResult.stdout, isNotEmpty);
        var text1 = 'Hello from Python script!';
        expect(shellResult.stdout, contains(text1));
      });
    });

    // group_lastline
  });
}
