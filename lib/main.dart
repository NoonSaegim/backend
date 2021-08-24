import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'page5/image_picker.dart';
import 'page8/recently_searched_list.dart';
import 'page10/settings.dart';
import 'page9/mynote.dart';
import 'page7/multi_images_process.dart';
import 'page1/home.dart';
import 'package:sizer/sizer.dart';
import 'page2/open_camera.dart';

void main() {
  runApp(MaterialApp(
    title: "Navigation Basics",
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            initialRoute: '/main',
            routes: {
              '/main': (context) => Home(),
              '/pick': (context) => Gallery(),
              '/mynote': (context) => MyNote(),
              '/recently': (context) => Recently(),
              '/settings': (context) => Settings(),
              '/multi' : (context) => MultiImagesProcess(),
            },
          );
        }
    );
  }
}