import 'package:shared_preferences/shared_preferences.dart';

//pref 설정
initCachePref() async {
  final pref = await SharedPreferences.getInstance();
  pref.setStringList('cacheKeys', []);  ///캐시 키 리스트 default
  pref.setInt('cacheableDays', 1);  ///캐시 저장 기간 default
  pref.setInt('cacheCount', 0); ///캐시 개수 default
}
