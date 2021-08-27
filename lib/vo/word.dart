import 'dart:convert';
import 'package:intl/intl.dart';

class Word {
  Word({
    required this.seq,
    required this.word,
    required this.meaning,
    required this.isSelected,
  });

  int seq;
  String word;
  String meaning;
  bool isSelected;

  Map<String,String> toMap() => {
    '$seq': word,
  };
}