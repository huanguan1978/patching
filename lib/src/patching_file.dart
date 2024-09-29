part of '../patching.dart';

/// 筛选并返回列表[files]中存在的文件清单.
///
/// ```dart
///  fileExists(['/etc/hosts', '/etc/notexist']); // ['/etc/hosts']
/// ```
List<String> fileExists(List<String> files) =>
    files.where((filename) => File(filename).existsSync()).toList();

/// 合计列表[files]中文件大小(单位为Bytes)
///
/// 若[exists]为true则文件列表[files]必须都存在.
/// 1M = 1024*1024*1.
/// ```dart
///  fileSizes(['/etc/hosts', '/etc/notexist']); // 213
/// ```
int fileSizes(List<String> files, [bool exists = false]) {
  if (!exists) files = fileExists(files);

  final sizes = files.map((filename) => File(filename).lengthSync()).toList();
  final totalSize = sizes.fold(0, (a, b) => a + b);

  return totalSize;
}

/// 文件名[filename]数字化
///
/// ```dart
///  fileNameNumbering('abc.jpg'); // abc_1.jpg
///  fileNameNumbering('abc_1.jpg'); // abc_2.jpg
/// ```
String fileNameNumbering(String filename) {
  final parts = filename.split('.');
  final name = parts.first;
  final extname = parts.last;

  final match = RegExp(r'_\d+$').firstMatch(name);
  if (match == null) {
    return '${name}_1.$extname';
  } else {
    var num = int.parse(match.group(0)!.substring(1));
    num++;
    return '${name.substring(0, match.start)}_$num.$extname';
  }
}

/// 找出文件名清单中[filenames]最后一个匹配[filename]的数字化名文件名
///
/// ```dart
///  var names = ['abc.jpg', 'def.jpg', 'abc.htm', 'abc_1.jpg', 'abc_2.jpg'];
///  filePatternNumbering(names, 'abc.jpg'); // abc_2.jpg
///  filePatternNumbering(names, 'notfound.htm'); // ''
/// ```
String filePatternNumbering(List<String> filenames, String filename) {
  filenames.sort((a, b) => b.compareTo(a)); // 降序排序

  var [baseName, ..._, extName] = filename.split('.');
  final pattern = '^$baseName.*$extName\$';
  final regex = RegExp(pattern);

  return filenames.firstWhere((fileName) {
    return regex.hasMatch(fileName);
  }, orElse: () => '');
}
