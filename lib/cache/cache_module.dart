import 'dart:async';
import 'vo/cache_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_cache_manager/data_cache_manager.dart';

late DataCacheManager _cacheManager;

Future<void> addCacheData(List<Map<String, String>> dataList) async {
  final prefs = await SharedPreferences.getInstance();
  int cacheable = prefs.getInt('cacheableDays') ?? 1;

  //cache manager 설정
  _cacheManager = DataCacheManager(
    config: Config(
      stalePeriod: Duration(days: cacheable),
    )
  );

  List<String> cacheKeys = prefs.getStringList('cacheKeys') ?? [];

  final key = 'detected_words_${cacheKeys.length}';
  final Map<String, String> value1 = {
    'date': DateTime.now().toString(),
  };
  final Map<String, int> param1 = {'date':0};
  final Map<String, List<Map<String, String>>> value2 = {
    'wordList' : dataList,
  };
  final Map<String, int> param2 = {'data':1};

  /// 같은 키에 date, wordList 나눠서 저장
  await _cacheManager.add(key,value1, queryParams: param1)
      .then((value) async => await _cacheManager.add(key, value2, queryParams: param2))
        .then((value) {
          print('----------add cache data success---------');
          prefs.setInt('cacheCount', cacheKeys.length);
          cacheKeys.add(key);
          prefs.setStringList('cacheKeys', cacheKeys);
        });
}

Future<int> fetchCacheableDays() async {
  final prefs = await SharedPreferences.getInstance();
  int cacheable = prefs.getInt('cacheableDays')!;
  return cacheable;
}

Future<List<CacheData?>> getCacheList() async {
  print('getCacheList call');
  final prefs = await SharedPreferences.getInstance();
  List<String> cacheKeys = prefs.getStringList('cacheKeys')!;
  print('caches : ${cacheKeys.length}');
  List<CacheData?> cacheDataList = [];
  for(var key in cacheKeys) {
    cacheDataList.add(CacheData.fromJson(await getCacheData(key) ?? {}));
  }
  return cacheDataList;
}

Future<Map<String, dynamic>?> getCacheData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  int cacheable = prefs.getInt('cacheableDays')!;

  final dateCache = await _cacheManager.get(key, queryParams: {'date':0});
  final Map<String, dynamic> date = json.decode(json.encode(dateCache?.value));
  print('date: $date');

  if(DateTime.now().compareTo(DateTime.parse(date['date']!).add(Duration(days: cacheable))) == 0) {

    await _cacheManager.remove(key).then((value) async {
     final prefs = await SharedPreferences.getInstance();
     List<String> cacheKeys = prefs.getStringList('cacheKeys')!;
     int cacheCount = prefs.getInt('cacheCount')!;
     cacheKeys.remove(key);
     cacheCount--;
     prefs.setStringList('cacheKeys', cacheKeys);
     prefs.setInt('cacheCount', cacheCount);
     print('-----delete expired cache----now caches count: $cacheCount');
   });
   return null;

  } else {

    Map<String,dynamic> cacheData = new Map();
    cacheData.addAll(date);
    final dataCache = await _cacheManager.get(key, queryParams: {'data': 1});
    print(dataCache);
    final Map<String, dynamic> dataList = json.decode(json.encode(dataCache?.value));
    cacheData.addAll(dataList);

    return cacheData;
  }
}
