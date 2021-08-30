import 'dart:io' show Platform;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'text_player.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/popup.dart';
import 'package:provider/provider.dart';
import '../setting/bool_resize_speaker.dart';

// 맨 위에 있어야 함.
void _textToSpeechEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayer());
}

_checkAudioServiceState(BuildContext context) {
  AudioService.playbackStateStream.listen((PlaybackState state) {
    switch (state.processingState) {
      case AudioProcessingState.error: alert.onError(context, 'Error occured on Audio Service');
        return;
    }
  });
}

class Speaker extends StatelessWidget {
  const Speaker({Key? key}) : super(key: key);

  void _callAudioService(Map<String, dynamic> params, BuildContext context) {
    AudioService.connect();
    _checkAudioServiceState(context);

    AudioService.start(
      backgroundTaskEntrypoint: _textToSpeechEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }

  Widget _renderSpecker(context) {
    Map<String, dynamic> params = new Map();

    return IconButton(
      onPressed: () {
        _callAudioService(params, context);
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