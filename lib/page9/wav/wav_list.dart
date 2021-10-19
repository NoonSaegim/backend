import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayList extends StatefulWidget {
  final List<String> records;
  const PlayList({Key? key, required this.records}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late int _totalTime;
  late int _currentTime;
  double _percent = 0.0;
  int _selected = -1;
  bool isPlay=false;

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  String _getTitle({required filePath}) {
    return filePath.substring(filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('@'));
    //return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          elevation: 5,
          child: ExpansionTile(
            title: Text(
              _getTitle(filePath:widget.records.elementAt(i)),
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              _getTime(filePath: widget.records.elementAt(i)),
              style: TextStyle(color: Colors.black38),
            ),
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  _selected = i;
                });
              }
            }),
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.black45,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                      value: _selected == i ? _percent : 0,
                    ),
                    Row(
                      children: [
                        (isPlay)? _Presso(
                            ico: Icons.pause,
                            onPressed: () {
                              setState(() {
                                isPlay=false;
                              });
                              advancedPlayer.pause();
                            }): _Presso(
                            ico: Icons.play_arrow,
                            onPressed: () {
                              setState(() {
                                isPlay=true;
                              });
                              advancedPlayer.play(widget.records.elementAt(i),
                                  isLocal: true);
                              setState(() {});
                              setState(() {
                                _selected = i;
                                _percent = 0.0;
                              });
                              advancedPlayer.onPlayerCompletion.listen((_) {
                                setState(() {
                                  _percent = 0.0;
                                });
                              });
                              advancedPlayer.onDurationChanged.listen((duration) {
                                setState(() {
                                  _totalTime = duration.inMicroseconds;
                                });
                              });
                              advancedPlayer.onAudioPositionChanged
                                  .listen((duration) {
                                setState(() {
                                  _currentTime = duration.inMicroseconds;
                                  _percent = _currentTime.toDouble() /
                                      _totalTime.toDouble();
                                });
                              });
                            }),
                        _Presso(
                            ico: Icons.stop,
                            onPressed: () {
                              advancedPlayer.stop();
                              setState(() {
                                _percent = 0.0;
                              });
                            }),
                        _Presso(
                            ico: Icons.delete,
                            onPressed: () {
                              Directory appDirec =
                              Directory(widget.records.elementAt(i));
                              appDirec.delete(recursive: true);
                              Fluttertoast.showToast(msg: "File Deleted");
                              setState(() {
                                widget.records
                                    .remove(widget.records.elementAt(i));
                              });
                            }),
                        _Presso(
                            ico: Icons.share,
                            onPressed: () {
                              Directory appDirec =
                              Directory(widget.records.elementAt(i));
                              List<String>list=List.empty(growable: true);
                              list.add(appDirec.path);
                              Share.shareFiles(list);
                            }),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTime({required String filePath}) {
    String fromPath = filePath.substring(
        filePath.lastIndexOf('@') + 1).split('.')[0];
    if (fromPath.startsWith("1", 0)) {
      DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(fromPath));
      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;
      int hour = dateTime.hour;
      int min = dateTime.minute;
      String dato = '$year-$month-$day--$hour:$min';
      return dato;
    } else {
      return "No Date";
    }
  }
}

class _Presso extends StatelessWidget {
  final IconData ico;
  final VoidCallback onPressed;

  const _Presso({Key? key, required this.ico,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.5.sp),
      child: ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(
            color: Colors.cyan ,
            child: Icon(
              ico,
              color: Colors.white,
            ),
            onPressed: onPressed),
      ),
    );
  }
}
