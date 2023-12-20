import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
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
        expect(splitToIntList('1,2,3'), orderedEquals([1,2,3]));
        expect(splitToIntList('1,2,3,a,b,c,4'), orderedEquals([1,2,3,4]));
        expect(splitToIntList('a,b,c,d,'), isEmpty);        
   });

});
}
