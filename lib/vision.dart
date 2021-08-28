import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {

  ByteData bytes = await rootBundle.load('images/horse.jpg');
  var buffer = bytes.buffer;
  var m = base64.encode(Uint8List.view(buffer));

  Map<String,dynamic> requestJson = {
      "request_id": "reserved field",
      'access_key': 'db348fbb-c8ff-41ca-9ed3-d8505a31ffba',
      'argument' : {
        'type': 'jpg',
        'file': m
      }
  };
  final response = await http.post(Uri.parse('http://aiopen.etri.re.kr:8000/ObjectDetect'),
      body: json.encode(requestJson)
      );

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('실패코드('+response.statusCode.toString()+")"+response.reasonPhrase.toString());
  }
}

class Album {
  final String title;
  final String Class;
  final String confidence;
  final String x;
  final String y;
  final String width;
  final String height;

  Album({
    required this.title,
    required this.Class,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      Class : json['class'],
      confidence : json['confidence'],
      x : json['x'],
      y : json['y'],
      width : json['width'],
      height : json['height'],
    );
  }
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision API 예제',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vision API 예제'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}