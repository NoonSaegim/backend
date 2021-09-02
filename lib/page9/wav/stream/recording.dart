import 'package:rxdart/rxdart.dart';
import '../audio_recorder.dart';
import 'audio_recorder.dart';

class Current {
  BehaviorSubject<Recording> _current = BehaviorSubject<Recording>.seeded(Recording());
  Future<Recording> getRecording () async => await audioRecorder.stream.current(channel: 0);

  get stream => _current.stream;
  get status => _current.stream.value.status;

  setCurrent(Recording? recording) {
    _current.sink.add(recording!);
  }
  setDuration(Duration? duration) {
    setCurrent(Recording.withDuration(duration));
  }
  dispose() => _current.close();
}

var current = Current();