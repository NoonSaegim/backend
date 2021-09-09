import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../common/popup.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedBack {

  showFeedBackDiaglog(BuildContext context) {

    String _body = '';
    String _from = '';

    Future<void> _sendEmail() async {
      final Email email = Email(
          body: _body,
          subject: 'Feedback from user $_from',
          recipients: ['a75101912@gmail.com'],
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';

      } catch (error) {
        platformResponse = error.toString();
      }

      if (platformResponse == 'success') {
        alert.onSuccess2(context, '소중한 의견 감사합니다!', '/settings');
      } else {
        alert.onError(context, platformResponse);
      }
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            scrollable: true,
            title: Text('피드백 보내기', textAlign: TextAlign.center,),
            titlePadding: EdgeInsets.only(top: 22.5.sp),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  //controller: _bodyController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => _body = value,
                  maxLines: 3,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.message_outlined, color: Colors.lightBlue),
                    labelText: '메세지',
                    hintText: '여러분의 소중한 의견 및 건의사항을 알려주세요.',
                  ),
                ),
                TextField(
                  //controller: _contactController,
                  onChanged: (value) => _from = value,
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
                      child: DialogButton(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 35.0.sp,
                        color: Colors.lightBlue,
                        child: Text('SEND', style: TextStyle(color: Colors.white, fontSize: 12.5.sp)),
                        onPressed: () => _sendEmail(),
                      ),
                    ),
                    ButtonTheme(
                        child: DialogButton(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 35.0.sp,
                          color: Colors.lightBlue,
                          child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 12.5.sp)),
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 3.0.sp,),
            ],
          );
        }
    );
  }
}

FeedBack feedback = new FeedBack();

