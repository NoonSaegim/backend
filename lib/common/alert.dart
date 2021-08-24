import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Popup {

  onSuccess(BuildContext context, String title) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      buttons: [
        DialogButton(
          color: Colors.cyan,
          child: Text(
            "확인",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          width: MediaQuery.of(context).size.width * 0.3,
          height: 35.0.sp,
        )
      ],
    ).show();
  }

  onError(BuildContext context, String title) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "확인",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          width: MediaQuery.of(context).size.width * 0.3,
          height: 35.0.sp,
        )
      ],
    ).show();
  }

  onWarning(BuildContext context, String title, VoidCallback callback) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      buttons: [
        DialogButton(
          color: Colors.deepOrangeAccent,
          child: Text(
            "확인",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
          onPressed: () => {
            callback(),
            //Navigator.of(context, rootNavigator: true).pop()
          },
          width: MediaQuery.of(context).size.width * 0.3,
          height: 35.0.sp,
        )
      ],
    ).show();
  }

  onInform(BuildContext context, String title, VoidCallback callback) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width * 0.3,
          height: 35.0.sp,
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
            ),
          ),
          onPressed: () => callback(),
          color: Colors.cyan,
        ),
        DialogButton(
          width: MediaQuery.of(context).size.width * 0.3,
          height: 35.0.sp,
          child: Text(
            "CANCEL",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
            ),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ]),
        )
      ],
    ).show();
  }
}

Popup alert = new Popup();
