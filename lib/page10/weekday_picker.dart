import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../setting/alert_setting.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WeekDayPicker extends StatefulWidget {
  const WeekDayPicker({Key? key}) : super(key: key);

  @override
  _WeekDayPickerState createState() => _WeekDayPickerState();
}

class _WeekDayPickerState extends State<WeekDayPicker> {
  var _selectedDays = [];
  bool _repeat = false;
  final _week = ['일', '월', '화', '수', '목', '금', '토', ];
  final values = <bool?>[false, false, false, false, false, false, false];

  printIntAsDay(int day) {
    print('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  void setCycle(List<bool?> values){
    List<int> indexs = values.asMap().entries.where((element) => element.value == true).map((e) => e.key).toList();
    _selectedDays = indexs.map((e) => _week[e]).toList();
    _selectedDays = _selectedDays.toSet().toList();

    String _cycle= '';
    if(_week.every((e) => _selectedDays.contains(e))) {
      _cycle = '매일';
    } else if (['토', '일'].every((e) => _selectedDays.contains(e))) {
      _cycle = '주말';
    } else if (_week.sublist(1, 6).every((e) => _selectedDays.contains(e))) {
      _cycle = '평일';
    } else {
      _cycle = '${_selectedDays.map((e) => e).join(', ')}';
    }
    print('selectedDays: $_selectedDays');
    Provider.of<AlertSetting>(context, listen: false).setCycle(_cycle);
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.sp, 25.sp, 15.sp, 5.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WeekdaySelector(
            onChanged: (idx) => {
              print('index is ${idx}!'),
              setState(() {
                values[idx % 7] = !values[idx % 7]!;
              }),
              setCycle(values),
            },
            values: values,
            selectedElevation: 15,
            elevation: 5,
            disabledElevation: 0,
            selectedFillColor: HexColor('#FFB3B3'),
            selectedColor: Colors.white,
            selectedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white24.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('반복', style: TextStyle(color: Colors.black54, fontSize: 12.0.sp, fontWeight: FontWeight.w500),),
                SizedBox(width: 4.0.sp,),
                FlutterSwitch(
                  showOnOff: true,
                  activeColor: Colors.lightGreenAccent,
                  inactiveColor: Colors.grey,
                  value: _repeat,
                  onToggle: (value) {
                    setState(() => _repeat = value);
                    Provider.of<AlertSetting>(context, listen: false).setRepeat(_repeat);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

