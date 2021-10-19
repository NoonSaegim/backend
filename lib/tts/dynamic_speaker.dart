import 'dart:io' show Platform;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/tts/audio_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../vo/word.dart';
import '../common/popup.dart';

class Speaker extends StatelessWidget {
  final List<Word> dataList;
  const Speaker({Key? key, required this.dataList}) : super(key: key);

  dynamic _listOfObjToMap(List<Word> listObj) {

    Map<String, String> merge = new Map();
    listObj.sort((x,y) => x.seq!.compareTo(y.seq!)); //map convert 전 sort
    listObj.forEach((e) {
      merge.addAll(e.toMap());
    });
    return merge;
  }

  Widget _renderSpeaker(BuildContext context) {
    List<Word> listObj = dataList.where((e) => e.isSelected!).toList();
    return IconButton(
      onPressed: () async {
        if(listObj.isEmpty) {
          alert.onWarning(context, '단어를 선택하세요!', () { });
          return;
        } else {
          Map<String, dynamic> params = _listOfObjToMap(listObj);
          await initAudioService(params);
          await startTts();
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
      child: StreamBuilder<PlaybackState>(
        stream: getPlaybackState(),
        builder: (context, snapshot) {
          final running = snapshot.hasData ? snapshot.data!.playing : false;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!running) ...[
                // UI to show when we're not running, i.e. a menu.
                if (kIsWeb || !Platform.isMacOS) _renderSpeaker(context),
              ] else ...[
                StreamBuilder<bool>(
                  stream: getPlaybackState()!
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
  onPressed: () async => startTts(),
);

IconButton pauseButton() => IconButton(
  icon: Icon(Icons.pause, color: Colors.black45),
  iconSize: 32.sp,
  onPressed: () async => pauseTts(),
);

IconButton stopButton() => IconButton(
  icon: Icon(Icons.stop, color: Colors.black45),
  iconSize: 32.sp,
  onPressed:  () async => stopTts(),
);


