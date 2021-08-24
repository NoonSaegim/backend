import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:rflutter_alert/rflutter_alert.dart';

class Accordion extends StatefulWidget {
  final String title;
  final content;
  Accordion(this.title, this.content);

  @override
  _AccordionState createState() => _AccordionState(this.title);
}

class _AccordionState extends State<Accordion> {
  final String title;
  _AccordionState(this.title);

  bool _showContent = false;
  int _listCount = 15;

  _onDeleteButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete ${this.title}",
      desc: "${this.title}을 삭제하시겠습니까?",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.cyan,
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ]),
        )
      ],
    ).show();
  }

  _renderToggleButton() {
    if(_showContent) {
      return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(math.pi),
          child: SvgPicture.asset(
            'imgs/arrow-down.svg',
            placeholderBuilder: (BuildContext context) => Container(
                child: const CircularProgressIndicator()
            ),
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.035,
            alignment: Alignment.centerRight,
          ),
      );
    } else {
      return SvgPicture.asset(
        'imgs/arrow-down.svg',
        placeholderBuilder: (BuildContext context) => Container(
            child: const CircularProgressIndicator()
        ),
        height: (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top) * 0.035,
        alignment: Alignment.centerRight,
      );
    }
  }

  _renderVocabulary() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              'mango',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black54
              )
          ),
          IconButton(
            onPressed: () => print('request audio api'),
            tooltip: 'Audio',
            icon: SvgPicture.asset(
              'imgs/audio.svg',
              placeholderBuilder: (BuildContext context) => Container(
                  child: const CircularProgressIndicator()
              ),
              height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top) * 0.05,
            ),
          ),
          Text(
              '망고',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black54
              )
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            offset: Offset(0.0, 8.0),
          )
        ],
      ),
      child: Card(
        margin: EdgeInsets.all(0.4),
        child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top) * 0.095,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      title: Text(widget.title, style: TextStyle(color: Colors.black54)),
                      trailing: IconButton(
                          onPressed: () => setState(() => _showContent = !_showContent),
                          icon: _renderToggleButton(),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  _showContent
                      ?
                      Container(
                        height: (MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top) * 0.5,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.05,
                              padding: EdgeInsets.only(top: 16.0, right: 16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '2021-08-22',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize:13,
                                      color: Colors.black54
                                  )
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right:15.0),
                              height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.35,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width * 0.42,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: _listCount,
                                          itemBuilder: (BuildContext context, int index) => _renderVocabulary(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                      child: VerticalDivider(color: Colors.grey.withOpacity(0.9), thickness: 0.7),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width * 0.42,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: _listCount,
                                          itemBuilder: (BuildContext context, int index) => _renderVocabulary(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Container(
                                height: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height -
                                    MediaQuery.of(context).padding.top) * 0.1,
                                //alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => print('request pdf Download'),
                                      tooltip: 'PDF',
                                      icon: SvgPicture.asset(
                                        'imgs/pdf.svg',
                                        placeholderBuilder: (BuildContext context) => Container(
                                            child: const CircularProgressIndicator()
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => print('request mp3 Download'),
                                      tooltip: 'MP3',
                                      icon: SvgPicture.asset(
                                        'imgs/mp3.svg',
                                        placeholderBuilder: (BuildContext context) => Container(
                                            child: const CircularProgressIndicator()
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _onDeleteButtonPressed(context),
                                      tooltip: 'DELETE',
                                      icon: SvgPicture.asset(
                                        'imgs/delete.svg',
                                        placeholderBuilder: (BuildContext context) => Container(
                                            child: const CircularProgressIndicator()
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        )
                      ) : Container()
                ],
            ),
        ),
      ),
    );
  }
}