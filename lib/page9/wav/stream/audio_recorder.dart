import 'package:rxdart/rxdart.dart';
import '../audio_recorder.dart';

class AudioRecorder {
  BehaviorSubject<FlutterAudioRecorder> _audioRecorder 
    = BehaviorSubject<FlutterAudioRecorder>.seeded(FlutterAudioRecorder.initStream());
  
  get stream => _audioRecorder.stream;
  
  Future<void> setAuioRecorder(String path) async {
    _audioRecorder.sink.add(FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV));
    await _audioRecorder.value.initialized;
  }

  Future<Recording?> current() async => await _audioRecorder.value.current(channel: 0);
  Future<Recording?> start() async => await _audioRecorder.value.start();
  Future<Recording?> stop() async => await _audioRecorder.value.stop();

  dispose() => _audioRecorder.close();
}

var audioRecorder = AudioRecorder();