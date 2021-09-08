import 'package:noonsaegim/cache/cache_module.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheablePeriod {
  CacheablePeriod() {
    Future.delayed(Duration.zero, () async {
      final pref = await SharedPreferences.getInstance();
      int init = pref.getInt('cacheableDays') ?? 1;
      _cacheable = BehaviorSubject<int>.seeded(init);
      print('cacheable seed: ${_cacheable.stream.value}');
    });
  }
  
  var _cacheable;

  get days => _cacheable?.stream;

  setCacheable(int days) async {
    _cacheable.sink.add(days);
    await SharedPreferences.getInstance()
      .then((SharedPreferences pref) => pref.setInt('cacheableDays', days))
          .then((value) => print('-----set new cacheable days: $days----'))
              .then((value) async => await initCacheManager());
  }

  dispose() => _cacheable.close();
}

var cacheable = CacheablePeriod();