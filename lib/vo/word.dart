import 'dart:convert';
import 'package:intl/intl.dart';

class Word {
  Word({
    required this.seq,
    required this.word,
    required this.meaning,
    required this.isSelected,
  });

  int? seq;
  String word;
  String meaning;
  bool? isSelected;

  Map<String, String> toSimpleJson() =>
  {
    'word': word,
    'meaning': meaning,
  };

  Map<String,String> toMap() => {
    '$seq': word,
  };

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(seq: null, word: json['word'], meaning: json['meaning'], isSelected: null);
  }
}