import 'dart:async';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noonsaegim/page9/mynote.dart';
import 'package:noonsaegim/push_alert/manage_notification.dart';
import 'package:noonsaegim/push_alert/setting_notification.dart';
import 'package:noonsaegim/setting/note_argument.dart';
import '../../common/drawer.dart';
import '../../common/noon_appbar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:math' as math;
import '../common/popup.dart';
import 'alert.dart';
import 'feedback.dart';
import 'package:sizer/sizer.dart';
import '../setting/cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../setting/notif_on_off.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _cache;
  var _notif;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await SharedPreferences.getInstance()
          .then((SharedPreferences pref) {
            setState(() {
              _cache = pref.getInt('cacheableDays') ?? 1;
              _notif = pref.getBool('notification') ?? false;
            });
      });
    });
  }

  //멤버 필드 : 알람 여부, 캐시 일수 ..
  final List _cacheable = List.generate(5, (index) => '${index+1} 일');

  _showCacheablePeriodPicker(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: _cacheable
      ),
      hideHeader: true,
      title: Text('캐시 기간 설정',textAlign: TextAlign.center,),
      onConfirm: (Picker picker, List value) async {
        await cacheable.setCacheable(value[0] + 1);
        print(picker.getSelectedValues());
      }
    ).showDialog(context);
  }

 _renderAddAlarmNextButtonByStatus(context, bool isOn) {
    if(isOn) {
      return IconButton(
              onPressed: () => notif.setVocabularyAlert(context),
          tooltip: 'next-active',
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.lightBlueAccent,),
          ),
        );
    } else {
      return IconButton(
        onPressed: () => alert.onError(context, "알림이 비활성화 상태입니다."),
        tooltip: 'next',
        icon: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
        ),
      );
    }
  }

  _renderSettingAlarmNextButtonByStatus(context, bool isOn) {
    if(isOn) {
      return IconButton(
        onPressed: () => notif.manageAlertSettings(context),
        tooltip: 'next-active',
        icon: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.lightBlueAccent,),
        ),
      );
    } else {
      return IconButton(
        onPressed: () => alert.onError(context, "알림이 비활성화 상태입니다."),
        tooltip: 'next',
        icon: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
        ),
      );
    }
  }

  Future onSelectNotification(String? payload) async {
    print('[onSelectNotification] payload: $payload');
    var detail = await flip.getNotificationAppLaunchDetails();
    if(detail?.didNotificationLaunchApp as bool) {
       //MaterialPageRoute<void>(builder: (context) => MyNote(), settings: RouteSettings(arguments: NoteArgument(seq: int.parse(detail?.payload ?? payload!))));
       await Navigator.pushNamed(context, '/mynote', arguments: NoteArgument(seq: int.parse(detail?.payload ?? payload!)));
    }
  }

  _init(Stream<bool> isOn) {
    isOn.listen((value) async {
      if(value) {
        await flip.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
          ()?.createNotificationChannel(channel).then((value) => print('----createNotificationChannel----'));

        //Initialization Settings for Android
        final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

        //Initialization Settings for iOS
        final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

        //InitializationSettings for initializing settings for both platforms (Android & iOS)
        final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

        await flip.initialize(
            initializationSettings, onSelectNotification: onSelectNotification)
        .then((value) => print('-----init notification----')).then((value) async {
          await SharedPreferences.getInstance().then((SharedPreferences pref) {
            pref.setBool('notification', true);
          });
        });
      } else if(!value) {
        allOff();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar1(),
      body: Padding(
          padding: EdgeInsets.fromLTRB(12.0.sp, 18.0.sp, 12.0.sp, 20.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.0,
                        //spreadRadius: 0.4,
                        offset: Offset(0.0, 7),
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.black12,
                          child: StreamBuilder<bool>(
                              stream: on.isOn,
                              builder: (context, snapshot) {
                              if(snapshot.connectionState != null) {
                                final _isOn = snapshot.data ?? _notif;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 18.0.sp, right: 16.5.sp, top: 3.5.sp),
                                      height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) * 0.11,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '나의 단어장 알림 활성화',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FlutterSwitch(
                                            showOnOff: true,
                                            activeColor: Colors.lightBlueAccent,
                                            inactiveColor: Colors.grey,
                                            value: _isOn,
                                            onToggle: (value) async {
                                              await on.setOnAndOff(value);
                                              _init(on.isOn);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 15.0.sp, right:15.0.sp),
                                      height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) * 0.01,
                                      child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5,),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 18.0.sp, right: 5.0.sp),
                                      height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) * 0.1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '단어장 알림 추가',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          _renderAddAlarmNextButtonByStatus(context, _isOn),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 15.0.sp, right:15.0.sp),
                                      height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) * 0.01,
                                      child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5,),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 18.0.sp, right: 5.0.sp, bottom: 3.5.sp),
                                      height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) * 0.11,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '단어장 알림 설정',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          _renderSettingAlarmNextButtonByStatus(context, _isOn),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }
                          ),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.0.sp,),
              Container(
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      //spreadRadius: 0.4,
                      offset: Offset(0.0, 7),
                    )
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 15.5.sp, right: 5.0.sp),
                            height: (MediaQuery.of(context).size.height -
                                AppBar().preferredSize.height -
                                MediaQuery.of(context).padding.top) * 0.11,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '최근 조회한 단어 캐시 기간 설정',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    StreamBuilder<int>(
                                        stream: cacheable.days,
                                        builder: (context, snapshot) {
                                          if(snapshot.connectionState != null) {
                                            final days = snapshot.data ?? _cache;
                                            return Text(
                                              '$days 일',
                                              style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 10.8.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.right,
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        }
                                    ),
                                    IconButton(
                                      onPressed: () => _showCacheablePeriodPicker(context),
                                      tooltip: 'next-active',
                                      icon: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.0.sp,),
              Container(
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      //spreadRadius: 0.4,
                      offset: Offset(0.0, 7),
                    )
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 18.0, right: 5.0),
                          height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) * 0.11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '피드백',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () => feedback.showFeedBackDiaglog(context),
                                tooltip: 'next-active',
                                icon: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
      )
    );
  }
}
