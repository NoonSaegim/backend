import 'package:flutter/material.dart';
import 'package:noonsaegim/page9/wav/wav_list.dart';
import 'wav_list.dart';
import '../../common/noon_appbar.dart';
import '../../setting/file_list_argument.dart';
import 'package:sizer/sizer.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key? key}) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {

  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context)!.settings.arguments != null) {
      final wavList = ModalRoute.of(context)!.settings.arguments as WavList;
      return FutureBuilder(
          future: wavList.onInit,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final records = snapshot.data as List<String>;
              return Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.lightBlueAccent,
                  onPressed: () {  },
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/mynote'),
                    icon: Icon(Icons.menu_book,),
                    iconSize: 24.sp,
                  ),
                ),
                appBar: AppBar1(),
                body: Container(
                  padding: EdgeInsets.only(top: 8.5.sp),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: PlayList(records: records),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {  },
          child: IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/mynote'),
            icon: Icon(Icons.menu_book,),
            iconSize: 24.sp,
          ),
        ),
        appBar: AppBar1(),
        body:Center(
          child: Text('No File Path Received..'),
        ),
      );
    }
  }
}
