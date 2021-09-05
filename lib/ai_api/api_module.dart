import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/page4/single_image_process.dart';
import 'package:noonsaegim/setting/word_list_argument.dart';
import 'package:noonsaegim/vo/word.dart';
import 'api_info.dart';

Future<dynamic> callApiProcess(BuildContext context, List<Uint8List> params, List<String> types) async {
  print('1) callApiProcess start');
  await getWordListFromImages(params, types)
      .then((List<Word> wordList) {
        wordList = wordList.toSet().toList();
        List<Word> dataList = List.generate(wordList.length, (index) {
          return Word(seq: index, word: wordList[index].word, meaning: wordList[index].meaning, isSelected: false);
        });
        print('2) getWordListFromImages end');

        print('dataList: $dataList');
        Navigator.push(context, MaterialPageRoute(
          settings: RouteSettings(
            arguments: WordList(dataList: dataList, imageList: params),
          ),
          builder: (context) {
            return AudioServiceWidget(child: SingleImageProcess());
          }
        ));
      }).then((value) => print('1) callApiProcess end'));
}

Future<List<Word>> getWordListFromImages(List<Uint8List> params, List<String> types) async {
  print('2) getWordListFromImages start');
  List<Word> wordList = [];
  if(params.length == types.length) {
    for(int i=0; i < params.length; i++) {
      var data = params[i];
      var type = types[i];
      await getApiReponseAsWord(data, type)
          .then((List<Word> words) {
          print('3) getApiReponseAsWord end');
          wordList.addAll(words);
      });
    }
  } else {
    print('params: $params');
    print('types: $types');
  }
  return wordList;
}

Future<List<Word>> getApiReponseAsWord(Uint8List data, String type) async {
  List<String> detectedWords = await getDetectedWords(data, type);
  if(detectedWords.isNotEmpty) {
    print('${detectedWords.length}개의 단어가 검출되었음!');

    List<String?> wordsTranslated = await callTranslateApi(detectedWords);
    print(wordsTranslated);

    if(wordsTranslated.length == detectedWords.length) {
      return List.generate(detectedWords.length, (index) {
        return Word(seq: null, word: detectedWords[index], meaning: wordsTranslated[index]! as String, isSelected: null);
      });
    } else {
      throw Exception('검출된 단어와 번역된 단어의 개수가 다릅니다.');
    }
  } else {
    print('검출된 단어가 없습니다.');
    return [];
  }
}

Future<List<String?>> callTranslateApi(List<String> words) async {
  List<String?> wordsTranslated = [];
  for(var i in words) {
    await translateWord(i)
        .then((String? value) => wordsTranslated.add(value));
  }
  return wordsTranslated;
}

Future<String?> translateWord(String word) async {
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
    } else print(response.statusCode);
  } catch (e) {
    print(e);
    dio.close();
  }
}

Future<List<String>> getDetectedWords(Uint8List data, String type) async {
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
