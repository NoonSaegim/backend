import 'package:flutter/material.dart';
import 'package:noonsaegim/database/dto/voca.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import './accordion.dart';
import 'package:sizer/sizer.dart';
import '../database/hive_module.dart';
import '../common/popup.dart';
import '../setting/note_argument.dart';

class MyNote extends StatefulWidget {
  const MyNote({Key? key}) : super(key: key);

  @override
  _MyNoteState createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  final _showSeq = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: SideBar(),
        appBar: AppBar2(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child : FutureBuilder(
            future: fetchVocaList(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData) return CircularProgressIndicator();
              else if(snapshot.hasError) return alert.onError(context, 'Error: ${snapshot.error}',);
              else {//데이터를 정상적으로 받아왔으면
                var vocaList = snapshot.data as List<Voca>;
                vocaList = vocaList.reversed.toList();

                return Column(
                  children:
                  <Widget>[
                    SizedBox(height: 8.5.sp,),
                    Container(
                      color: Colors.white,
                      height: (MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top) - 8.sp,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vocaList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if(ModalRoute.of(context)!.settings.arguments != null) {
                              final args = ModalRoute.of(context)!.settings.arguments as NoteArgument;
                              return Accordion(vocaList[index], index, args.seq);
                            } else {
                              return Accordion(vocaList[index], index, _showSeq);
                            }
                          }
                      ),
                    )
                  ],
                );
              }
            },
          )
        ),
    );
  }
}

