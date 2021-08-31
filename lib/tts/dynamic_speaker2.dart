import 'dart:io' show Platform;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'text_player.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/popup.dart';

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

  void _callAudioService(Map<String, dynamic> params) {
    AudioService.connect();
    AudioService.start(
      backgroundTaskEntrypoint: _textToSpeechEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }
  Widget _renderSpecker(BuildContext context) {
    Map<String, dynamic> params = new Map();

    return IconButton(
      onPressed: () => _callAudioService(params),
      tooltip: 'Audio',
      iconSize: 25.sp,
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
  iconSize: 25.sp,
  onPressed: AudioService.play,
);

IconButton pauseButton() => IconButton(
  icon: Icon(Icons.pause, color: Colors.black45),
  iconSize: 25.sp,
  onPressed: AudioService.pause,
);

IconButton stopButton() => IconButton(
  icon: Icon(Icons.stop, color: Colors.black45),
  iconSize: 25.sp,
  onPressed: AudioService.stop,
);