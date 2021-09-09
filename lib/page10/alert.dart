import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noonsaegim/database/dto/voca.dart';
import 'package:noonsaegim/database/hive_module.dart';
import 'package:noonsaegim/push_alert/setting_notification.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../common/popup.dart';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:noonsaegim/setting/alert_setting.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'weekday_picker.dart';
import '../push_alert/manage_notification.dart';

var checkList;

class Alert{

  final format = DateFormat.jm();
  final TextEditingController _typeAheadController = TextEditingController();
  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  var _timeJson;

  Alert() {
    _timeJson = '''[
      [ "AM","PM" ],
      ${hours.toString()},
      ${minutes.toString()}  
    ]''';
  }

  showAlertTimePicker(BuildContext context) {
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

          Provider.of<AlertSetting>(context, listen: false).setTime(_time);
        }
    ).showDialog(context);
  }

  showAlertCyclePicker(BuildContext context) {
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
                        height: 38.0.sp,
                        width: MediaQuery.of(context).size.width * 0.28,
                        color: Colors.lightBlueAccent,
                        child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ),
                    ButtonTheme(
                        child: DialogButton(
                          height: 38.0.sp,
                          width: MediaQuery.of(context).size.width * 0.28,
                          color: Colors.lightBlueAccent,
                          child: Text('CLOSE', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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

  manageAlertSettings(BuildContext context) {

    Future.delayed(Duration.zero, () async {
      final pref = await SharedPreferences.getInstance();
      List<String> notifList = pref.getStringList('notifList') ?? [];
      print('notifList:${notifList.length}개- $notifList');

      checkList = List<bool?>.generate(notifList.length, (index) => true);
      final preCheckList = pref.getStringList('checkList')?.map((e) => e == 'true').toList();
      if(preCheckList != null && preCheckList.isNotEmpty) {
        for (int i = 0; i < preCheckList.length; i++) {
          checkList[i] = preCheckList[i];
        }
      }
      final checkListCopy = [...checkList];
      print('checkList: $checkList / copyList: $checkListCopy');

      if(notifList.isNotEmpty) {
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
                            itemCount: notifList.length,
                            itemBuilder: (BuildContext context, int idx) {
                              return NotifCard(seq: idx, notifInfo: notifList[idx], active: checkList[idx]);
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
                            height: 38.0.sp,
                            width: MediaQuery.of(context).size.width * 0.28,
                            color: Colors.lightBlue,
                            child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                            onPressed: () async {
                              List<String> turnOffList = [];
                              List<String> turnOnList = [];
                              for(int i =0; i < notifList.length; i++) {
                                if(checkList[i] == false && checkList[i] != checkListCopy[i]) {
                                  turnOffList.add(notifList[i].split('#')[3]);
                                }
                                if(checkList[i] == true && checkList[i] != checkListCopy[i]) {
                                  final param = notifList[i].split('#');
                                  final summary = _getSummary(param[2], context) as List<String>;
                                  print('summary: $summary');
                                  /// 'title, seq, summary, uid, noteTitle'
                                  /// 0: uid, 1: seq, 2: title, 3: noteKey, 4: time, 5: cycle,
                                  turnOnList.add(
                                    '${param[3]}#${[param[1]]}#${param[0]}#${param[4]}${summary[0]}#${summary[1]}#true'
                                  );
                                }
                              }
                              if(turnOffList.isNotEmpty){
                                turnOffList.forEach((e) {
                                  turnOff(e);
                                });
                              }
                              if(turnOnList.isNotEmpty){
                                turnOffList.forEach((e) async {
                                  final List<String> param = e.split('#');
                                  await setAlertByUid(param[0], int.parse(param[1]), param[2], param[3], param[4], param[5], param[6] == 'true');
                                });
                              }
                              await SharedPreferences.getInstance().then((SharedPreferences pref){
                                pref.setStringList('checkList', checkList.map((e) => e == true ? "true" : "false").cast<String>().toList());
                              });
                              alert.onSuccess2(context, "알림이 저장되었습니다.", '/settings');
                            },
                          ),
                        ),
                        ButtonTheme(
                            child: DialogButton(
                              height: 38.0.sp,
                              width: MediaQuery.of(context).size.width * 0.28,
                              color: Colors.lightBlue,
                              child: Text('CLOSE', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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
      } else {
        alert.onWarning(context, '반복 설정한 알림이 없습니다!', () { });
      }
    });
  }

  _getSummary(String param, BuildContext context) {
    if(param.contains('PM')) {
      return param.replaceAll(' ', '').split('PM').join('PM ').split(' ');
    } else if(param.contains('AM')) {
      return param.replaceAll(' ', '').split('AM').join('AM ').split(' ');
    } else {
      alert.onError(context, '오류가 발생했습니다. 알림을 설정할 수 없습니다.');
      return;
    }
  }

  //form 초기화
  void initializeForm(BuildContext context) {
    Provider.of<AlertSetting>(context, listen: false).setTitle('');
    Provider.of<AlertSetting>(context, listen: false).setNoteKey('');
    Provider.of<AlertSetting>(context, listen: false).setTime('');
    Provider.of<AlertSetting>(context, listen: false).setCycle('');
    Provider.of<AlertSetting>(context, listen: false).setRepeat(false);
  }

  Future setVocabularyAlert(BuildContext context) async{
    List<Voca> _vocaList = [];
    Future.delayed(Duration.zero, () async {
      _vocaList = await fetchVocaList();
    }).then((value) {

      List<String> _getSuggestion(String pattern) {
        return _vocaList
            .where((e) => e.title.contains(pattern)).map((e) => e.title).toList();
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {

            final String _time = context.select((AlertSetting alarm) => alarm.time);
            final String _cycle = context.select((AlertSetting alarm) => alarm.cycle);

            return AlertDialog(
              scrollable: true,
              title: Text('단어장 알림 추가', textAlign: TextAlign.center,),
              titlePadding: EdgeInsets.only(top: 25.0),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) => {
                        Provider.of<AlertSetting>(context, listen: false).setTitle(value),
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title_rounded, color: Colors.lightBlue),
                        labelText: '제목',
                        hintText: '알람 제목을 작성하세요',
                      ),
                    ),
                    SizedBox(height: 9.5.sp,),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                            labelText: '단어장 제목',
                            //border: OutlineInputBorder(),
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
                        Provider.of<AlertSetting>(context, listen: false).setNoteKey(suggestion.toString()),
                      },
                    ),
                    SizedBox(height: 9.5.sp,),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.alarm_on, color: Colors.lightBlue, size: 25.sp,),
                        title: Text('시간 설정', style: TextStyle(color: Colors.black54, fontSize: 13.sp)),
                        onTap: () => notif.showAlertTimePicker(context),
                        trailing: Text('$_time', style: TextStyle(color: Colors.black45, fontSize: 10.sp)),
                      ),
                    ),
                    SizedBox(height: 5.0.sp,),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.calendar_today_outlined, color: Colors.lightBlue, size: 25.sp,),
                        title: Text('주기 설정', style: TextStyle(color: Colors.black54, fontSize: 13.sp)),
                        onTap: () => notif.showAlertCyclePicker(context),
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
                          height: 38.0.sp,
                          width: MediaQuery.of(context).size.width * 0.28,
                          color: Colors.lightBlue,
                          child: Text('OK', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                          onPressed: () async {

                            var form = Provider.of<AlertSetting>(context, listen: false);
                            if(form.title == '') {
                              alert.onWarning(context, '알림 제목을 작성해주세요', () { }); 
                              return;
                            } else if(form.noteKey == '') {
                              alert.onWarning(context, '알림을 설정할 단어장 제목을 작성(선택)해주세요', () { });
                              return;
                            } else if(form.time == '') {
                              alert.onWarning(context, '알림 시간을 설정해주세요', () { });
                              return;
                            } else if(form.cycle == '') {
                              alert.onWarning(context, '알림 주기를 설정해주세요', () { });
                              return;
                            } else if(form.cycle == '') {
                              alert.onWarning(context, '알림 주기를 설정해주세요', () { });
                              return;
                            }
                            int seq = _vocaList.indexOf(_vocaList.where((e) => e.title == form.noteKey).elementAt(0));

                            await setAlert(seq, form.title, form.noteKey, form.time, form.cycle, form.repeat)
                                .then((value) {
                                  alert.onSuccess2(context, "알림이 등록되었습니다.", '/settings');
                                  this._typeAheadController.text = '';
                                  initializeForm(context);
                                }).then((value) {

                            });
                          },
                        ),
                      ),
                      ButtonTheme(
                          child: DialogButton(
                            height: 38.0.sp,
                            width: MediaQuery.of(context).size.width * 0.28,
                            color: Colors.lightBlue,
                            child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              this._typeAheadController.text = '';
                              initializeForm(context);
                            },
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8.0.sp,),
              ],
            );
          }
      );
    });
  }
}

Alert notif = new Alert();

class NotifCard extends StatefulWidget {
  final int seq;
  final String notifInfo;
  final bool active;
  NotifCard({Key? key, required this.seq, required this.notifInfo, required this.active});

  @override
  _NotifCardState createState() => _NotifCardState();
}

class _NotifCardState extends State<NotifCard> {
  var isOn;
  @override
  void initState() {
    super.initState();
    setState(() {
      isOn = widget.active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.alarm, color: isOn ? Colors.lightBlue : Colors.grey,size: 32.sp,),
        title: Text(widget.notifInfo.split('#')[0]),
        subtitle: Text(widget.notifInfo.split('#')[2]),
        trailing: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: FlutterSwitch(
            activeColor: Colors.lightBlueAccent,
            inactiveColor: Colors.grey,
            value: isOn,
            onToggle: (value) {
              setState(() {
                isOn = value;
              });
              checkList[widget.seq] = value;
            },
          ),
        ),
      ),
    );
  }
}
