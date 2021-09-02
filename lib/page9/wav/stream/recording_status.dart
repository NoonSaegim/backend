import 'package:rxdart/rxdart.dart';
import '../audio_recorder.dart';

class CurrentStatus {
  BehaviorSubject<RecordingStatus> _currentStatus = BehaviorSubject<RecordingStatus>.seeded(RecordingStatus.Unset);

  get stream => _currentStatus.stream;

  setCurrentStatus(RecordingStatus? status) {
    _currentStatus.sink.add(status!);
  }

  dispose() => _currentStatus.close();
}

var currentStatus = CurrentStatus();
