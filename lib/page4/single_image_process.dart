import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import '../vo/word.dart';
import '../common/popup.dart';
import '../tts/dynamic_speaker.dart';

class SingleImageProcess extends StatefulWidget {
  const SingleImageProcess({Key? key}) : super(key: key);

  @override
  _SingleImageProcessState createState() => _SingleImageProcessState();
}

class _SingleImageProcessState extends State<SingleImageProcess> {

  final List<String> _columns = ['No', '영어 단어', '의미'];
  List<Word> _dataList = List.generate(15, (index) =>
    new Word(seq: index, word: 'embedded', meaning: '내장된', isSelected: false),
  );


  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                margin: EdgeInsets.only(right: 10),
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
                padding: EdgeInsets.only(right: 20, left: 20),
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) * 0.11,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: () => print('go back'),
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
                        onPressed: () => alert.onInform(context, '나의 단어장에 저장하시겠습니까?', () { }),
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
