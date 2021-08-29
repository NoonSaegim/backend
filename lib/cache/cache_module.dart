import 'dart:async';
import 'dart:math';
import 'vo/cache_data.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> addCacheData(List<Map<String, String>> dataList) async {
  //json 캐시 설정
  final prefs = await SharedPreferences.getInstance();
  final JsonCacheMem jsonCache = JsonCacheMem(JsonCachePrefs(prefs));

  final streamPref = await StreamingSharedPreferences.instance;
  int cacheCount = (streamPref.getInt('cacheCount', defaultValue: 0) as int) + 1;
  List<String> cacheKeys = streamPref.getStringList('cacheKeys', defaultValue: []) as List<String>;
  String key = 'detected_words_$cacheCount';
  await jsonCache.refresh(key,CacheData(seq: cacheCount, date: DateTime.now(), wordList: dataList).toJson())
    .then((value) {
      print('----------add cache data success---------');
      streamPref.setInt('cacheCount', cacheCount);
      cacheKeys.add(key);
      streamPref.setStringList('cacheKeys', cacheKeys);
    });
}

Future<Preference<int>> fetchCacheableDays() async {
  return await StreamingSharedPreferences.instance
      .then((StreamingSharedPreferences pref) => pref.getInt('cacheableDays', defaultValue: 1));
}

Future<List<CacheData>> getCacheList() async {
  final streamPref = await StreamingSharedPreferences.instance;
  List<String> cacheKeys = streamPref.getStringList('cacheKeys', defaultValue: []) as List<String>;

  List<CacheData> cacheDataList = List.generate(cacheKeys.length,
          (index) => CacheData.fromJson(getCacheData(cacheKeys[index]) as Map<String, dynamic>));
  return cacheDataList;
}

Future<Map<String, dynamic>> getCacheData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final JsonCacheMem jsonCache = JsonCacheMem(JsonCachePrefs(prefs));
  return await jsonCache.value(key)
      .then((FutureOr<dynamic> data) => data as Map<String, dynamic>);
}

Future<void> clearExpiredCache() async {
  final pref = await StreamingSharedPreferences.instance;
  final int cacheableDays = pref.getInt('cacheableDays', defaultValue: 1) as int;
  List<CacheData> cacheList = await getCacheList();
  if(cacheList.isNotEmpty) {
    List<CacheData> expiredList = cacheList.where((e) => DateTime.now().compareTo(e.date.add(Duration(days: cacheableDays))) == 0).toList();
    expiredList.forEach((e) {
      String key = 'detected_words_${e.seq}';
      removeCache(key);
    });
  }
}

Future<void> removeCache(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final JsonCacheMem jsonCache = JsonCacheMem(JsonCachePrefs(prefs));
  await jsonCache.remove(key).then((value) => print('--------------remove cache----------key: $key'));
}
