import 'package:flutter/material.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import './accordion.dart';
import 'package:sizer/sizer.dart';

class MyNote extends StatefulWidget {
  const MyNote({Key? key}) : super(key: key);

  @override
  _MyNoteState createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  int _listSize = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: SideBar(),
        appBar: AppBar2(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child : Column(
                    children:
                      <Widget>[
                        SizedBox(height: 8.sp,),
                        Container(
                          padding: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.03,
                          ),
                          height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) - 8.sp,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _listSize,
                              itemBuilder: (BuildContext context, int index) {
                                return Accordion('단어장 #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam bibendum ornare vulputate. Curabitur faucibus condimentum purus quis tristique.');
                              }
                          ),
                        )
                      ],
                  ),
            ),
        );

  }
}

