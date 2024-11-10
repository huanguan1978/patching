part of '../patching.dart';

/// 把一个布尔字符串[name]，转为bool类型.
///
/// 注意:字符串不区分大小写，
/// 返回false, 字符串为"0"，"false"，"no"，"off"。 其余视为true
/// ```dart
///  toBool(''); // false
///  toBool('false'); // false
///  toBool('False'); // false
///  toBool('1'); // true
///  toBool('true'); // true
///  toBool('True'); // true
///  toBool('a'); // true
/// ```
bool toBool(String name) {
  name = name.trim().toLowerCase();
  if (name.isEmpty) return false;
  if (name == '0') return false;
  if (name == 'false') return false;
  if (name == 'no') return false;
  if (name == 'off') return false;
  return true;
}

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

/// 判断一个email是否合法.
///
/// ```dart
///  isEmail('abc@gmail.com'); // true
///  isEmail('abc.g@gmail.com'); // true
///  isEmail('abc.g@gmail'); // false
///  isEmail('abc.g@gmail.'); // false
///  isEmail('@gmail.com'); // false
/// ```
bool isEmail(String email) {
  int atIndex = email.indexOf('@');
  if (atIndex < 1) return false;
  int dotIndex = email.lastIndexOf('.');
  return (dotIndex > atIndex + 1) && (dotIndex < email.length - 1);
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

/// 随机生成一个六位数
///
/// ```dart
///  rndALNUM6(); // 167512
///  rndALNUM6(); // 019579
/// ```
String rndALNUM6() {
  return Random().nextInt(999999).toString().padLeft(6, '0');
}

/// 生成微秒级即16位时间戳
///
/// ```dart
///  timestamp16(); // 1713569653612589
///  timestamp16(); // 1713569689768266
/// ```
int timestamp16() {
  final randInt = Random.secure().nextInt(999);
  final msts = DateTime.timestamp().microsecondsSinceEpoch + randInt;
  return msts;
}

/// 将控制字符替换为对应的转义序列
///
/// ```dart
///  escapeBackslash(r'hello\nworld'); // 'hello\\nworld'
/// ```
String escapeBackslash(String text) {
  String escapedText = text
      .replaceAll('\n', '\\\\n')
      .replaceAll('\r', '\\\\r')
      .replaceAll('\t', '\\\\t');
  return escapedText;
}

/// 替换文件名但保留扩展名
///
/// ```dart
///  replaceFileName('abc.jpg', '1234'); // 1234.jpg
///  replaceFileName('abc.bak.jpg', '1234'); // 1234.jpg
///  replaceFileName('abc', '1234'); // abc
/// ```
String replaceFileName(String fileName, String newName) {
  // 使用正则表达式提取文件名部分
  int lastDotIndex = fileName.lastIndexOf('.');
  if (lastDotIndex != -1) {
    String extension = fileName.substring(lastDotIndex);
    String newFileName = '$newName$extension';
    return newFileName;
  }

  return fileName;
}

/// 自增字符串[id]
///
/// ```dart
///  autoIncrVal('abc'); // abc1
///  autoIncrVal('abc1'); // abc2
///  autoIncrVal('def123'); // def124
/// ```
String autoIncrVal(String id) {
  RegExp regExp = RegExp(r'\d+$');
  RegExpMatch? match = regExp.firstMatch(id);
  if (match != null) {
    String found = match.group(0)!;
    int num = int.parse(found);
    String incrVal = id.substring(0, match.start) + (num + 1).toString();
    return incrVal;
  } else {
    return '${id}1';
  }
}

/// 字符串[word]脱元字符[\]生成SQLITE的LIKE所需文本
///
///```dart
/// print(sqliteLike('a'); // %a%
/// print(sqliteLike('a', postfixPct:false)); // %a
/// print(sqliteLike('a', prefixPct:false)); // a%
/// print(sqliteLike('%10\%%')); // %10%%
/// print(sqliteLike(r'%10\%%')); // %10\%% ESCAPE '\'
///```
///
String sqliteLike(
  String word, {
  bool prefixPct = true,
  bool postfixPct = true,
}) {
  StringBuffer buff = StringBuffer();

  if (prefixPct && !word.startsWith(r'%')) {
    buff.write(r'%');
  }
  // word = RegExp.escape(word);
  buff.write(word);
  if (postfixPct && !word.endsWith(r'%')) {
    buff.write(r'%');
  }

  if (word.contains(r'\')) {
    buff.write(r" ESCAPE '\'");
  }

  return buff.toString();
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
  var stmt = sql
      .replaceAll(';', ' ')
      .replaceAll("\n", ' ')
      .replaceAll('"', '')
      .replaceAll(' , ', ', ');
/*
  if (stmt.startsWith(RegExp(r'^DELETE', caseSensitive: false))) {
    stmt = stmt.replaceAll(
        RegExp(r'^DELETE', caseSensitive: false), 'DELETE FROM');
  }
*/
  if (returning.isNotEmpty &&
      (sql.startsWith(RegExp(r'^INSERT', caseSensitive: false)) ||
          sql.startsWith(RegExp(r'^UPDATE', caseSensitive: false)) ||
          sql.startsWith(RegExp(r'^DELETE', caseSensitive: false)))) {
    stmt += 'RETURNING ';
    stmt += returning.join(',');
  }
  return stmt.replaceAll(placeholders, replaceholders);
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
