part of patching;

/// JSend标准,成功数据封装[data]
///
/// 成功数据, status值必为success, data值非空必为键值对数据
///```dart
/// var item = {'item':{'name':'alex','age':18,}, };
/// var tdat1 = jsendSuccess(item);
/// print(tdat1); // {status: success, data: {item: {name: alex, age: 18}}} // map.toString
/// print(jsonEncode(tdat1)); // {"status":"success","data":{"item":{"name":"alex","age":18}}}
///
/// var items = {'items':[{'name':'alex','age':18,},{'name':'fiona','age':20,}], };
/// var tdat2 = jsendSuccess(items);
/// print(tdat2); // {status: success, data: {items: [{name: alex, age: 18}, {name: fiona, age: 20}]}}
/// print(jsonEncode(tdat2)); // {"status":"success","data":{"items":[{"name":"alex","age":18},{"name":"fiona","age":20}]}}
///```
Map<String, dynamic> jsendSuccess(Map<String, Object> data) {
  return {
    'status': 'success',
    'data': data,
  };
}

/// JSend标准,失败数据封装[data]
///
/// 成功数据, status值必为fail, data值非空必为键值对数据
///
///```dart
/// var item = {'item':{'name':'email', 'input':'abc.com', 'output':'invalid email'}, };
///
/// var tdat1 = jsendFail(item);
/// print(tdat1); // {status: fail, data: {item: {name: email, input: abc.com, output: invalid email}}}
/// print(jsonEncode(tdat1)); // {"status":"fail","data":{"item":{"name":"email", "input":"abc.com","output":"invalid email"}}}
///
/// var items = {'items':[{'name':'email', 'input':'abc.com', 'output':'invalid email'}, {'name':'zipcode', 'input':'xxxx', 'output':'invalid zipcode'}, ], };
///
/// var tdat2 = jsendFail(items);
///
/// print(tdat2);
/// // {status: fail, data: {items: [{name: email, input: abc.com, output: invalid email}, {name: zipcode, input: xxxx, output: invalid zipcode}]}}
///
/// print(jsonEncode(tdat2));
/// // {"status":"fail","data":{"items":[{"name":"email","input":"abc.com","output":"invalid email"},{"name":"zipcode","input":"xxxx","output":"invalid zipcode"}]}}
///```
Map<String, dynamic> jsendFail(Map<String, Object> data) {
  return {
    'status': 'fail',
    'data': data,
  };
}

/// JSend标准, 错误数据封装[data]
///
/// 成功数据, status值必为error, message值非空
/// 
/// 可选数据, code值为整数错误编号; 可选数据, data值为键值对数据
///```dart
///
/// var tdat1 = jsendError('Unable to communicate with database');
///
/// print(tdat1); // {status: error, message: Unable to communicate with database 
///
/// print(jsonEncode(tdat1)); // {"status" : "error", "message" : "Unable to communicate with database" }
///
/// var dberr = {'item':{'name':'email', 'input':'abc.com', 'output':'UNIQUE constraint failed: user.email, constraint failed (code 2067)'}, };
/// 
/// var tdat2 = jsendError('', code:2067, data:dberr);
/// print(tdat2);
/// // {status: error, message: , code: 2067, data: {item: {name: email, input: abc.com, output: UNIQUE constraint failed: user.email, constraint failed (code 2067)}}}
/// 
/// print(jsonEncode(tdat2));
/// // {"status":"error","message":"","code":2067,"data":{"item":{"name":"email","input":"abc.com","output":"UNIQUE constraint failed: user.email, constraint failed (code 2067)"}}}
///```
Map<String, dynamic> jsendError(String message,
    {int code = 0, Map<String, Object>? data = const {}}) {
  return {
    'status': 'error',
    'message': message,
    'code': code,
    'data': data,
  };
}
