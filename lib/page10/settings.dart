import 'package:flutter/material.dart';
import '../../common/drawer.dart';
import '../../common/noon_appbar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:math' as math;
import '../common/alert.dart';
import 'alarm.dart';
import 'feedback.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //멤버 필드 : 알람 여부, 캐시 일수 ..
  bool _alarmStatus = false;
  final List _cacheable = List.generate(5, (index) => '${index+1} 일');
  int _cacheSave = 3;

  _showCacheablePeriodPicker(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: _cacheable
      ),
      hideHeader: true,
      title: Text('캐시 기간 설정',textAlign: TextAlign.center,),
      onConfirm: (Picker picker, List value) {
        print(value[0]);
        setState(() {
          _cacheSave = value[0] + 1;
        });
        print(picker.getSelectedValues());
      }
    ).showDialog(context);
  }

 _renderAddAlarmNextButtonByStatus(context) {
    if(_alarmStatus) {
      return IconButton(
        onPressed: () => alarm.setVocabularyAlarm(context),
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

  _renderSettingAlarmNextButtonByStatus(context) {
    if(_alarmStatus) {
      return IconButton(
        onPressed: () => alarm.manageAlarmSettings(context),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar1(),
      body: Padding(
          padding: EdgeInsets.only(top:20.0, left: 16.0, right: 16.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.37,
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
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 18.0, right: 18.0),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    FlutterSwitch(
                                        showOnOff: true,
                                        activeColor: Colors.lightBlueAccent,
                                        inactiveColor: Colors.grey,
                                        value: _alarmStatus,
                                        onToggle: (value) => setState(() => _alarmStatus = value),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                height: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height -
                                    MediaQuery.of(context).padding.top) * 0.01,
                                child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5,),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 18.0, right: 5.0),
                                height: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height -
                                    MediaQuery.of(context).padding.top) * 0.11,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '단어장 알림 추가',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    _renderAddAlarmNextButtonByStatus(context),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                height: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height -
                                    MediaQuery.of(context).padding.top) * 0.01,
                                child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5,),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 18.0, right: 5.0),
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    _renderSettingAlarmNextButtonByStatus(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0,),
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
                                  '최근 조회한 단어 캐시 기간 설정',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '$_cacheSave 일',
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 13.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
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
              const SizedBox(height: 16.0,),
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
                                  fontSize: 15,
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
