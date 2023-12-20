import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('jsendSuccess Test', () {
      // expect(awesome.isAwesome, isTrue);
      var item = {
        'item': {
          'name': 'alex',
          'age': 18,
        },
      };
      var tdat1 = jsendSuccess(item);
      // print(tdat1); // {status: success, data: {item: {name: alex, age: 18}}} // map.toString
      expect(tdat1.containsKey('status'), isTrue);
      expect(tdat1.keys, orderedEquals(['status','data']));
      expect(tdat1, containsPair('status','success'));      
    });
  });
}
