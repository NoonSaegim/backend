import 'package:flutter/material.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import '../vo/word.dart';
import '../common/dialog.dart';
import '../common/popup.dart';
import '../tts/dynamic_speaker.dart';

class SingleImageProcess extends StatefulWidget {
  const SingleImageProcess({Key? key}) : super(key: key);

  @override
  _SingleImageProcessState createState() => _SingleImageProcessState();
}

class _SingleImageProcessState extends State<SingleImageProcess> {

  final List<String> _columns = ['No', '영어 단어', '의미'];

  List<Word> a = List.generate(3, (index) =>
  new Word(seq: index, word: 'apple', meaning: '사과', isSelected: false),
  );
  List<Word> b = List.generate(3, (index) =>
  new Word(seq: index + 3, word: 'stock', meaning: '주식', isSelected: false),
  );
  List<Word> c = List.generate(3, (index) =>
  new Word(seq: index + 6, word: 'reduce', meaning: '줄이다', isSelected: false),
  );
  List<Word> d = List.generate(3, (index) =>
  new Word(seq: index + 9, word: 'multiple', meaning: '다수의', isSelected: false),
  );
  List<Word> e = List.generate(3, (index) =>
  new Word(seq: index + 12, word: 'embedded', meaning: '내장된', isSelected: false),
  );

  List<Word> _dataList = [];
  @override
  initState() {
    super.initState();
    _dataList = [...a,...b, ...c,...d,...e];
  }

  List<DataColumn> _getColumns() {
    List<DataColumn> dataColumn = [];
    for(var i in _columns) {
      dataColumn.add(
          DataColumn(
            label: Text(
              i, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0.sp,
            )
          )
        )
      );
    }
    return dataColumn;
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];
    for (var value in _dataList) {
      List<DataCell> cells = [];
      for(var j in _columns) {
        if(j == 'No') {
          cells.add(DataCell(Text('${value.seq+1}', style: TextStyle(color: Colors.black54,fontSize: 13.sp))));
        } else if (j == '영어 단어'){
          cells.add(DataCell(
              Text(value.word,
                  style: TextStyle(color: Colors.black54,fontSize: 13.sp)
              )
            )
          );
        } else {
          cells.add(DataCell(
              Text(value.meaning,
                  style: TextStyle(color: Colors.black54,fontSize: 13.sp)
              )
          )
          );
        }
      }
      dataRow.add(
          DataRow(
              key:ValueKey(value.seq),
              selected: value.isSelected,
              onSelectChanged: (bool? selected){
                if(selected != null) {
                  setState(() {
                    value.isSelected = selected;
                  });
                }
              },
              cells: cells
          )
      );
    }
    return dataRow;
  }

  void _checkDataAndCallDBProcess() => _dataList.where((e) => e.isSelected).toList().isNotEmpty
      ? onSaveButtonPressed(context, _dataList) : alert.onWarning(context, '선택된 단어가 없습니다!', (){});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          drawer: new SideBar(),
          appBar: new AppBar1(),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.sp,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                        child: Image.asset('imgs/main.jpg'),
                        clipBehavior: Clip.antiAlias
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.33,
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 8.sp),
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.10,
                child: Speaker(),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.42,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    onSelectAll: (bool? isSelected) {
                      if (isSelected != null) {
                        setState(() {
                          _dataList.forEach((element) {element.isSelected = isSelected;});
                        });
                      }
                    },
                    showCheckboxColumn: true,
                    columns: _getColumns(),
                    rows: _getRows(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.11,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(), //아직 화면이 안이어져서 뒤로가기 안됨.
                        tooltip: 'Back',
                        iconSize: 38.sp,
                        icon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: SvgPicture.asset(
                            'imgs/arrow.svg',
                            placeholderBuilder: (BuildContext context) => Container(
                                child: const CircularProgressIndicator()
                            ),
                          ),
                        )
                    ),
                    IconButton(
                        onPressed: () => _checkDataAndCallDBProcess(),
                        tooltip: 'Save',
                        iconSize: 38.sp,
                        icon: SvgPicture.asset(
                          'imgs/download.svg',
                          placeholderBuilder: (BuildContext context) => Container(
                              child: const CircularProgressIndicator()
                          ),
                          height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) * 0.11,
                        )
                    )
                  ],
                ),
              )
            ],
          )
      );
  }
}
