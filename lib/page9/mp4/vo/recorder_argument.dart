import '../audio_recorder.dart';
import 'package:flutter/material.dart';

class RecorderArgument {
  final List<Map<String,String>> params;
  final Recording? current;
  final RecordingStatus currentStatus;
  final bool stop;
  final Function onStart;
  final Function onStop;

  RecorderArgument({
    required this.params,
    required this.current,
    required this.currentStatus,
    required this.stop,
    required this.onStart,
    required this.onStop
  });
}