part of '../patching.dart';
/* import 'dart:convert';
import 'package:crypto/crypto.dart'; */

/// 将字符串[text]生成MD5哈稀摘要.
///
/// ```dart
///  md5gen('abcdefg'); // 7ac66c0f148de9519b8bd264312c4d64
/// ```
String md5gen(String text) {
  return md5.convert(utf8.encode(text)).toString();
}
