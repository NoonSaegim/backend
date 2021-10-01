import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'setting_duration.dart';


void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await showNotificationWithSchedule(flip, inputData?['title'] as String, inputData?['noteTitle'] as String, inputData?['seq'] as int);
    return Future.value(true);
  });
}

final FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'noon_push',
  'Vocabulary Notifications',
  'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initWorkManager(int seq, String uid, String taskName, String noteTitle, String? summary, bool repeat, Duration duration) async {

  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true
  ).then((value) => print('----Workmanager initialize----'));

  Map<String , dynamic> inputData = {
    'title': taskName.contains('@') ? taskName.split('@')[0] : taskName,
    'noteTitle': noteTitle,
    'seq': seq,
  };

  if(repeat) {
    await Workmanager().registerPeriodicTask(
      uid,
      taskName,
      initialDelay: duration,
      frequency: duration,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      tag: "voca",
      backoffPolicy: BackoffPolicy.exponential, backoffPolicyDelay: Duration(seconds: 10),
      inputData: inputData,
    ).then((value) => print('[Workmanager] 반복 알림을 등록했습니다.'))
        .then((value) async {
      final pref = await SharedPreferences.getInstance();
      List<String> notifList = pref.getStringList('notifList') ?? [];
      notifList.add('${inputData['title']}#$seq#$summary#$uid#$noteTitle');
      /// 나중에 알림 설정 해지 및 복구를 위해서 'title, seq, summary, uid, noteTitle' 저장!
      pref.setStringList('notifList', notifList);
      print('-----notifList: $notifList----');
    });
  } else {
    await Workmanager().registerOneOffTask(
      uid,
      taskName,
      //initialDelay: duration,
      tag: "voca",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.exponential, backoffPolicyDelay: Duration(seconds: 10),
      inputData: inputData
    ).then((value) => print('[Workmanager] 일회성 알림을 등록했습니다.'));
  }
}

Future<void> setAlert(int seq, String title, String noteKey, String time, String cycle, bool repeat) async {
  print('setNewAlert start--- seq: $seq / title:$title / noteKey: $noteKey / time: $time / cycle: $cycle / repeat: $repeat');

  String summary = '$time@$cycle';
  print('summary: $summary');
  String uid = Uuid().v4();
  var duration;
  final DateTime now = DateTime.now();
  final year= now.year;
  final month = now.month;
  final day = now.day;
  final weekday = now.weekday;

  int absoluteHour = time.contains('PM') ? 12 : 0;
  absoluteHour += int.parse(time.split(' ')[0].split(':')[0]);
  final absoluteMinute = int.parse(time.split(' ')[0].split(':')[1]);

  List<int> days = diff.getDays(cycle);
  print('days: $days');
  if(days.length == 1) {
    duration = diff.getDurationIfOneDay(days[0], year, month, day, weekday, absoluteHour, absoluteMinute, now);
    await initWorkManager(seq, uid, title, noteKey, '${summary.split('@')[0]} ${summary.split('@')[1]}', repeat, duration);

  } else {

    duration = List<Duration>.generate(days.length, (index) {
      return diff.getDurationIfOneDay(days[index], year, month, day, weekday, absoluteHour, absoluteMinute, now);
    });
    String summaryPrefix = summary.split('@')[0];
    List<String> summarySuffix = diff.getWeekDays(summary.split('@')[1]);
    print(summarySuffix);

    if(duration?.length > 0 && duration?.length == summarySuffix.length){

      for(int i = 0; i < duration.length; i++) {
        await initWorkManager(seq, Uuid().v4(), '$title@$i', noteKey, '$summaryPrefix ${summarySuffix[i]}', repeat, duration[i]);
      }
    }
  }
}

/// 0: uid, 1: seq, 2: title, 3: noteKey, 4: time, 5: cycle, bool, repeat
Future<void> setAlertByUid(String uid,int seq, String title, String noteKey, String time, String cycle, bool repeat) async {
  print('setAlertByUid start--- uid: $uid / seq: $seq / title:$title / noteKey: $noteKey / time: $time / cycle: $cycle / repeat: $repeat');

  String summary = '$time#$cycle';
  print('summary: $summary');
  var duration;
  final DateTime now = DateTime.now();
  final year= now.year;
  final month = now.month;
  final day = now.day;
  final weekday = now.weekday;

  int absoluteHour = time.contains('PM') ? 12 : 0;
  absoluteHour += int.parse(time.split(' ')[0].split(':')[0]);
  final absoluteMinute = int.parse(time.split(' ')[0].split(':')[1]);

  List<int> days = diff.getDays(cycle);
  print('days: $days');
  if(days.length == 1) {
    duration = diff.getDurationIfOneDay(days[0], year, month, day, weekday, absoluteHour, absoluteMinute, now);
    await initWorkManager(seq, uid, title, noteKey, '${summary.split('#')[0]} ${summary.split('#')[1]}', repeat, duration);
  } else {
    throw Exception('알림을 다시 설정하는데 오류가 발생했습니다. 파라미터를 확인하세요.');
  }
}

Future<void> showNotificationWithSchedule(flip, String title, String noteKey, int seq) async {
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
    groupAlertBehavior: GroupAlertBehavior.all,
    enableLights: true,
    playSound: false,
    icon: 'app_icon',
    color: Colors.lightBlue,
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










