import 'dart:async';
import 'dart:io';
import '../../common/popup.dart';
import 'package:flutter/material.dart';
import 'audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database/dto/voca.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'converter_ui.dart';

class Converter extends StatefulWidget {
  final Function save;
  final Voca voca;
  const Converter({Key? key, required this.save, required this.voca}) : super(key: key);

  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  double _percent = 0.0;

  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording? _current;
  late FlutterAudioRecorder? audioRecorder;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void > _checkPermission() async {
    if (await Permission.contacts.request().isGranted) {
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    if(statuses[Permission.storage] == PermissionStatus.granted
        && statuses[Permission.manageExternalStorage] == PermissionStatus.granted) {
      _currentStatus = RecordingStatus.Initialized;
    } else {
      alert.onWarning(context, '권한 동의가 필요한 기능입니다.', () => Navigator.of(context).pushNamed('/mynote'));
    }
  }

  Future<void> _onStartPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:_record();
      break;
      case RecordingStatus.Recording:print('------------recording-------------');
      break;
      case RecordingStatus.Stopped:print('------------stopped-------------');
      break;
      default:
        break;
    }
  }

  Future<void> _record() async {
    await _initial();
    await _start();
    Fluttertoast.showToast(msg: "Start Recording");
    setState(() {
      _currentStatus = RecordingStatus.Recording;
      stop = true;
    });
  }

  _stop() async {
    var result = await audioRecorder!.stop();
    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    widget.save();
    setState(() {
      _current = result!;
      _currentStatus = _current!.status!;
      _current!.duration = null;
      stop = false;
    });
  }

  _initial() async {
    Directory? appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String date = "${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
    Directory appDirec =
    Directory("${appDir!.path}/$jrecord/");
    if (await appDirec.exists()) {
      String path = "${appDirec.path}$date";
      print("path for file11 $path");
      audioRecorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV);
      await audioRecorder!.initialized;
    } else {
      appDirec.create(recursive: true);
      Fluttertoast.showToast(msg: "Start Recording , Press Start");
      String path = "${appDirec.path}$date";
      print("path for file22 $path");
      audioRecorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV);
      await audioRecorder!.initialized;
    }
  }


  _start() async {
    await audioRecorder!.start();
    var recording = await audioRecorder!.current(channel: 0);
    setState(() {
      _current = recording!;
    });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        t.cancel();
      }

      var current = await audioRecorder!.current(channel: 0);
      print(current!.status);
      setState(() {
        _current = current;
        _currentStatus = _current!.status!;
      });
    });
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(child: SaveAsWav());
  }
}
