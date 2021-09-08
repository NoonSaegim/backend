import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/popup.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

Future<void> requestPermission(BuildContext context) async {
  if(io.Platform.isAndroid) {
    if (await Permission.contacts.request().isGranted) {
    }
    if(await Permission.storage.request().isGranted) {

      await SharedPreferences.getInstance()
          .then((SharedPreferences preferences)
      => preferences.setBool('permissionToStorage', true))
          .then((value) => print('--------get storage permission-------'));
    } else if(await Permission.storage.request().isPermanentlyDenied) {

      alert.onWarning(context, '앱 이용시 권한이 필요합니다.', () => openAppSettings);
    } else if(await Permission.storage.request().isDenied) {

      alert.onWarning(context, '앱 이용시 권한이 필요합니다.', (){});
      await SharedPreferences.getInstance()
          .then((SharedPreferences preferences)
      => preferences.setBool('permissionToStorage', false));
    }
  }
}

