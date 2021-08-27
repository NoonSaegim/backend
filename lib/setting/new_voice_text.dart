import 'package:flutter/material.dart';

class VoiceText with ChangeNotifier {
  String _newVoiceText = '';

  String get voiceText => _newVoiceText;

  set newVoiceText(String text) {
    _newVoiceText = text;
    notifyListeners();
  }
}