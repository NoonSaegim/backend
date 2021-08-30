import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void _showFilesInDir({required Directory dir}) {
  dir.list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) => print(entity.path));
}

Future<void> requestWritePermission() async {
  if (await Permission.contacts.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }
  Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
  print(statuses[Permission.location]);
}

Future<void> requestPermission() async {
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
  }

  /*else if(await Permission.storage.request().isPermanentlyDenied || await Permission.manageExternalStorage.request().isPermanentlyDenied) {
  //   await openAppSettings();
  // } else if(await Permission.storage.request().isDenied) {
  //   await SharedPreferences.getInstance()
  //       .then((SharedPreferences preferences)
  //   => preferences.setBool('permissionToStorage', false));
   }*/
}