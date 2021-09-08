// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheData _$CacheDataFromJson(Map<String, dynamic> json) {
  return CacheData(
    date: DateTime.parse(json['date'] as String),
    wordList: (json['wordList'] as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList(),
  );
}

Map<String, dynamic> _$CacheDataToJson(CacheData instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'wordList': instance.wordList,
    };
