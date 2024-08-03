part of '../patching.dart';

enum TimeUnit {
  day,
  hour,
  minute,
  second,
}

/// 多久以前
///
/// 单位:枚举TimeUnit值：天,时,分,秒
///```dart
/// timeAgo('2024-01-21 21:10:10'); // TimeUnit.day
/// timeAgo('2024-01-21 21:10:10', TimeUnit.day);
/// timeAgo('2024-01-21 21:10:10', TimeUnit.hour);
/// timeAgo('2024-01-21 21:10:10', TimeUnit.minute);
/// timeAgo('2024-01-21 21:10:10', TimeUnit.second);
///```
int timeAgo(String time, [TimeUnit unit = TimeUnit.day]) {
  DateTime targetDateTime = DateTime.parse(time);
  DateTime currentDate = DateTime.now();

  Duration duration = currentDate.difference(targetDateTime);

  return switch (unit) {
    TimeUnit.day => duration.inDays,
    TimeUnit.hour=> duration.inHours,
    TimeUnit.minute => duration.inMinutes,
    TimeUnit.second => duration.inSeconds,
  };
  
}
