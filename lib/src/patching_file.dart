part of '../patching.dart';

/// 删除文件[filename]，自适配路径信息，成功返回true，否则返回false
///
/// ```dart
///  deleteFile('/tmp/temp.txt'); // if exist return true
///  deleteFile('file:///tmp/temp.txt'); // if exist return true
///  deleteFile('http://www.example.com/readmd.txt'); // false
/// ```
bool fileDelete(String filename) {
  if (filename.isEmpty) return false;
  if (filename.startsWith('http')) return false;

  late final File file;
  if (filename.startsWith('file:')) {
    final uri = Uri.tryParse(filename);
    if (uri != null) file = File.fromUri(uri);
  } else {
    file = File(filename);
  }

  bool deleted = false;
  try {
    if (file.existsSync()) {
      file.deleteSync();
      deleted = true;
    }
  } catch (e) {
    // ignore: avoid_print
    print('deletefile failure, $e');
  }

  return deleted;
}

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

/// 列出列表[files]中文件名与大小的元组
///
/// 若[exists]为true则文件列表[files]必须都存在.
/// 1M = 1024*1024*1.
/// ```dart
///  fileSizeLists(['/etc/hosts', '/etc/notexist']); // [('/etc/hosts',512)]
/// ```
List<(String, int)> fileSizeLists(List<String> files, [bool exists = false]) {
  if (!exists) files = fileExists(files);
  return files.map((e) => (e, File(e).lengthSync())).toList();
}

/// 合计文件大小元组[fileSizeLists]总大小
///
/// 若[exists]为true则文件列表[files]必须都存在.
/// 1M = 1024*1024*1.
/// ```dart
///  fileSizeLists([('/etc/hosts',512)，('/etc/profile',256)]); // 768
/// ```
int fileSizeFromLists(List<(String, int)> fileSizeLists) {
  return fileSizeLists.fold(0, (a, b) => a + b.$2);
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
