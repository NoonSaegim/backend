import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'dart:convert';
import '../common/popup.dart';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:noonsaegim/setting/alert_setting.dart';
import '../setting/alert_list.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'weekday_picker.dart';

class Alarm{

  final format = DateFormat.jm();

  final TextEditingController _typeAheadController = TextEditingController();
  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  var _timeJson;

  Alarm() {
    _timeJson = '''[
      [ "AM","PM" ],
      ${hours.toString()},
      ${minutes.toString()}  
    ]''';
  }

  showAlarmTimePicker(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(_timeJson), isArray: true
        ),
        hideHeader: true,
        title: Text('알림 시간 설정',textAlign: TextAlign.center,),
        onConfirm: (Picker picker, List value) {
          var values = picker.getSelectedValues();
          String _time = '${values[1]}:${values[2] == '0' ? '00' : values[2]} ${values[0]}';
          print(_time);

          Provider.of<AlarmSetting>(context, listen: false).setTime(_time);
        }
    ).showDialog(context);
  }

  showAlarmCyclePicker(BuildContext context) {
    final values = <bool?>[null, false, true, false, true, false, null];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('알람 주기 설정', textAlign: TextAlign.center,),
            titlePadding: EdgeInsets.only(top: 30.0),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                WeekDayPicker(),
              ],
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ButtonTheme(
                      child: DialogButton(
                        height: 35.0.sp,
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.lightBlueAccent,
                        child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ),
                    ButtonTheme(
                        child: DialogButton(
                          height: 35.0.sp,
                          width: MediaQuery.of(context).size.width * 0.25,
                          color: Colors.lightBlueAccent,
                          child: Text('CLOSE', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 6.0,),
            ],
          );
        }
    );
  }

  manageAlarmSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: Text('단어장 알림 설정', textAlign: TextAlign.center,),
              titlePadding: EdgeInsets.only(top: 30.0),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: (MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top) * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          bool _active = false;
                          setActive(bool value) => _active = value;
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.alarm, color: _active ? Colors.lightBlueAccent : Colors.grey,),
                              title: Text('Test Period'),
                              subtitle: Text('words about fashion'),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: FlutterSwitch(
                                  //showOnOff: true,
                                  activeColor: Colors.lightBlueAccent,
                                  inactiveColor: Colors.grey,
                                  value: _active,
                                  onToggle: (value) => setActive(value),
                                ),
                              ),
                            ),
                          );
                        }
                    )
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonTheme(
                        child: DialogButton(
                          height: 35.0.sp,
                          width: MediaQuery.of(context).size.width * 0.25,
                          color: Colors.lightBlue,
                          child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () => alert.onSuccess(context, "알림이 저장되었습니다."),
                        ),
                      ),
                      ButtonTheme(
                          child: DialogButton(
                            height: 35.0.sp,
                            width: MediaQuery.of(context).size.width * 0.25,
                            color: Colors.lightBlue,
                            child: Text('CLOSE', style: TextStyle(color: Colors.white, fontSize: 16)),
                            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6.0,),
              ],
          );
        }
    );
  }

  _getSuggestion(var pattern) {
    return [
      'United States',
      'America',
      'Washington',
      'India',
      'Paris',
      'Jakarta',
      'Australia',
      'Lorem Ipsum'
    ];
  }

  Future setVocabularyAlarm(BuildContext context) async{
    showDialog(
        context: context,
        builder: (BuildContext context) {

          final String _time = context.select((AlarmSetting alarm) => alarm.time);
          final String _cycle = context.select((AlarmSetting alarm) => alarm.cycle);

          return AlertDialog(
            scrollable: true,
            title: Text('단어장 알림 추가', textAlign: TextAlign.center,),
            titlePadding: EdgeInsets.only(top: 25.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) => {
                      Provider.of<AlarmSetting>(context, listen: false).setTitle(value),
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title_rounded, color: Colors.lightBlue),
                      labelText: '제목',
                      hintText: '알람 제목을 작성하세요',
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: this._typeAheadController,
                          decoration: InputDecoration(
                              labelText: '단어장 제목',
                          )
                      ),
                      suggestionsCallback:(pattern) => _getSuggestion(pattern) ,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                        );
                      },
                      onSuggestionSelected: (suggestion) => {
                        this._typeAheadController.text = suggestion.toString(),
                        Provider.of<AlarmSetting>(context, listen: false).setNoteKey(suggestion.toString()),
                      },
                  ),
                  SizedBox(height: 12.0,),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.alarm_on, color: Colors.lightBlue,),
                      title: Text('시간 설정', style: TextStyle(color: Colors.black54, fontSize: 11.sp)),
                      onTap: () => alarm.showAlarmTimePicker(context),
                      trailing: Text('$_time', style: TextStyle(color: Colors.black45, fontSize: 10.sp)),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today_outlined, color: Colors.lightBlue,),
                      title: Text('주기 설정', style: TextStyle(color: Colors.black54,)),
                      onTap: () => alarm.showAlarmCyclePicker(context),
                      trailing: Text('$_cycle', style: TextStyle(color: Colors.black45, fontSize: 10.sp)),
                    ),
                  ),
                ]
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ButtonTheme(
                      child: DialogButton(
                        height: 35.0.sp,
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.lightBlue,
                        child: Text('OK', style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () => alert.onSuccess(context, "알림이 등록되었습니다."),
                      ),
                    ),
                    ButtonTheme(
                        child: DialogButton(
                          height: 35.0.sp,
                          width: MediaQuery.of(context).size.width * 0.25,
                          color: Colors.lightBlue,
                          child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () => {
                            Navigator.of(context, rootNavigator: true).pop(),

                            //form 초기화
                            this._typeAheadController.text = '',
                            Provider.of<AlarmSetting>(context, listen: false).setTitle(''),
                            Provider.of<AlarmSetting>(context, listen: false).setNoteKey(''),
                            Provider.of<AlarmSetting>(context, listen: false).setTime(''),
                            Provider.of<AlarmSetting>(context, listen: false).setCycle(''),
                          },
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 6.0,),
            ],
          );
        }
    );
  }
}

Alarm alarm = new Alarm();