import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final map1 = {'a': 1, 'b': 'b0', 'c': ''};
    final map2 = {'a': 1, 'b1': 'b0', 'c': 'c0', 'd': 4};
    // final map9 = {'e': 'e0'};

    setUp(() {
      // Additional setup goes here.
    });
    test('mapFilterByKeys Test1', () {
      var map40 = Map.of(map1);
      var map41 = Map.of(map1);
      var keys = {'b'};
      var map50 = mapFilterByKeys(map40, keys); // {b: b0}
      var map51 = mapFilterByKeys(map41, keys, isblacklist: true); // {a: 1, c: null}
      expect(map50, contains('b'));
      expect(map51.keys, orderedEquals(['a','c']));

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

    test('mapIntersection Test1', () {
      var map3 = mapIntersection(map1, map2);
      expect(map3, contains('a'));
      expect(map3, containsValue(1));
      expect(map3, contains('c'));
      expect(map3, containsValue('c0'));
      expect(map3, containsPair('a', 1));
      expect(map3, containsPair('c', 'c0'));
    });

    test('mapIntersectionUpdate Test1', () {
      var map41 = {'a': 1, 'b': 'b0', 'c': null};
      var map42 = {'a': 11, 'd': 4};
      var map3 = mapIntersectionUpdate(map41, map42);
      // print(map3); // {a: 11, b: b0, 'c':null}
      expect(map3, containsPair('a', 11));
      expect(map3, containsPair('b', 'b0'));
      expect(map3, containsPair('c', null));

      expect(map3.keys, orderedEquals(['a', 'b', 'c']));
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

      var skips = [
        'title',
      ];
      map = mapReplaceholderOfList(lists,
          skips: skips); // print(map); // {'id':'?', 'name':'?',}
      expect(
          map.keys,
          orderedEquals([
            'id',
            'name',
          ]));
      expect(
          map.values,
          orderedEquals([
            '?',
            '?',
          ]));
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

    test('batchValidtion Test1', () {
      final rows = [
        {'a': 1, 'b': 'b2'},
        {'a': 11, 'b': 'b22'},
        {'a': 111, 'b': 'b0'}
      ];
      final rows2 = [
        {'a': 1, 'b': 'b2'},
        {'a': 11, 'c': 'b22'}
      ];
      myfn(Map<String, dynamic> item) =>
          (item.containsKey('a') && item.containsKey('b') && (item['a'] is int))
              ? true
              : false;

      final valid1 = batchValidtion(myfn, rows); // true
      final valid2 = batchValidtion(myfn, rows2); // false;
      expect(valid1, isTrue);
      expect(valid2, isFalse);
    });

    test('mapReplaceholders Test1', () {
      var tmpl = {'a': 1, 'b': 'b0'};
      var dats = [
        {'a': 1, 'b': 'b2'},
        {'a': 11, 'b': 'b22', 'c': 33},
        {'a': 111, 'c': null, 'd': 444},
      ];
      var map3 = mapReplaceholders(tmpl, dats);
// print(map3);
// {hold: {a: ?, b: ?}, keys: [a, b], vals: [[1, b2], [11, b22], [111, b0]], rows: [{a: 1, b: b2}, {a: 11, b: b22}, {a: 111, b: b0}]}
      expect(map3, contains('hold'));
      expect(map3, contains('keys'));
      expect(map3, contains('vals'));
      expect(map3, contains('rows'));

      var hold = map3['hold'];
      expect(hold, contains('a'));
      expect(hold, containsPair('a', '?'));

      var keys = map3['keys'];
      expect(keys, contains('a'));
      expect(keys, hasLength(2));
      expect(keys, orderedEquals(['a', 'b']));

      var vals = map3['vals'];
      expect(vals, hasLength(3));
      expect(vals[0], orderedEquals([1, 'b2']));
      expect(vals[1], orderedEquals([11, 'b22']));
      expect(vals[2], orderedEquals([111, 'b0']));

      var rows = map3['rows'];
      expect(rows, hasLength(3));
      myfn(Map<String, dynamic> item) =>
          (item.containsKey('a') && item.containsKey('b') && (item['a'] is int))
              ? true
              : false;

      final valid1 = batchValidtion(myfn, rows); // true
      expect(valid1, isTrue);
    });

    // lastline tests
  });
}
