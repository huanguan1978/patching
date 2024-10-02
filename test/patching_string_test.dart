import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('escapeBackslash Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(escapeBackslash('hello\nworld'), equals(r'hello\\nworld'));
    });

    test('strReverse Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(strReverse('Hello World'), equals('dlroW olleH'));
    });

    test('emailMaskcode Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(emailMaskcode('123456789@qq.com'), equals('12345****@qq.com'));
      expect(emailMaskcode('abc@qq.com'), equals('***@qq.com'));
    });

    test('splitToIntList Test', () {
      expect(splitToIntList('1,2,3'), orderedEquals([1, 2, 3]));
      expect(splitToIntList('1,2,3,a,b,c,4'), orderedEquals([1, 2, 3, 4]));
      expect(splitToIntList('a,b,c,d,'), isEmpty);
    });

    test('emailMaskcode Test', () {
      expect(sqliteLike('a'), equals('%a%'));
      expect(sqliteLike('a', postfixPct: false), equals('%a'));
      expect(sqliteLike('a', postfixPct: false), equals('%a'));
      // ignore: unnecessary_string_escapes
      expect(sqliteLike('%10\%%', prefixPct: false), equals('%10%%'));
      expect(sqliteLike(r'%10\%%', prefixPct: false),
          equals(r"%10\%% ESCAPE '\'"));
    });

    test('isPasswordSecure Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(isPasswordSecure('Vignesh123!'), isTrue);
      expect(isPasswordSecure('vignesh123'), isFalse);
      expect(isPasswordSecure('VIGNESH123!'), isFalse);
      expect(isPasswordSecure('vignesh@'), isFalse);
      expect(isPasswordSecure('12345678?'), isFalse);
    });

    test('replaceFileName Test', () {
      // expect(awesome.isAwesome, isTrue);
      expect(replaceFileName('abc.jpg', '1234'), equals('1234.jpg'));
      expect(replaceFileName('abc.bak.jpg', '1234'), equals('1234.jpg'));
      expect(replaceFileName('abc', '1234'), equals('abc'));
    });

    test('toBool Test', () {
      expect(toBool(''), isFalse);
      expect(toBool('0'), isFalse);
      expect(toBool('false'), isFalse);
      expect(toBool('no'), isFalse);
      expect(toBool('off'), isFalse);
      expect(toBool('False'), isFalse);
      expect(toBool('No'), isFalse);
      expect(toBool('Off'), isFalse);

      expect(toBool('1'), isTrue);
      expect(toBool('true'), isTrue);
      expect(toBool('True'), isTrue);
      expect(toBool('on'), isTrue);
      expect(toBool('On'), isTrue);
      expect(toBool('yes'), isTrue);
      expect(toBool('Yes'), isTrue);
      expect(toBool('Abc'), isTrue);
    });
  });
}
