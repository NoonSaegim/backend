import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

final Map<String, dynamic> week = {
  '월': 1,
  '화': 2,
  '수': 3,
  '목': 4,
  '금': 5,
  '토': 6,
  '일': 7,
  '주말': [6,7],
  '평일': List<int>.generate(5, (index) => index + 1),
  '매일': [24],
};
final FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'noon_push',
  'Vocabulary Notifications',
  'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initWorkManager(String uid, VoidCallback taskExecutor, String taskName, bool repeat, Duration duration) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
      taskExecutor,
      isInDebugMode: true
  ).then((value) => print('----Workmanager initialize----'));

  if(repeat) {
    await Workmanager().registerPeriodicTask(
      uid,
      taskName,
      frequency: duration,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      tag: "voca",
    ).then((value) => print('----Workmanager registerOneOffTask----'))
    .then((value) async {
      final pref = await SharedPreferences.getInstance();
      List<String> notifList = pref.getStringList('notifList') ?? [];
      notifList.add('$taskName:$uid');
      pref.setStringList('notifList', notifList);
      print('-----notifList: $notifList----');
    });
  } else {
    await Workmanager().registerOneOffTask(
      uid,
      taskName,
      initialDelay: duration,
      tag: "voca"
    ).then((value) => print('----Workmanager registerOneOffTask----'));
  }
}

void isOff() {
  Workmanager().cancelAll();
}

void turnOff(String uid) {
  Workmanager().cancelByUniqueName(uid);
}

var _title;
var _noteKey;
var _seq;

Future<void> setNewAlert(int seq, String title, String noteKey, String time, String cycle, bool repeat) async {
  print('setNewAlert start--- seq: $seq / title:$title / noteKey: $noteKey / time: $time / cycle: $cycle / repeat: $repeat');
  _seq = seq;
  _title = title;
  _noteKey = noteKey;

  String uid = Uuid().v4();
  var duration;
  final DateTime now = DateTime.now();
  final year= now.year;
  final month = now.month;
  final day = now.day;
  final weekday = now.weekday;
  print(time);
  int absoluteHour = time.contains('PM') ? 12 : 0;
  print(time.split(' ')[0].split(':')[0]);
  absoluteHour += int.parse(time.split(' ')[0].split(':')[0]);
  final absoluteMinute = int.parse(time.split(' ')[0].split(':')[1]);

  List<int> days = _getDays(cycle);
  print('days: $days');
  if(days.length == 1) {
    duration = _getDurationIfOneDay(days[0], year, month, day, weekday, absoluteHour, absoluteMinute, now);
    initWorkManager(uid, callbackDispatcher, title, repeat, duration);

  } else {
    duration = List<Duration>.generate(days.length, (index) {
       return _getDurationIfOneDay(days[index], year, month, day, weekday, absoluteHour, absoluteMinute, now);
    });
    for(int i =0; i < duration.length; i++) {
      initWorkManager(Uuid().v4(), callbackDispatcher, '$title@$i', repeat, duration[i]);
    }
  }
}

void callbackDispatcher() {
  print('----callbackDispatcher----');
  Workmanager().executeTask((task, inputData) {

    showNotificationWithSchedule(flip, _title, _noteKey, _seq);
    return Future.value(true);
  });
}

Future showNotificationWithSchedule(flip, String title, String noteKey, int seq) async {
  print('-----showNotificationWithSchedule-------');
  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    channel.id,
    channel.name,
    channel.description,
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
    vibrationPattern: vibrationPattern,
    enableLights: true,
    playSound: false,
    icon: 'app_icon',
    largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    styleInformation: MediaStyleInformation(
      htmlFormatTitle: true,
      htmlFormatContent: true,
    ),
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );

  await flip.show(0, '$title',
      '나의 단어장 - $noteKey',
      platformChannelSpecifics, payload: '$seq'
  );
}

List<int> _getDays(String cycle) {
  if(cycle.contains(',')) {
    return cycle.split(', ').map((e) => int.parse(e)).toList();
  } else {
    switch(cycle) {
      case '평일': return week['평일'] as List<int>;
      case '주말': return week['주말'] as List<int>;
      case '매일': return week['매일'] as List<int>;
      default: {
        int value = week[cycle] as int;
        return [value];
      }
    }
  }
}

Duration _getDurationIfOneDay(int value, int year, int month, int day, int weekday, int absoluteHour, int absoluteMinute, DateTime now){
  print('value: $value / $year-$month-$day ($weekday) / time- $absoluteHour:$absoluteMinute / now: $now');
  var duration;
  if(value == 24) {
    duration = DateTime(year, month, day+1, absoluteHour, absoluteMinute).difference(now);
  } else {
    var targetWeekDay = value;
    if(weekday == targetWeekDay) duration = DateTime(year, month, day+7, absoluteHour, absoluteMinute).difference(now);
    else if(weekday > targetWeekDay) {
      switch(weekday) {
        case 7: {
          duration = DateTime(year, month, day + targetWeekDay, absoluteHour, absoluteMinute).difference(now);
          break;
        }
        case 6: {
          duration = DateTime(year, month, day + targetWeekDay + 1, absoluteHour, absoluteMinute).difference(now);
          break;
        }
        case 5: {
          duration = DateTime(year, month, day + targetWeekDay + 2, absoluteHour, absoluteMinute).difference(now);
          break;
        }
        case 4: {
          duration = DateTime(year, month, day + targetWeekDay + 3, absoluteHour, absoluteMinute).difference(now);
          break;
        }
        case 3: {
          duration = DateTime(year, month, day + targetWeekDay + 4, absoluteHour, absoluteMinute).difference(now);
          break;
        }
        case 2: {
          duration = DateTime(year, month, day + targetWeekDay + 5, absoluteHour, absoluteMinute).difference(now);
          break;
        }
      }
    } else if(weekday < targetWeekDay) {
      duration = DateTime(year, month, day + (targetWeekDay - weekday), absoluteHour, absoluteMinute).difference(now);
    }
  }
  print('duration: $duration');
  return duration;
}