import 'package:flutter/material.dart';
import 'package:noonsaegim/common/popup.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../vo/word.dart';
import 'package:sizer/sizer.dart';
import '../tts/dynamic_speaker.dart';
import '../common/dialog.dart';

class MultiImagesProcess extends StatefulWidget {
  const MultiImagesProcess({Key? key}) : super(key: key);

  @override
  _MultiImagesProcessState createState() => _MultiImagesProcessState();
}

class _MultiImagesProcessState extends State<MultiImagesProcess> {

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
    Future.delayed(Duration.zero).then((value) =>
        setState((){
          _dataList = [...a,...b, ...c,...d,...e];
        })
    );
  }

  List<DataColumn> _getColumns() {
    List<DataColumn> dataColumn = [];
    for(var i in _columns) {
      dataColumn.add(DataColumn(
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
          cells.add(DataCell(Text('${value.seq!+1}', style: TextStyle(color: Colors.black54,fontSize: 13.sp))));
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
              selected: value.isSelected!,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar1(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.sp),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index)
                      => Card(
                          child: Image.asset('imgs/main.jpg')
                      ),
                    )
                ),
              ],
            ),
            height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top) * 0.30,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10),
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.10,
            child: Speaker(dataList: [..._dataList],),
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.48,
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
            padding: EdgeInsets.only(right: 20, left: 20),
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.11,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
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
                    onPressed: () {
                      if(_dataList.where((e) => e.isSelected!).toList().isEmpty) {
                        alert.onWarning(context, '단어를 1개 이상 선택해주세요!', (){});
                        return;
                      }
                      onSaveButtonPressed(context, _dataList);
                    },
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

