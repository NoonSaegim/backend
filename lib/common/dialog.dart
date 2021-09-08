import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import '../vo/word.dart';
import '../database/hive_module.dart';
import 'popup.dart';

void onSaveButtonPressed(BuildContext context, List<Word> dataList) {
  String _title = '';

  void _onSave() async {
    if(_title == '') {
      alert.onWarning(context, '단어장 제목을 작성해주세요!', (){});
      return;
    }
    List<Word> selectedList = dataList.where((e) => e.isSelected!).toList();
    selectedList.sort((x,y) => x.seq!.compareTo(y.seq!));
    List<Map<String,String>> dataToInsert = selectedList.map((e) => e.toSimpleJson()).toList();
    await addVoca(_title, dataToInsert)
        .then((value) => {
          print('insert success'),
          Navigator.pushNamed(context, '/mynote')
        });
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('나의 단어장에 저장', textAlign: TextAlign.center,),
          titlePadding: EdgeInsets.only(top: 25.0.sp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => {
                  _title = value,
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title_rounded, color: Colors.lightBlue),
                  labelText: '제목',
                  hintText: '단어장 제목을 작성하세요',
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    DialogButton(
                      height: 35.0.sp,
                      width: MediaQuery.of(context).size.width * 0.25,
                      color: Colors.lightBlue,
                      child: Text('OK', style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        _onSave();
                      },
                    ),
                    DialogButton(
                      height: 35.0.sp,
                      width: MediaQuery.of(context).size.width * 0.25,
                      color: Colors.lightBlue,
                      child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () => {
                        Navigator.of(context, rootNavigator: true).pop(),
                        //form 초기화
                      },
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

