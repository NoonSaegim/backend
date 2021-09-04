import 'package:json_annotation/json_annotation.dart';
part 'cache_data.g.dart';

@JsonSerializable()
class CacheData {
  CacheData({
    required this.seq,
    required this.date,
    required this.wordList,
  });

  int seq;
  DateTime date;
  List<Map<String, String>> wordList;

  factory CacheData.fromJson(Map<String, dynamic> json) => _$CacheDataFromJson(json);
  Map<String, dynamic> toJson() => _$CacheDataToJson(this);
}