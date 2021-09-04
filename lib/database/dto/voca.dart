import 'package:hive/hive.dart';
import 'dart:convert';
part 'voca.g.dart';

@HiveType(typeId: 0, adapterName: 'VocabularyAdapter')
class Voca {
  Voca({
    required this.title,
    required this.date,
    required this.wordList,
  });
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  List<Map<String, String>> wordList;

  @override
  String toString() => '$title : $date : ${jsonEncode(wordList)}';
}