import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchAlert {
  SwitchAlert() {
    Future.delayed(Duration.zero, () async {
      final pref = await SharedPreferences.getInstance();
      bool onoff = pref.getBool('notification') ?? false;
      _onAndOff = BehaviorSubject<bool>.seeded(onoff);
      print('notification seed: ${_onAndOff.stream.value}');
    });
  }
  var _onAndOff;
  get isOn => _onAndOff?.stream;

  setOnAndOff(bool isOn) async {
    _onAndOff.sink.add(isOn);
    await SharedPreferences.getInstance()
    .then((SharedPreferences pref) => pref.setBool('notification', isOn))
        .then((value) => print('-----set notification : $isOn----'));
  }
  dispose() => _onAndOff.close();
}

var on = SwitchAlert();



