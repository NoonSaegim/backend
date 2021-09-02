import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noonsaegim/database/hive_module.dart';
import 'dart:math' as math;
import '../common/popup.dart';
import 'package:sizer/sizer.dart';
import '../database/dto/voca.dart';
import '../tts/dynamic_speaker2.dart';
import 'package:intl/intl.dart';
import '../database/hive_module.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'wav/open_records.dart';
import '../setting/permission.dart';

class Accordion extends StatefulWidget {
  final Voca voca;
  final int seq;
  final int showSeq;

  Accordion(this.voca, this.seq, this.showSeq);

  @override
  _AccordionState createState() => _AccordionState(this.voca, this.seq, this.showSeq);
}

class _AccordionState extends State<Accordion> {
  final Voca voca;
  final int seq;
  final int showSeq;

  _AccordionState(this.voca, this.seq, this.showSeq);

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    setState(() {
      _showContent = (seq == showSeq); //검색해서 클릭한 인덱스의 글이 열리게
    });
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

  _renderVocabulary(Map<String,String> row) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
              '${row['word']}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0.sp,
              )
          ),
          Speaker(word:'${row['word']}',),
          Text(
              '${row['meaning']}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13.0.sp,
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
            padding: EdgeInsets.only(left: 10.0.sp),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top) * 0.09,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      title: Text(
                          voca.title,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0.sp,
                          )
                      ),
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
                              padding: EdgeInsets.only(right: 14.0.sp),
                              alignment: Alignment.centerRight,
                              child: Text(
                                  new DateFormat('yyyy-MM-dd').format(voca.date),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize:10.sp,
                                      color: Colors.black54
                                  )
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right:10.0.sp),
                              height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.35,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height -
                                      MediaQuery.of(context).padding.top) * 0.35,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: voca.wordList.length,
                                        itemBuilder: (BuildContext context, int index) => _renderVocabulary(voca.wordList[index]),
                                      ),
                                    )
                                  ],
                                )
                              ),
                              Container(
                                color: Colors.white,
                                height: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height -
                                    MediaQuery.of(context).padding.top) * 0.1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => alert.onInform(context, 'PDF 파일로 변환하시겠습니까?', (){}),
                                      tooltip: 'PDF',
                                      iconSize: 38.sp,
                                      icon: SvgPicture.asset(
                                        'imgs/pdf.svg',
                                        placeholderBuilder: (BuildContext context) => Container(
                                            child: const CircularProgressIndicator()
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => alert.onInform(context, 'WAV 파일로 변환하시겠습니까?',
                                              /// 1. 권한 요청  -> 2. 디렉토리 열기 -> 3. 레코더 오픈
                                              () => requestPermission(context)
                                                  .then((value) => onInitRecords()
                                                    .then((value) => showRecorder(context, voca)
                                                  )
                                                )
                                              ),
                                      tooltip: 'WAV',
                                      iconSize: 38.sp,
                                      icon: SvgPicture.asset(
                                        'imgs/wav.svg',
                                        placeholderBuilder: (BuildContext context) => Container(
                                            child: const CircularProgressIndicator()
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => alert.onWarning(context,'${voca.title} 을(를) 삭제하시겠습니까?',() => deleteVoca(context, seq)),
                                      tooltip: 'DELETE',
                                      iconSize: 38.sp,
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