import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../setting/text_list.dart';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

void onSaveButtonPressed(BuildContext context) {
  String _title = '';

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
                        Provider.of<WordList>(context, listen: false).setTitle(_title);
                        //여기는...uid 생성해서 db 에 insert.. 이후 알림 띄우고 단어장으로 이동?
                        Navigator.pushNamed(context, '/mynote');
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

