import 'dart:typed_data';
import 'package:noonsaegim/vo/word.dart';

class WordList {
  final List<Word> dataList;
  final List<Uint8List> imageList;

  WordList({required this.dataList, required this.imageList});
}