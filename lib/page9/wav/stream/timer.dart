import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AudioTimer {
  Stopwatch _timer = Stopwatch();

  BehaviorSubject<String> _display = BehaviorSubject<String>.seeded("0.0.0.0");
  BehaviorSubject<bool> _isRunning = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<Duration> _duration = BehaviorSubject<Duration>.seeded(Duration());

  Stream<String> get observable => _display.stream;
  Stream<bool> get isRunning => _isRunning.stream;
  Stream<Duration> get duration => _duration.stream;

  setIsTimerRunning(bool value) => _isRunning.sink.add(value);
  setTimerDisplay(String milliseconds) => _display.sink.add(milliseconds);

  dispose() {
    _display.close();
    _isRunning.close();
    _duration.close();
  }

  void startTimer() {
    print('----start timer-----');
    _isRunning.value = true;
    _timer.start();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(seconds: 1), _keepRunning);
  }

  void _keepRunning() {
    //Stop the timer from overflowing, max value should be 99:99
    if (!_isRunning.value) {
      _timer.stop();
      print('----stop timer-----');
      return;
    }
    if (_timer.isRunning) {
      _duration.sink.add(Duration(milliseconds: _timer.elapsedMilliseconds));
      _display.sink.add(Duration(milliseconds: _timer.elapsedMilliseconds).toString());
      _startTimer();
    }

    //print('------${Duration(milliseconds: _timer.elapsedMilliseconds).toString()}------');
  }
}
var timer = AudioTimer();