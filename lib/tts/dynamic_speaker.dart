import 'dart:io' show Platform;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'text_player.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../vo/word.dart';
import '../common/popup.dart';

void _textToSpeechEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayer());
}

class Speaker extends StatelessWidget {
  final List<Word> dataList;
  const Speaker({Key? key, required this.dataList}) : super(key: key);

  void _callAudioService(Map<String, dynamic> params) {
    AudioService.connect();
    print('params = $params');
    AudioService.start(
      backgroundTaskEntrypoint: _textToSpeechEntrypoint,
      androidNotificationChannelName: 'Voca Audio Service',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }

  dynamic _listOfObjToMap(List<Word> listObj) {

    Map<String, String> merge = new Map();
    listObj.sort((x,y) => x.seq!.compareTo(y.seq!)); //map convert 전 sort
    listObj.forEach((e) {
      merge.addAll(e.toMap());
    });
    return merge;
  }

  Widget _renderSpecker(BuildContext context) {
    List<Word> listObj = dataList.where((e) => e.isSelected!).toList();

    return IconButton(
      onPressed: () {
        if(listObj.isEmpty) {
          alert.onWarning(context, '단어를 선택하세요!', () { });
          return;
        } else {
          Map<String, dynamic> params = _listOfObjToMap(listObj);
          _callAudioService(params);
        }
      },
      tooltip: 'Audio',
      iconSize: 32.sp,
      icon: SvgPicture.asset(
        'imgs/audio.svg',
        placeholderBuilder: (BuildContext context) => Container(
            child: const CircularProgressIndicator()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<bool>(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();
          }
          final running = snapshot.data ?? false;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!running) ...[
                // UI to show when we're not running, i.e. a menu.
                if (kIsWeb || !Platform.isMacOS) _renderSpecker(context),
              ] else ...[
                StreamBuilder<bool>(
                  stream: AudioService.playbackStateStream
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (playing) pauseButton() else playButton(),
                        stopButton(),
                      ],
                    );
                  },
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}


IconButton playButton() => IconButton(
  icon: Icon(Icons.play_arrow, color: Colors.black45),
  iconSize: 32.sp,
  onPressed: AudioService.play,
);

IconButton pauseButton() => IconButton(
  icon: Icon(Icons.pause, color: Colors.black45),
  iconSize: 32.sp,
  onPressed: AudioService.pause,
);

IconButton stopButton() => IconButton(
  icon: Icon(Icons.stop, color: Colors.black45),
  iconSize: 32.sp,
  onPressed: AudioService.stop,
);
