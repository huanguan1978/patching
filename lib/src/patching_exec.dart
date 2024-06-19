part of '../patching.dart';

/*
在dart中调用python
```python
# script.py
import sys
print('Command line arguments:', sys.argv)
print('Hello from Python script!')
sys.exit(0)
```

```dart
void main() async {
  var shellResult = await shellPython('path/to/your/python/script.py', venvPath: 'path/to/your/venv');

  print('Exit code: ${result.exitCode}');
  print('Standard output: ${result.stdout}');
  print('Standard error: ${result.stderr}');
```
*/

class ShellResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  ShellResult(this.exitCode, this.stdout, this.stderr);
}

Future<ShellResult> shellPython(String pyscript, {String? pyvenv}) async {
  var activateScriptPath = pyvenv != null ? '$pyvenv/bin/activate' : null;

  var process = await Process.run(
    'bash',
    [
      '-c',
      '${activateScriptPath != null ? 'source $activateScriptPath && ' : ''}python $pyscript'
    ],
  );

  // 读取进程的标准输出流
  var stdout = await process.stdout.transform(utf8.decoder).join();

  // 读取进程的标准错误流
  var stderr = await process.stderr.transform(utf8.decoder).join();

  // 获取进程的退出代码
  var exitCode = process.exitCode;

  // 返回自定义的ExecutionResult对象
  return ShellResult(exitCode, stdout, stderr);
}
