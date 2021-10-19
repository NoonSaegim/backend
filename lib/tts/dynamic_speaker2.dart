import 'dart:io' show Platform;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/tts/audio_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Speaker extends StatelessWidget {
  final String word;
  const Speaker({Key? key, required this.word}) : super(key: key);

  Widget _renderSpecker(BuildContext context) {
    Map<String, dynamic> params = { 'word': word };

    return IconButton(
      onPressed: () async {
        await initAudioService(params);
        await startTts();
      },
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
      child: StreamBuilder<PlaybackState>(
        stream: getPlaybackState(),
        builder: (context, snapshot) {
          final running = snapshot.hasData ? snapshot.data!.playing : false;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!running) ...[
                if (kIsWeb || !Platform.isMacOS) _renderSpecker(context),
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
  iconSize: 25.sp,
  onPressed: () async => startTts(),
);

IconButton pauseButton() => IconButton(
  icon: Icon(Icons.pause, color: Colors.black45),
  iconSize: 25.sp,
  onPressed: () async => pauseTts(),
);

IconButton stopButton() => IconButton(
  icon: Icon(Icons.stop, color: Colors.black45),
  iconSize: 25.sp,
  onPressed:  () async => stopTts(),
);