import 'package:noonsaegim/page9/wav/audio_recorder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/popup.dart';
import 'package:flutter/material.dart';
import '../page9/wav/stream/recording_status.dart';

Future<void> requestPermission(BuildContext context) async {
  if (await Permission.contacts.request().isGranted) {
  }
  if(await Permission.storage.request().isGranted) {

    await SharedPreferences.getInstance()
        .then((SharedPreferences preferences)
    => preferences.setBool('permissionToStorage', true))
        .then((value) => print('--------get storage permission-------'));
   }
  if(await Permission.manageExternalStorage.request().isGranted) {

    await SharedPreferences.getInstance()
        .then((SharedPreferences preferences)
    => preferences.setBool('permissionToExternalStorage', true))
        .then((value) => print('--------get external storage permission-------'));
  } else if(await Permission.storage.request().isPermanentlyDenied || await Permission.manageExternalStorage.request().isPermanentlyDenied) {
    alert.onWarning(context, '앱 이용시 권한이 필요합니다.', () => openAppSettings);

  } else if(await Permission.storage.request().isDenied) {
    alert.onWarning(context, '앱 이용시 권한이 필요합니다.', (){});
    await SharedPreferences.getInstance()
        .then((SharedPreferences preferences)
    => preferences.setBool('permissionToStorage', false));
   }
  final pref = await SharedPreferences.getInstance();
  if(pref.getBool('permissionToStorage') as bool && pref.getBool('permissionToExternalStorage') as bool) {
    currentStatus.setCurrentStatus(RecordingStatus.Initialized);
    print('------record status initialized-------');
  }
}