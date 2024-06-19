part of '../patching.dart';

class Tmpl {
  final Map<String, String> variables;
  Tmpl(this.variables);

  /// 对字符串模板中的变量求值
  ///
  /// ```dart
  /// var template = 'Hello {{name}}! You are {{age}} years old.';
  /// var variables = {'name': 'John','age': '25'};
  /// var result = Tmpl(variables).tmpl(template);
  /// print(result); // Hello John! You are 25 years old.
  /// ```
  String tmpl(String template) {
    // 合法的Dart变量名，通常由字母、数字和下划线组成，且开头必须是字母或下划线
    const pattern = r'\{\{([a-zA-Z_]\w*)}}';
    return template.replaceAllMapped(RegExp(pattern), (match) {
      final variableName = match.group(1);
      if (variables.containsKey(variableName)) {
        return variables[variableName]!;
      }
      return match.input;
    });
  }

  /// 找出字符串模板中的所有变量名
  ///
  ///应用场景有二, 一.找出模板中的全部变量名, 二.在模板求值后查一次还有那些未处理(即缺失变量)
  /// ```dart
  /// var template = 'Hello {{name}}! You are {{age}} years old.';
  /// var variables = {'name': 'John','age': '25'};
  /// var result = Tmpl(variables).vars(template);
  /// print(result); // [name, age].
  /// ```
  List<String?> vars(String template) {
    const pattern = r'\{\{([a-zA-Z_]\w*)}}';
    return RegExp(pattern).allMatches(template).map((match) => match.group(1)).where((elem) => elem != null).toList();
  }

  /// 对键值对类型的values中变量求值
  ///
  /// ```dart
  /// var header = {'Authorization': 'Basic {{apikey}}'};
  /// var variables = {'apikey': 'QWxhZGRpbjpvcGVuIHNlc2FtZQ==', 'age': '25'};
  /// final headerNew = Tmpl(variables).vals(header);
  /// print(headerNew); // {Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==}
  /// ```
  Map<String, String> vals(Map<String, String> param) {
    return Map.fromEntries(
      param.entries.map(
        (entry) => MapEntry(
          entry.key,
          tmpl(entry.value),
        ),
      ),
    );
  }

  /// 对url模板求值
  ///
  /// ```dart
  /// var urltmpl = '{{apiaddr}}/product';
  /// var urlparam = {'limit': '10', 'offset': '{{offset}}'};
  /// var variables = {'apiaddr': 'http://localhost:8080/v1', 'offset': '30'};
  /// final url = Tmpl(variables).url(urltmpl, urlparam);
  /// print(url); // http://localhost:8080/v1/product?limit=10&offset=30
  /// ```
  String url(String url, [Map<String, String>? param]) {
    final urltext = tmpl(url);
    if (param != null) {
      final paramNew = vals(param);
      final qs = Uri(queryParameters: paramNew).query;
      return Uri.parse(urltext).resolve('?$qs').toString();
    }
    return urltext;
  }

  // cls_lastline
}
