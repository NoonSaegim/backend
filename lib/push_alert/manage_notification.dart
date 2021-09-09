import 'package:workmanager/workmanager.dart';

Future<void> allOff() async {
  await Workmanager().cancelAll()
    .then((value) => print('[Workmanager] turn off all notification'));
}

Future<void> turnOff(String uid) async {
  await Workmanager().cancelByUniqueName(uid)
      .then((value) => print('[Workmanager] turn off notification schedule - task : $uid'));
}


