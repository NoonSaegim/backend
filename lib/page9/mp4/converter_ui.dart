import 'dart:async';
import 'dart:io';
import '../../common/popup.dart';
import 'package:flutter/material.dart';
import 'audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../../database/dto/voca.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import '../../tts/text_player.dart';

void _textToSpeechEntrypoint() async {
  AudioServiceBackground.run(() => new TextPlayer())
      .then((value) => null);
}

class SaveAsWav extends StatelessWidget {
  const SaveAsWav({Key? key}) : super(key: key);
  final _color = Colors.pinkAccent;


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
    if(ModalRoute.of(context)!.settings.arguments != null) {

    }
    return Container(
      child: StreamBuilder<bool>(
        stream: AudioService.runningStream, ///오디오가 종료되면 자동으로 녹음을 중단하기 위함.
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();
          }
          final isRunning = snapshot.data ?? false;
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 15.sp),
                  Text(
                    (current == null) ? "0:0:0:0" : current!.duration.toString(),
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
                        child: (!isRunning && !stop && _currentStatus == RecordingStatus.Initialized) ?
                        IconButton(
                          onPressed: () async {
                            Map<String, dynamic> params = onlyWordMap([...widget.voca.wordList]);
                            await onStartPressed(); //녹음 시작
                            _callAudioService(params);  //tts 시작
                          },
                          icon: SvgPicture.asset(
                            'imgs/start.svg',
                            placeholderBuilder: (BuildContext context) => Container(
                                child: const CircularProgressIndicator()
                            ),
                          ),
                          iconSize: 50.sp,
                        )
                            : CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 13.0,
                          percent: 0.3,
                          animation: true,
                          animationDuration: 1200,
                          footer: new Text("Icon header"),
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.lightBlueAccent,
                        )
                    ),
                  ), if(!isRunning) _stop()
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
