import 'dart:isolate';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:noonsaegim/common/popup.dart';
import 'package:noonsaegim/page4/single_image_process.dart';
import 'package:noonsaegim/page7/multi_images_process.dart';
import 'package:noonsaegim/setting/word_list_argument.dart';
import 'package:noonsaegim/vo/word.dart';
import 'api_info.dart';
import 'package:sizer/sizer.dart';

class AsyncService {

  late CustomProgressDialog _progressDialog;
  late ReceivePort _receivePort;
  late Isolate? _isolate;
  List<Word> _dataList = [];

  void callApiProcess(BuildContext context, List<Uint8List> params, List<String> types) async {
    print('1) callApiProcess start');
    Fluttertoast.showToast(msg: '데이터 처리 중입니다. 잠시만 기다려주세요..');
    _progressDialog = CustomProgressDialog(
      context,
      blur: 10,
      dialogTransitionType: DialogTransitionType.Bubble,
      loadingWidget: Center(
        child: Container(
          height: 60.sp,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
      onDismiss: () {
        print('1) callApiProcess end');
      },
    );

    _progressDialog.show();
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_loadData, [_receivePort.sendPort, params, types]);

    _receivePort.listen((response) {
      try {
        List<Word> dataList = response as List<Word>;
        if(dataList.isNotEmpty) {
          _dataList = dataList;
        }
        print('[callApiProcess] dataList: $dataList}'); //결과 출력
      } catch(e) {
        throw e;
      } finally {
        _receivePort.close(); /// port 닫기
        _isolate?.kill(priority: Isolate.immediate); /// process kill
        _isolate = null; ///초기화
      }
    }).onDone(() {
      if(params.length == 1 && _dataList.isNotEmpty) {
        _progressDialog.dismiss();
        Navigator.push(
            context,
            new MaterialPageRoute(
              settings: RouteSettings(
                arguments: WordList(imageList: params, dataList: _dataList),
              ),
              builder: (context) => AudioServiceWidget(child: SingleImageProcess()),
            )
        ).then((value){
          print('page route[4]: SingleImageProcess');
          _dataList = []; ///데이터 초기화
        });

      } else if(params.length >= 2 && _dataList.isNotEmpty){
        _progressDialog.dismiss();

        Navigator.push(
            context,
            new MaterialPageRoute(
              settings: RouteSettings(
                arguments: WordList(imageList: params, dataList: _dataList),
              ),
              builder: (context) => AudioServiceWidget(child: MultiImagesProcess()),
            )
        ).then((value) {
          print('page route[7]: MultiImagesProcess');
          _dataList = []; ///데이터 초기화
        });
      } else { ///데이터가 없거나 오류가 발생한 경우
        if(_dataList.isEmpty) {
          alert.onWarning(context, '조회된 데이터가 없습니다!', () => Navigator.pushNamed(context, '/main'));
        } else {
          alert.onError(context, '오류가 발생해 데이터를 수신하지 못했습니다');
          Navigator.pushNamed(context, '/main');
        }
      }
    });
  }


  static _loadData (List<Object> args) async {
    SendPort sendPort = args[0]! as SendPort;
    List<Uint8List> params = args[1]! as List<Uint8List>;
    List<String> types = args[2]! as List<String>;

    List<Word> wordList = await getWordListFromImages(params, types).then((List<Word> wordList) => wordList.toSet().toList());
    List<Word> dataList = List.generate(wordList.length, (index) {
      return Word(seq: index, word: wordList[index].word, meaning: wordList[index].meaning, isSelected: false);
    });
    print('2) getWordListFromImages end');

    sendPort.send(dataList);
  }


  static Future<List<Word>> getWordListFromImages(List<Uint8List> params, List<String> types) async {
    print('2) getWordListFromImages start');
    List<Word> wordList = [];
    if(params.length == types.length) {
      for(int i=0; i < params.length; i++) {
        var data = params[i];
        var type = types[i];
        List<Word> words = await getApiReponseAsWord(data, type).then((List<Word> words) => words.toSet().toList());
        print('3) getApiReponseAsWord end');
        wordList.addAll(words);
      }
    } else {
      print('params: $params');
      print('types: $types');
    }
    return wordList;
  }

  static Future<List<Word>> getApiReponseAsWord(Uint8List data, String type) async {
    List<String> detectedWords = await getDetectedWords(data, type);
    if(detectedWords.isNotEmpty) {
      print('${detectedWords.length}개의 단어가 검출되었음!');

      List<String?> wordsTranslated = await callTranslateApi(detectedWords);
      print(wordsTranslated);

      if(wordsTranslated.length == detectedWords.length) {
        return List.generate(detectedWords.length, (index) {
          String translated = wordsTranslated[index]!.replaceAll('.', '').replaceAll('를', '').replaceAll('을', '');
          return Word(seq: null, word: detectedWords[index], meaning: translated, isSelected: null);
        });
      } else {
        throw Exception('검출된 단어와 번역된 단어의 개수가 다릅니다.');
      }
    } else {
      print('검출된 단어가 없습니다.');
      return [];
    }
  }

  static Future<List<String?>> callTranslateApi(List<String> words) async {
    List<String?> wordsTranslated = [];
    for(var i in words) {
      wordsTranslated.add(await translateWord(i));
    }
    return wordsTranslated;
  }

  static Future<String?> translateWord(String word) async {
    var dio = new Dio();
    dio.options.headers['X-Naver-Client-Id'] = '$TRANSLATE_API_KEY';
    dio.options.headers['X-Naver-Client-Secret'] = '$TRANSLATE_API_SECRET';
    try {
      final response = await dio.post('$TRANSLATE_API_PREFIX',
          data: {
            'text' : word,
            'source': 'en',
            'target': 'ko',
          });

      if(response.statusCode == 200) {
        if(response.data != null) {
          final responseMap = new Map<String, dynamic>.from(response.data['message']);
          print(responseMap);
          final resultMap = new Map<String, dynamic>.from(responseMap['result']);
          print(resultMap);
          print(resultMap['translatedText'].toString());
          return resultMap['translatedText'].toString();
        }
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      print(e);
      dio.close();
    }
  }

  static Future<List<String>> getDetectedWords(Uint8List data, String type) async {
    List<String> detectedWords = [];

    print('4) getDetectedWords start');
    var encodedData = base64.encode(data);
    Map<String, dynamic> requestJson = {
      'request_id': 'reserved field',
      'access_key': '$PICTURE_API_KEY',
      'argument': {
        'type': type,
        'file': encodedData
      }
    };

    try {
      final response = await Dio().post('$PICTURE_API_PREFIX', data: requestJson);

      if(response.statusCode == 200) {
        if(response.data != null && response.data['return_object'] != null) {
          final data = new Map<String, dynamic>.from(response.data['return_object']);
          final result = new List<Map<String,dynamic>>.from(data['data']);
          detectedWords =  result.map((e) => e['class'].toString()).toSet().toList().cast<String>();
          print(detectedWords);
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
    return detectedWords;
  }

}

var service = AsyncService();