import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/page4/single_image_process.dart';
import 'package:noonsaegim/page9/wav/audio_player.dart';
import 'package:noonsaegim/setting/alert_setting.dart';
import 'package:noonsaegim/setting/cache.dart';
import 'package:noonsaegim/setting/notif_on_off.dart';
import 'package:provider/provider.dart';
import 'page5/image_picker.dart';
import 'page8/recently_searched_list.dart';
import 'page10/settings.dart';
import 'page9/mynote.dart';
import 'page7/multi_images_process.dart';
import 'page1/home.dart';
import 'package:sizer/sizer.dart';
import 'package:audio_service/audio_service.dart';
import 'database/hive_module.dart';

void main() async {

  /// hive database setting
  await initHive();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => new AlertSetting()),
        ],
      child: FirstRoute(),
    )
  );

  CacheablePeriod();
  SwitchAlert();
}


class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              initialRoute: '/pick',
              routes: {
                '/main': (context) => Home(),
                '/pick': (context) => Gallery(),
                '/mynote': (context) => AudioServiceWidget(child: MyNote()),
                '/recently': (context) => Recently(),
                '/settings': (context) => Settings(),
                '/multi' : (context) => AudioServiceWidget(child: MultiImagesProcess()),
                '/single': (context) => AudioServiceWidget(child: SingleImageProcess()),
                '/playlist': (context) => AudioPlayer(),
              },
            );
          }
      );
  }
}