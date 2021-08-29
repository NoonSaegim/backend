import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/database/dto/voca.dart';
import 'package:noonsaegim/setting/alert_list.dart';
import 'package:noonsaegim/setting/alert_setting.dart';
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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'dart:io';
import 'database/dto/voca.dart';
import 'setting/bool_resize_speaker.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void main() async{

  //hive database setting
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(VocabularyAdapter());

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) =>  new AlarmList()),
          ChangeNotifierProvider(create: (_) => new AlarmSetting()),
          ChangeNotifierProvider(create: (_) => new Resize()),
        ],
      child: FirstRoute(),
    )
  );

  //반응형 pref 설정
  final pref = await StreamingSharedPreferences.instance;
  pref.setStringList('cacheKeys', []);  //캐시 키 리스트 default
  pref.setInt('cacheableDays', 1);  //캐시 저장 기간 default
  pref.setInt('cacheCount', 0); //캐시 개수 default
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              initialRoute: '/mynote',
              routes: {
                '/main': (context) => Home(),
                '/pick': (context) => Gallery(),
                '/mynote': (context) {
                  Provider.of<Resize>(context, listen: false).setMini(true);
                  return AudioServiceWidget(child: MyNote());
                },
                '/recently': (context) => Recently(),
                '/settings': (context) => Settings(),
                '/multi' : (context) => AudioServiceWidget(child: MultiImagesProcess()),
                '/single': (context) => AudioServiceWidget(child: SingleImageProcess()),
              },
            );
          }
      );
  }
}