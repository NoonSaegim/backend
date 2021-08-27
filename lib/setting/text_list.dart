import '../vo/word.dart';
import 'package:flutter/material.dart';

class WordList with ChangeNotifier{
  String _uid = '';
  String _title = '';
  DateTime _date = DateTime.now();
  List<Word> _wordList = [];

  String get key => _uid;
  String get title => _title;
  DateTime get date => _date;
  List<Word> get wordList => _wordList;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  Word getWord(int index) {
    if(_wordList.isNotEmpty && _wordList.length > index) {
      return _wordList[index];
    } else throw Exception('단어가 없거나 개수가 ${index+1} 개보다 적습니다.');
  }

  void addAlarm(Word word) {
    _wordList.add(word);
    notifyListeners();
  }

  void updateAlarm(int index, Word word) {
    _wordList[index] = word;
    notifyListeners();
  }
}