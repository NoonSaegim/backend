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
    Directory? appDirec = Directory("${appDir.path}/Audiorecords/");
    appDir = appDirec;
    appDir.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records = records.reversed.toList();
    });
  });
}

_onFinish() {
  records.clear();
  print(records.length);
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
            MediaQuery.of(context).padding.top) * 0.24,
          color: Colors.white70,
          child: AudioServiceWidget(
            child: Recorder(voca: voca, save: _onFinish),
            //child: TestRecorder(voca: voca, save: _onFinish),
          ),
        );
      }
  );
}
