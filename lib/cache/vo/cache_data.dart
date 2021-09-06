import 'package:json_annotation/json_annotation.dart';
part 'cache_data.g.dart';

@JsonSerializable()
class CacheData {
  CacheData({
    required this.date,
    required this.wordList,
  });

  DateTime date;
  List<Map<String, String>> wordList;

  factory CacheData.fromJson(Map<String, dynamic> json) => _$CacheDataFromJson(json);
  Map<String, dynamic> toJson() => _$CacheDataToJson(this);
}