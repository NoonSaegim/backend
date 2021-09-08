import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database/dto/voca.dart';
import '../../tts/text_player.dart';
import '../../setting/file_list_argument.dart';
import '../../common/popup.dart';

Future<void> saveTtsAsWav(BuildContext context,Voca voca, VoidCallback save, Future<List<String>> init) async {

  if(await Permission.manageExternalStorage.request().isGranted) {
    String text = _getWordList([...voca.wordList]);
    print('text to save: [$text]');
    String path = _setFilePath(voca);
    Tts().save(text, path)
        .then((value) => save) //TODO --Android11 부터 media 파일을 외부 저장소에 생성할수 없음...다른방법 찾아야 함!
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

String _setFilePath(Voca voca) {
  return "${voca.title}@${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
}