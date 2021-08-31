import 'package:flutter/material.dart';
import './alert_setting.dart';

class AlarmList with ChangeNotifier {
  List<AlarmSetting> _alarmList = [];

  get alarmList => _alarmList;
  get getSize => _alarmList.length;

  AlarmSetting getAlarm(int index){
    if(_alarmList.isNotEmpty && _alarmList.length >= index) {
      return _alarmList[index];
    }
    else throw Exception('알람 갯수가 $index 개보다 적습니다.');
  }

  void addAlarm(AlarmSetting alarm) {
    _alarmList.add(alarm);
    notifyListeners();
  }

  void updateAlarm(int index, AlarmSetting alarm) {
    _alarmList[index] = alarm;
    notifyListeners();
  }
}
