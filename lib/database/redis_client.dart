import 'package:redis_dart/redis_dart.dart';

void insertData(var json) async {
  final client = await RedisClient.connect('localhost');

 // await client.setMap('', value)
}