import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:noonsaegim/tts/text_player.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/database/dto/voca.dart';
import 'audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void _textToSpeechEntrypoint() async {
  AudioServiceBackground.run(() => new TextPlayer())
      .then((value) => null);
}

class TestRecorder extends StatefulWidget {
  final Voca voca;
  final Function save;
  const TestRecorder({Key? key, required this.voca, required this.save}) : super(key: key);

  @override
  _TestRecorderState createState() => _TestRecorderState();
}

class _TestRecorderState extends State<TestRecorder> {

  IconData _recordIcon = Icons.mic_none;
  MaterialColor _color = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording? _current;
  late FlutterAudioRecorder? audioRecorder;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentStatus = RecordingStatus.Initialized;
      _recordIcon = Icons.mic;
      print('-----------Initialized------------');
    });
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }

  void _callAudioService(Map<String, dynamic> params) {
    AudioService.connect();
    AudioService.start(
      backgroundTaskEntrypoint: _textToSpeechEntrypoint,
      androidNotificationChannelName: 'Voca Audio Service',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }

  dynamic onlyWordMap(List<Map<String, String>> wordList) {
    Map<String, String> merge = new Map();
    for(var i = 0; i < wordList.length; i ++) {
      var map = wordList[i];
      merge['$i'] = map['word'].toString();
    }
    print(merge);
    return merge;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();

          } else if(snapshot.hasData) {
            final _running = snapshot.data ?? false;
            final _runningStream = AudioService.runningStream;

            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 15.sp),
                    Text(
                      (_current == null) ? "0:0:0:0" : _current!.duration.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                    ),
                    SizedBox(height: 5.sp),
                    Container(
                      width: 100.sp,
                      height: 75.sp,
                      child: Card(
                          color: _color,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: !_running
                              ?
                          IconButton(
                            onPressed: () async {
                              Map<String, dynamic> params = onlyWordMap([...widget.voca.wordList]);
                              await _record(_runningStream, _currentStatus); //녹음 시작
                              _callAudioService(params); //tts 시작
                            },
                            icon: SvgPicture.asset(
                              'imgs/start.svg',
                              placeholderBuilder: (BuildContext context) => Container(
                                  child: const CircularProgressIndicator()
                              ),
                            ),
                            iconSize: 50.sp,
                          )
                              :
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 13.0,
                            percent: 0.3,
                            animation: true,
                            animationDuration: _current!.duration?.inMilliseconds as int,
                            footer: new Text("Icon header"),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.white,
                            progressColor: Colors.lightBlueAccent,
                          )
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Text('no Data');
          }
        }
    );
  }

  _record(ValueStream<bool> _runningStream,RecordingStatus? status) async {
    print('--------- recording start ----------');
    _runningStream.pairwise().listen((e) {
      if(status == RecordingStatus.Initialized) {
        _initial();
        _start();
        if(e.first && !e.last) {
          Fluttertoast.showToast(msg: "Stop Recording , File Saved");
          _stop();
        }
      }
    });
  }

  _initial() async {
    Directory? appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String title = "${widget.voca.title}-${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
    Directory appDirec = Directory("${appDir!.path}/$jrecord/");

    appDirec.create(recursive: true);
    String path = "${appDirec.path}$title";
    audioRecorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV);
    await audioRecorder!.initialized;
  }

  _start() async {
    Fluttertoast.showToast(msg: "Start Recording , Please Wait");
    await audioRecorder!.start();
    var recording = await audioRecorder!.current(channel: 0);
    setState(() {
      _current = recording!;
      _currentStatus = _current!.status!;
    });
  }

  _stop() async {
    print('--------- recording end ----------');
    var result = await audioRecorder!.stop();
    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    widget.save();
      setState(() {
        _current = result!;
        _currentStatus = _current!.status!;
        _current!.duration = null;
        _recordIcon = Icons.mic;
        stop = false;
      });
  }
}
