import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:core';
import 'sleeper.dart';
import 'package:audio_session/audio_session.dart';
import 'package:file_picker/file_picker.dart';

class TextPlayer extends BackgroundAudioTask {
  Tts _tts = Tts();
  bool _finished = false;
  Sleeper _sleeper = Sleeper();
  Completer _completer = Completer();
  bool _interrupted = false;

  bool get _playing => AudioServiceBackground.state.playing;

  @override
  Future<void> onStart(Map<String,dynamic>? params) async {

    final session = await AudioSession.instance;
    await session.configure(new AudioSessionConfiguration.speech());
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          onPause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              onPlay();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) onPause();
    });
    // Start playing.
    await _playPause();
    num length = params?.keys.length as num;
    var keySet = params?.keys.toList();

    if(length > 0 && keySet!.isNotEmpty){
      for (var i = 0; i < length && !_finished;) {
        AudioServiceBackground.setMediaItem(mediaItem(i));
        AudioServiceBackground.androidForceEnableMediaButtons();
        try {
          String key = keySet[i];
          await _tts.speak('${params?[key]}');
          i++;
          await _sleeper.sleep(Duration(milliseconds: 300));
        } catch (e) {
          // Speech was interrupted
        }
        // If we were just paused
        if (!_finished && !_playing) {
          try {
            // Wait to be unpaused
            await _sleeper.sleep();
          } catch (e) {
            // unpaused
          }
        }
      }
    }
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    if (!_finished) {
      onStop();
    }
    _completer.complete();
    params?.clear();
  }

  @override
  Future<void> onPlay() => _playPause();

  @override
  Future<void> onPause() => _playPause();

  @override
  Future<void> onStop() async {
    // Signal the speech to stop
    _finished = true;
    _sleeper.interrupt();
    _tts.interrupt();
    // Wait for the speech to stop
    await _completer.future;
    // Shut down this task
    await super.onStop();
  }

  MediaItem mediaItem(int index) => MediaItem(
      id: 'tts_$index',
      album: 'Voca',
      title: 'TextPlayer $index',
      artist: 'NoonSaegim');

  Future<void> _playPause() async {
    if (_playing) {
      _interrupted = false;
      await AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
      _sleeper.interrupt();
      _tts.interrupt();
    } else {
      final session = await AudioSession.instance;
      if (await session.setActive(true)) {
        await AudioServiceBackground.setState(
          controls: [MediaControl.pause, MediaControl.stop],
          processingState: AudioProcessingState.ready,
          playing: true,
        );
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
    File saveFile = new File(path);
    saveFile.create(recursive: true).then((File wav) async {
      _flutterTts.getDefaultEngine.asStream().listen((event) { });
      await _flutterTts.synthesizeToFile(text,wav.path)
          .then((value) => print('--------save wav success-------'));
    });
  }

  bool get playing => _playing;

  Future<void> speak(String text) async {
    print(text);
    _playing = true;

    if (!_interruptRequested) {
      _speechCompleter = Completer();
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
