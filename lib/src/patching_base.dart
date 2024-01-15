part of patching;

/// Put public facing types in this file.

/// 判断一个数[num],是否在最小[min]或最大[max]范围内.
///
/// ```dart
///  isNumBetween(2, 1, 10); // true
///  isNumBetween(2.0, 1.0, 10.0); // true
///  isNumBetween(2, 1.0, 10.0); // true
///  isNumBetween(2.5, 1, 10.5); // true
///  isNumBetween(11, 1, 10); // false
/// ```
bool isNumBetween(num n, min, max) {
  return (n >= min) && (n <= max);
}

/// 替换伪占位符[placeholder]为真占位符[replaceholder]
///
/// SQL替换占位符如"?"为?,且可为增删更语句附加数据返回[returning]子句
/// ```dart
/// // SELECT * FROM users WHERE id=?
/// replaceholder('SELECT * FROM users WHERE id="?"');
/// // DELETE FROM users WHERE id=? RETURNING id, name, email
/// replaceholder('DELETE FROM users WHERE id="?"', returning:['id', 'name', 'email']);
/// ```
String replaceholder(
  String sql, {
  String replaceholders = '?',
  String placeholders = '"?"',
  List<String> returning = const [],
}) {
  var stmt = sql.replaceAll(';', ' ');
  if (stmt.startsWith(RegExp(r'^DELETE', caseSensitive: false))) {
    stmt = stmt.replaceAll(
        RegExp(r'^DELETE', caseSensitive: false), 'DELETE FROM');
  }
  if (returning.isNotEmpty &&
      (sql.startsWith(RegExp(r'^INSERT', caseSensitive: false)) ||
          sql.startsWith(RegExp(r'^UPDATE', caseSensitive: false)) ||
          sql.startsWith(RegExp(r'^DELETE', caseSensitive: false)))) {
    stmt += 'RETURNING ';
    stmt += returning.join(',');
  }
  return stmt.replaceAll(placeholders, replaceholders);
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

/// 批量校验，字典列表[dats]的每一行执行函数校验，若任一项校验失败返回false否则返回true
///
///```dart
/// final rows = [{'a': 1, 'b': 'b2'}, {'a': 11, 'b': 'b22'}, {'a': 111, 'b': 'b0'}];
/// bool Function(Map<String, dynamic>) myfn = myvalidtion;
/// // myfn(Map<String, dynamic> item)=>(item.containsKey('a') && item.containsKey('b') && (item['a'] is int))?true:false;
/// print(batchValidtion(myfn, rows)); // true
/// final rows2 = [{'a': 1, 'b': 'b2'}, {'a': 11, 'c': 'b22'}];
/// print(batchValidtion(myfn, rows2)); // false;
///
/// bool myvalidtion(Map<String, dynamic> item) {
///  if (item.containsKey('a') && item.containsKey('b') && (item['a'] is int)) {
///    return true;
///  }
///  return false;
/// }
///```
bool batchValidtion(
    bool Function(Map<String, dynamic>) validation, List<dynamic> dats) {
  for (Map<String, dynamic> item in dats) {
    if (!validation(item)) {
      return false;
    }
  }
  return true;
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

/// 校验密码是否合规
///
/// 密码规则:至少含1大写字符,至少含1小写字符,至少含1数字,至少含1标点符号(!@#\$&*~)
///```dart
/// isPasswordSecure('Vignesh123!'); // true
/// isPasswordSecure('vignesh123'); // false
/// isPasswordSecure('VIGNESH123!'); // false
/// isPasswordSecure('vignesh@'); // false
/// isPasswordSecure('12345678?'); // false
///```
bool isPasswordSecure(String password) {
  const pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(password);
}

/// 反转字符串[text]
///
/// ```dart
///  strReverse('Hello World'); // dlroW olleH
/// ```
String strReverse(String text) {
  return text.split('').reversed.join('');
}

/// 电子邮箱打码.
///
/// 星号打码邮箱名字部份,长度大于4位打码后4位,小于4位的全打码
/// ```dart
///  emailMaskcode('123456789@qq.com') // 12345****@qq.com
///  emailMaskcode('abc@qq.com') // ***@qq.com
/// ```
String emailMaskcode(String email) {
  var lists = email.split('@');
  var name = lists.first;
  var len = name.length;

  if (len > 4) {
    name = name.replaceRange(len - 4, len, ''.padRight(4, '*'));
  } else {
    name = ''.padRight(len, '*');
  }

  return '$name@${lists[1]}';
}

/// 拆分字符串中的数字到列表
///
/// 用分隔符[pattern]折分字符串列表[text]提取到数字列表中
///```dart
/// splitToIntList('1,2,3'); // [1,2,3]
/// splitToIntList('1,2,3,a,b,c,4'); // [1,2,3,4]
/// splitToIntList('a,b,c,d,'); // []
///```
List<int> splitToIntList(
  String text, [
  String pattern = ',',
]) {
  final strs = text.split(pattern);
  var ints = <int>[];
  RegExp intstr = RegExp(r'^(?:-?(?:0|[1-9][0-9]*))$');
  for (final elem in strs) {
    if (intstr.hasMatch(elem)) {
      ints.add(int.parse(elem));
    }
  }
  return ints;
}
