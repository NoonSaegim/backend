import 'package:flutter/material.dart';

class Resize with ChangeNotifier {
  bool _mini = false;

  get minimize => _mini;

  void setMini(bool isMini) {
    _mini = isMini;
    notifyListeners();
  }
}