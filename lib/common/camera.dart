import 'package:flutter/material.dart';
import '../page2/open_camera.dart';
import 'package:camera/camera.dart';

Future<void> openCamera(BuildContext context) async {

  WidgetsFlutterBinding.ensureInitialized();

  // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
  final cameras = await availableCameras();
  // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
  final firstCamera = cameras.first;

  Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
}