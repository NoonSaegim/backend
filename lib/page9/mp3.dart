import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

typedef _Fn = void Function();

Future<String> _getExternalDir(String path) async {
  final extDir = await getExternalStorageDirectory();
  return '${extDir!.path}/$path';
}

class ConvertToMP3 extends StatefulWidget {
  const ConvertToMP3({Key? key}) : super(key: key);

  @override
  _ConvertToMP3State createState() => _ConvertToMP3State();
}

class _ConvertToMP3State extends State<ConvertToMP3> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _playerIsInited = false;
  bool _recoderIsInited = false;
  bool _playbackReady = false;
  String _pathAAC = '';
  String _pathMP3 = '';

  @override
  void initState() {
    _player!.openAudioSession().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });
    _recorder!.openAudioSession().then((value) {
      setState(() {
        _recoderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _player!.closeAudioSession();
    _player = null;

    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future<void> openTheRecoder() async {
    //TODO ------------여기서부터 하면 됨~~~
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

