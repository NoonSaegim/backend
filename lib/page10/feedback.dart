import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../common/alert.dart';

class FeedBack {

  showFeedBackDiaglog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('피드백 보내기', textAlign: TextAlign.center,),
            titlePadding: EdgeInsets.only(top: 25.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines:5,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.message_outlined, color: Colors.lightBlue),
                    labelText: '메세지',
                    hintText: '여러분의 소중한 의견 및 건의사항을 알려주세요.',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.lightBlue),
                      labelText: '이메일',
                      hintText: '연락처(E-Mail)'
                  ),
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
                      height: 25.0,
                      child: DialogButton(
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.lightBlue,
                        child: Text('SEND', style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () => alert.onSuccess(context, "성공적으로 전송되었습니다!"),
                      ),
                    ),
                    ButtonTheme(
                        height: 25.0,
                        child: DialogButton(
                          width: MediaQuery.of(context).size.width * 0.25,
                          color: Colors.lightBlue,
                          child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 16)),
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
}

FeedBack feedback = new FeedBack();