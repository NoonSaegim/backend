import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/page9/wav/stream/recording.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../../database/dto/voca.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'stream/recording_status.dart';
import 'stream/audio_recorder.dart';
import 'package:sizer/sizer.dart';
import '../../tts/text_player.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:tuple/tuple.dart';
import 'stream/timer.dart';

void _textToSpeechEntrypoint() async {
  AudioServiceBackground.run(() => new TextPlayer())
      .then((value) => null);
}

class Recorder extends StatefulWidget {
  final Voca voca;
  final Function save;
  const Recorder({Key? key,required this.voca, required this.save}) : super(key: key);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {

  Recording? _current;
  final _color = Colors.pinkAccent;

  @override
  void dispose() {
    currentStatus.setCurrentStatus(RecordingStatus.Unset);
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
    return StreamBuilder4<RecordingStatus, FlutterAudioRecorder, bool, String>(
      ///사용할 stream 선언 : current, currentStatus, audioRecorder, running
        streams: Tuple4(currentStatus.stream, audioRecorder.stream, AudioService.runningStream, timer.observable),
        builder: (context, snapshot) {
          if(snapshot.item3.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();
          } else if(snapshot.item1.hasData && snapshot.item2.hasData && snapshot.item3.hasData && snapshot.item4.hasData) {

            final _currentStatus = snapshot.item1.data;
            final _audioRecorder = snapshot.item2.data;
            final _running = snapshot.item3.data ?? false;
            final _timerDisplay = snapshot.item4.data as String;

            final _runningStream = AudioService.runningStream;  /// audio 서비스가 끝난 것을 감지하기 위한 변수

            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 15.sp),
                    Text(
                      _timerDisplay,
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
                          child: (!_running)
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
                          Center(
                            child: CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 13.0,
                              percent: 1.0,
                              animation: true,
                              //animationDuration: _current!.duration?.inMilliseconds as int,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: Colors.grey,
                              progressColor: Colors.white,
                            ),
                          )
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  _record(ValueStream<bool> _runningStream,RecordingStatus? status) async {

    switch(status) {
      case RecordingStatus.Initialized: {
        _runningStream.pairwise().listen((e) {
          _initial();
          _start();
          timer.startTimer();

          if(e.first && !e.last) {
            Fluttertoast.showToast(msg: "Stop Recording , File Saved");
            _stop();
            timer.setIsTimerRunning(false);
          }
        });
        break;
      }
      default: break;
    }
  }

  _initial() async {
    Directory? appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String title = "${widget.voca.title}-${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
    Directory appDirec = Directory("${appDir!.path}/$jrecord/");

    appDirec.create(recursive: true);
    String path = "${appDirec.path}$title";
    print("path for file: $path");
    await audioRecorder.setAuioRecorder(path);
  }

  _start() async {
    Fluttertoast.showToast(msg: "Start Recording , Please Wait");
    await audioRecorder.start();
    print('--------- recording start ----------');
    await audioRecorder.current()
        .then((Recording? recording) {
          setState(() {
            _current = recording;
          });
          currentStatus.setCurrentStatus(_current?.status);
    });
  }

  _stop() async {
    print('--------- recording end ----------');
    await audioRecorder.stop()
        .then((Recording? recording) {
          widget.save();
          setState(() {
            _current = recording;
          });
          currentStatus.setCurrentStatus(RecordingStatus.Stopped);
          timer.setTimerDisplay("0.0.0.0");
    });
  }
}
