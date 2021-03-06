import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dto/voca.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:noonsaegim/database/dto/voca.dart';

Future<void> addVoca(String title, List<Map<String, String>> wordList) async {
  var box = await Hive.openBox<Voca>('voca');
  box.add(Voca(title: title, date: DateTime.now(), wordList: wordList));
}

Future<List<Voca>> fetchVocaList() async {
  final box = await Hive.openBox<Voca>('voca');
  return box.values.toList();
}

void deleteVoca(BuildContext context, int position) {
  final box = Hive.box<Voca>('voca');
  box.deleteAt(position).then((value){
    Fluttertoast.showToast(msg: "Data Deleted");
  }).then((value) => Navigator.pushNamed(context, '/mynote'));
}

initHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(VocabularyAdapter());
}
