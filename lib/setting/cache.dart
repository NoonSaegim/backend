import 'package:flutter/cupertino.dart';

class CacheablePeriod with ChangeNotifier {
  int _cacheable = 1;

  int get cache => _cacheable;

  set cacheable(int period) {
    _cacheable = period;
    notifyListeners();
  }

}