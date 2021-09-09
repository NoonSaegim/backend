import 'package:flutter/material.dart';
import 'package:noonsaegim/push_alert/setting_notification.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

class AlertSetting with ChangeNotifier {


  String _title = '';
  String _noteKey = '';
  String _time = '';
  String _cycle = '';
  bool _repeat = false;

  String get title => _title;
  String get noteKey => _noteKey;
  String get time => _time;
  String get cycle => _cycle;
  bool get repeat => _repeat;

  void setTitle(String newTitle){
    _title = newTitle;
    print('-------setTitle---------');
    notifyListeners();
  }
  void setNoteKey(String noteKey) {
    _noteKey = noteKey;
    print('-------setNoteKey---------');
    notifyListeners();
  }
  void setTime(String newTime) {
    _time = newTime;
    print('-------setTime---------');
    notifyListeners();
  }
  void setCycle(String newCycle) {
    _cycle = newCycle;
    print('-------setCycle---------');
    notifyListeners();
  }

  void setRepeat(bool isRepeat) {
    _repeat = isRepeat;
    print('-------setRepeat---------');
    notifyListeners();
  }
}

var setting = AlertSetting();