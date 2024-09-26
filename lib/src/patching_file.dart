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
