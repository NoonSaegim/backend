import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'record_and_save.dart';
import '../../database/dto/voca.dart';
import 'package:audio_service/audio_service.dart';

late Directory appDir;
late List<String> records;

Future<void> onInitRecords() async {
  records = [];
  await getExternalStorageDirectory().then((value) {
    appDir = value!;
    Directory? appDirec = Directory("${appDir.path}/my_vocabulary/");
    appDir = appDirec;
    appDir.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records = records.reversed.toList();
    });
  });
}

onFinish() {
  records.clear();
  print(records.length.toString());
  appDir.list().listen((onData) {
    records.add(onData.path);
  }).onDone(() {
    records.sort();
    records = records.reversed.toList();
  });
}

showRecorder(BuildContext context, Voca voca) {
  showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top) * 0.28,
          color: Colors.white70,
          child: AudioServiceWidget(child: Converter(save: onFinish, voca: voca)),
        );
      }
  );
}
