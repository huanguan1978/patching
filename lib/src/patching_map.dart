part of '../patching.dart';

/// 字典[map]按键名集合[keys]过滤, 若选项[isblacklist]为则仅保留键名集合中有的数据，否则仅保留键名集合中没有的数据
///
///```dart
///  var map1 = {'a': 1, 'b': 'b0', 'c': null};
///  var map2 = Map.of(map1);
///  var keys = {'b'};
///  print(mapFilterByKeys(map2, keys)); // {b: b0}
///  print(mapFilterByKeys(map1, keys, isblacklist: true)); // {a: 1, c: null}
///```
Map<String, dynamic> mapFilterByKeys(Map<String, dynamic> map, Set<String> keys,
    {bool isblacklist = false}) {
  final sets = isblacklist
      ? map.keys.toSet().intersection(keys)
      : map.keys.toSet().difference(keys);
  map.removeWhere((k, v) => sets.contains(k));
  return map;
}

/// 取两个字典[map1]和[map2]的交集
///
/// [map2]的交集返回
///```dart
/// var map1 = {'a': 1, 'b': 'b0', 'c': null};  var map2 = {'a': 1, 'b1': 'b0', 'c': 'c0', 'd': 4};  var map9 = {'e': 'e0'};
/// var map3 = mapIntersection(map1, map2); print(map3); // {a: 1, c: c0}
/// var map4 = mapIntersection(map1, map9); print(map4); // {}
///```
Map<String, dynamic> mapIntersection(
    Map<String, dynamic> map1, Map<String, dynamic> map2) {
  var map3 = <String, dynamic>{};
  map1.forEach((key, value) {
    if (map2.containsKey(key)) map3[key] = map2[key];
  });
  return map3;
}

/// 合并两个字典交集,后者[map2]更新前者[map1],返回前者全部
///
///```dart
/// var map1 = {'a': 1, 'b': 'b0', 'c': null};  var map2 = {'a': 11, 'd': 4};
/// var map3 = mapIntersectionUpdate(map1, map2); print(map3); // {a: 11, b: b0, c:null}
///```
Map<String, dynamic> mapIntersectionUpdate(
    Map<String, dynamic> map1, Map<String, dynamic> map2) {
  map1.forEach((key, value) {
    if (map2.containsKey(key)) map1[key] = map2[key];
  });
  return map1;
}

/// 对字典[map1]的项值占位[replaceholder]
///
/// 返回占位项值后的新字典[hold],以及顺序健清单[keys]和顺序值清单[vals]
///```dart
/// var map1 = {'a': 1, 'b': 'b0', 'c': null};
/// var map3 = mapReplaceholder(map1); print(map3); // {hold: {a: "?", b: "?", c: "?"}, keys: [a, b, c], vals: [1, b0, null]}
///```
Map<String, dynamic> mapReplaceholder(
  Map<String, dynamic> map1, [
  String replaceholder = '?',
]) {
  var map3 = <String, dynamic>{
    'hold': <String, dynamic>{},
    'keys': <String>[],
    'vals': <Object>[],
  };
  map1.forEach((key, value) {
    map3['keys'].add(key);
    map3['vals'].add(value);
    map3['hold'][key] = replaceholder;
  });
  return map3;
}

/// 批量占位，以字典[tmpl]为例的项值占位[replaceholder],返回占位项值后的新字典[hold],以及顺序健清单[keys]和顺序值批量清单[vals]
///
///```dart
/// var tmpl = {'a': 1, 'b': 'b0'};
/// var dats = [{'a': 1, 'b': 'b2'}, {'a': 11, 'b': 'b22', 'c': 33}, {'a': 111, 'c': null, 'd': 444},];
/// var map3 = mapReplaceholders(tmpl, dats); print(map3);
/// // {hold: {a: ?, b: ?}, keys: [a, b], vals: [[1, b2], [11, b22], [111, b0]], rows: [{a: 1, b: b2}, {a: 11, b: b22}, {a: 111, b: b0}]}
///```
Map<String, dynamic> mapReplaceholders(
  Map<String, dynamic> tmpl,
  List<dynamic> dats, [
  String replaceholder = '?',
]) {
  var map3 = <String, dynamic>{
    'hold': <String, dynamic>{},
    'keys': <String>[],
    'vals': <List<Object?>>[],
    'rows': <Map<String, dynamic>>[],
  };

  map3['keys'] = tmpl.keys.toList();
  map3['keys'].forEach((key) => map3['hold'][key] = replaceholder);

  var val = [];
  for (var dat in dats) {
    var item = dat as Map<String, dynamic>;
    val.clear();
    map3['keys'].forEach(
        (key) => val.add(item.containsKey(key) ? item[key] : tmpl[key]));
    map3['vals'].add(List.unmodifiable(val));
  }
  for (var row in map3['vals']) {
    map3['rows']
        .add(Map.fromIterables(map3['keys'], row).cast<String, dynamic>());
  }
  return map3;
}


/// 转换列表[lists]且跳过列表[skips]中的每一项为字典的K并赋V值为占位符[replaceholder]
///
///```dart
/// var lists = ['id', 'name', 'title',];
/// var map3 = mapReplaceholderOfList(lists); print(map3); // {'id':'?', 'name':'?', 'title':'?'}
/// var skips = ['title',];
/// var map4 = mapReplaceholderOfList(lists); print(map4); // {'id':'?', 'name':'?',}
///```
Map<String, dynamic> mapReplaceholderOfList(
  List<String> lists, {
  String replaceholder = '?',
  List<String> skips = const [],
}) {
  var sets = lists.toSet();
  var map3 = <String, dynamic>{};
  for (var word in sets) {
    if (!skips.contains(word)) {
      map3[word] = replaceholder;
    }
  }
  return map3;
}
