import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final map1 = {'a': 1, 'b': 'b0', 'c': ''};
    final map2 = {'a': 1, 'b1': 'b0', 'c': 'c0', 'd': 4};
    final map9 = {'e': 'e0'};

    setUp(() {
      // Additional setup goes here.
    });

    test('mapIntersection Test1', () {
      var map3 = mapIntersection(map1, map2);
      expect(map3, contains('a'));
      expect(map3, containsValue(1));
      expect(map3, contains('c'));
      expect(map3, containsValue('c0'));
      expect(map3, containsPair('a', 1));
      expect(map3, containsPair('c', 'c0'));
    });

    test('mapIntersection Test2', () {
      var map3 = mapIntersection(map1, map9);
      expect(map3, isEmpty);
    });

    test('mapReplaceholderOfList Test', () {
      var lists = [
        'id',
        'name',
        'title',
      ];
      var map = mapReplaceholderOfList(
          lists); // print(map3); // {'id':'?', 'name':'?', 'title':'?'}
        expect(map.keys, orderedEquals(lists));
        expect(map.values, orderedEquals(['?', '?', '?']));

        var skips = ['title',];
        map = mapReplaceholderOfList(lists, skips:skips); // print(map); // {'id':'?', 'name':'?',}        
        expect(map.keys, orderedEquals(['id','name',]));
        expect(map.values, orderedEquals(['?', '?', ]));

    });

    test('mapReplaceholder Test', () {
      // {hold: {a: "?", b: "?", c: "?"}, keys: [a, b, c], vals: [1, b0, null]}
      var map3 = mapReplaceholder(map1);
      expect(map3, contains('hold'));
      expect(map3, contains('keys'));
      expect(map3, contains('vals'));

      var hold = map3['hold'];
      expect(hold, contains('a'));
      expect(hold, containsPair('a', '?'));

      var keys = map3['keys'];
      expect(keys, contains('a'));
      expect(keys, hasLength(3));
      expect(keys, orderedEquals(['a', 'b', 'c']));

      var vals = map3['vals'];
      expect(vals, contains('b0'));
      expect(vals, hasLength(3));
      expect(vals, orderedEquals([1, 'b0', '']));
    });
  });
}
