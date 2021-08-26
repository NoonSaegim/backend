import 'package:flutter/material.dart';

class AlarmSetting with ChangeNotifier {

  String _title = '';
  String _noteKey = '';
  String _time = '';
  String _cycle = '';

  String get title => _title;
  String get noteKey => _noteKey;
  String get time => _time;
  String get cycle => _cycle;

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
}