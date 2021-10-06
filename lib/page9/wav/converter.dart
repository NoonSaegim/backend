import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database/dto/voca.dart';
import '../../tts/text_player.dart';
import '../../setting/file_list_argument.dart';
import '../../common/popup.dart';

Future<void> saveTtsAsWav(BuildContext context,Voca voca, VoidCallback save, Future<List<String>> init) async {

  if(await Permission.storage.request().isGranted) {
    String text = _getWordList([...voca.wordList]);
    print('text to save: [$text]');
    //String path = await _setFilePath(voca);
    String path = "${voca.title}@${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
    Tts().save(text, path)
        .then((value) => save)
        .then((value) => Fluttertoast.showToast(msg: "File Saved"))
        .then((value) => Navigator.pushNamed(context, '/playlist', arguments: WavList(onInit: init)));
  } else {
    alert.onError(context, '앱 저장소에 대한 권한이 없습니다!');
    return;
  }
}

String _getWordList(List<Map<String, String>> wordList) {
  return wordList.map((e) => e['word'].toString()).join(', ');
}

// Future<String> _setFilePath(Voca voca) async {
//   Directory? appDir = await getExternalStorageDirectory();
//   String title = "${voca.title}@${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
//   Directory appDirec = Directory("${appDir!.path}/Vocabulary/");
//
//   if(await appDirec.exists()) {
//     appDirec.create(recursive: true);
//     String path = "${appDirec.path}$title";
//     print("path for file: $path");
//     return path;
//   } else {
//     String path = "${appDirec.path}$title";
//     print("path for file: $path");
//     return path;
//   }
// }
