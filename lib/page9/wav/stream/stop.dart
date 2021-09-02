import 'package:rxdart/rxdart.dart';

class Stop {
  BehaviorSubject<bool> _stop = BehaviorSubject<bool>.seeded(false);
  get stream => _stop.stream;
  setStop(bool value) => _stop.sink.add(value);
  dispose() => _stop.close();
}

var stop = Stop();