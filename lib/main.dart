import 'package:flutter/material.dart';
import 'package:noonsaegim/setting/alert_setting.dart';
import 'package:noonsaegim/setting/alert_list.dart';
import 'setting/alert_list.dart';
import 'package:provider/provider.dart';
import 'page5/image_picker.dart';
import 'page8/recently_searched_list.dart';
import 'page10/settings.dart';
import 'page9/mynote.dart';
import 'page7/multi_images_process.dart';
import 'page1/home.dart';
import 'package:sizer/sizer.dart';
import 'page4/single_image_process.dart';
import 'package:audio_service/audio_service.dart';
import 'setting/cache.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => new CacheablePeriod()),
          ChangeNotifierProvider(create: (_) =>  new AlarmList()),
          ChangeNotifierProvider(create: (_) => new AlarmSetting()),
        ],
      child: FirstRoute(),
    )
  );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              initialRoute: '/single',
              routes: {
                '/main': (context) => Home(),
                '/pick': (context) => Gallery(),
                '/mynote': (context) => MyNote(),
                '/recently': (context) => Recently(),
                '/settings': (context) => Settings(),
                '/multi' : (context) => MultiImagesProcess(),
                '/single': (context) => AudioServiceWidget(child: SingleImageProcess()),
              },
            );
          }
      );
  }
}