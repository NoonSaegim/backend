import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:noonsaegim/tts/sleeper.dart';
import 'package:rxdart/rxdart.dart';

AudioHandler? _audioHandler;
Map<String, dynamic>? _currentParams = Map();

Future<void> initAudioService(Map<String, dynamic>? params) async {
  print('params = $params / current = $_currentParams');
  if(mapEquals(_currentParams, params)) {
    ///param이 같으면 init을 2번 호출하지 않는다.
    print('same params');
  } else {
    print('different params');
    _currentParams = params;
    _audioHandler = null;
    _audioHandler = await AudioService.init(
      builder: () => TextPlayer(params),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'tts_service',
        androidNotificationChannelName: 'Text Player',
        androidNotificationOngoing: true,
      ),
    );
  }
}

Future<void> startTts() async {
  await _audioHandler?.prepare();
  await _audioHandler?.play();
}

Future<void> pauseTts() async {
  await _audioHandler?.pause();
}

Future<void> stopTts() async {
  await _audioHandler?.stop();
}

ValueStream<PlaybackState>? getPlaybackState() {
  print('playbackState: ${_audioHandler?.playbackState}');
  return _audioHandler?.playbackState;
}

class TextPlayer extends BaseAudioHandler with SeekHandler {
  final _tts = Tts();
  bool _finished = false;
  Sleeper _sleeper = Sleeper();
  Completer _completer = Completer();
  bool _interrupted = false;
  List<String> _textList = [];
  bool get _playing => super.playbackState.stream.value.playing;

  MediaItem getItem(int index) => MediaItem(
      id: 'tts_$index',
      album: 'Voca',
      title: 'TextPlayer $index',
      artist: '눈새김',
  );

  TextPlayer(Map<String, dynamic>? params) {
    super.playbackState.sink.add(PlaybackState(playing: false));
    num length = params?.keys.length as num;
    var keySet = params?.keys.toList();

    if(length > 0 && keySet!.isNotEmpty){
      for (var i = 0; i < length; i++) {
        mediaItem.add(getItem(i));
        String key = keySet[i];
        _textList.add('${params?[key]}');
      }
    }
  }

  TextPlayer.Plain() {}

  @override
  BehaviorSubject<PlaybackState> get playbackState => super.playbackState;

  @override
  Future<void> play() async {
    final session = await AudioSession.instance;
    await session.configure(new AudioSessionConfiguration.speech());
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          pause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              play();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) pause();
    });
    // Start playing.
    await _playPause();
    if(_textList.isNotEmpty && !_finished) {
      _audioHandler?.setShuffleMode(AudioServiceShuffleMode.all);
      for(var i = 0; i < _textList.length; i++) {
        try {
          await _tts.speak(_textList[i]);
          await _sleeper.sleep(Duration(milliseconds: 300));
        } catch (e){
        }
        if (!_finished && !_playing) {
          try {
            await _sleeper.sleep();
          } catch (e) {
          }
        }
      }
    }
    super.playbackState.sink.add(PlaybackState(
      controls: [],
      processingState: AudioProcessingState.completed,
      playing: false,
    ));
    if (!_finished) {
      await stop();
    }
    _completer.complete();
    _textList.clear();
  }

  @override
  Future<void> pause() async {
    _tts.interrupt();
    super.playbackState.sink.add(PlaybackState(
      controls: [],
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  @override
  Future<void> seek(Duration position) => _sleeper.sleep(position);

  @override
  Future<void> stop() async {
    await _tts.stop();
    super.playbackState.sink.add(PlaybackState(
      controls: [],
      processingState: AudioProcessingState.completed,
      playing: false,
    ));
  }

  Future<void> _playPause() async {
    if (_playing) {
      _interrupted = false;
      super.playbackState.sink.add(PlaybackState(
        controls: [MediaControl.play, MediaControl.stop],
        processingState: AudioProcessingState.ready,
        playing: false,
      ));
      _sleeper.interrupt();
      _tts.interrupt();
    } else {
      final session = await AudioSession.instance;
      if (await session.setActive(true)) {
        super.playbackState.sink.add(PlaybackState(
          controls: [MediaControl.play, MediaControl.stop],
          processingState: AudioProcessingState.ready,
          playing: true,
        ));
        _sleeper.interrupt();
      }
    }
  }

}

class Tts {

  final FlutterTts _flutterTts = new FlutterTts();
  Completer? _speechCompleter;
  bool _interruptRequested = false;
  bool _playing = false;

  Tts() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setCompletionHandler(() {
      _speechCompleter?.complete();
    });
  }

  Future<void> save(String text, String path) async {
    await _flutterTts.synthesizeToFile(text, path);
    await _flutterTts.awaitSynthCompletion(true);
  }

  bool get playing => _playing;

  Future<void> speak(String text) async {
    print(text);
    _playing = true;

   if (!_interruptRequested) {
      _speechCompleter = Completer();
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.speak(text);
      await _speechCompleter!.future;
      _speechCompleter = null;
    }
    _playing = false;
    if (_interruptRequested) {
      _interruptRequested = false;
      throw TtsInterruptedException();
    }
  }

  Future<void> stop() async {
    if (_playing) {
      await _flutterTts.stop();
      _speechCompleter?.complete();
    }
  }

  void interrupt() {
    if (_playing) {
      _interruptRequested = true;
      stop();
    }
  }
}

class TtsInterruptedException {}
