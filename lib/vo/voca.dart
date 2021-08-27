import 'word.dart';

class Voca {
  Voca({
    required this.uid,
    required this.title,
    required this.date,
    required this.wordList,
  });

  String uid;
  String title;
  DateTime date;
  List<Word> wordList;
}