import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/dto/voca.dart';
import '../../tts/text_player.dart';
import '../../setting/file_list_argument.dart';
import '../../common/popup.dart';

Future<void> saveTtsAsWav(BuildContext context,Voca voca, Function save, Future<List<String>> init) async {
  final pref = await SharedPreferences.getInstance();
  if(pref.getBool('permissionToStorage') as bool) {
    String text = _getWordList([...voca.wordList]);
    print('text to save: [$text]');
    await _setFilePath(voca).then((String path){
      Tts().save(text, path)
          .then((value) => save)
          .then((value) => Fluttertoast.showToast(msg: "File Saved"))
          .then((value) => Navigator.pushNamed(context, '/playlist', arguments: WavList(onInit: init)));
    });
  } else {
    alert.onError(context, '앱 저장소에 대한 권한이 없습니다!');
    return;
  }
}

String _getWordList(List<Map<String, String>> wordList) {
  return wordList.map((e) => e['word'].toString()).join(', ');
}

Future<String> _setFilePath(Voca voca) async {
  Directory? appDir = await provider.getExternalStorageDirectory();
  String title = "${voca.title}@${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
  Directory appDirec = Directory("${appDir!.path}/Vocabulary/");

  if(await appDirec.exists()) {
    appDirec.create(recursive: true);
    String path = "${appDirec.path}$title";
    print("path for file: $path");
    return path;
  } else {
    String path = "${appDirec.path}$title";
    print("path for file: $path");
    return path;
  }
}