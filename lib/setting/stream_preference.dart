import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

//반응형 pref 설정
initStreamPref() async {
  final pref = await StreamingSharedPreferences.instance;
  pref.setStringList('cacheKeys', []);  //캐시 키 리스트 default
  pref.setInt('cacheableDays', 1);  //캐시 저장 기간 default
  pref.setInt('cacheCount', 0); //캐시 개수 default
}