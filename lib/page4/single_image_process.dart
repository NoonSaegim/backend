import 'package:flutter/material.dart';
import 'package:noonsaegim/setting/word_list_argument.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import '../vo/word.dart';
import '../tts/dynamic_speaker.dart';
import '../common/dialog.dart';
import '../common/popup.dart';

class SingleImageProcess extends StatefulWidget {
  const SingleImageProcess({Key? key}) : super(key: key);

  @override
  _SingleImageProcessState createState() => _SingleImageProcessState();
}

class _SingleImageProcessState extends State<SingleImageProcess> {
  final List<String> _columns = ['No', '영어 단어', '의미'];

  @override
  void dispose() {
    super.dispose();
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
  }

  List<DataColumn> _getColumns(List<Word> _dataList) {
    List<DataColumn> dataColumn = [];
    if(_dataList != null && _dataList.isNotEmpty) {
      for(var i in _columns) {
        dataColumn.add(DataColumn(
            label: Text(
                i, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0.sp,
            )
            )
        ));
      }
    }
    return dataColumn;
  }

  List<DataRow> _getRows(List<Word> _dataList) {
    List<DataRow> dataRow = [];
    if(_dataList != null && _dataList.isNotEmpty) {
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
    }
    return dataRow;
  }

  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as WordList;
      var _dataList = args.dataList;
      final _image = args.imageList[0];

      return Scaffold(
          backgroundColor: Colors.white,
          drawer: SideBar(),
          appBar: AppBar1(),
          body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8.5.sp,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                          child: Image.memory(_image),
                          clipBehavior: Clip.antiAlias
                      ),
                    ],
                  ),
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
                  child: Speaker(dataList: [..._dataList],),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top) * 0.43,
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
                      columns: _getColumns(_dataList),
                      rows: _getRows(_dataList),
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
                          /*-> 뒤로 가기*/
                            onPressed: () => Navigator.of(context).pop(),
                            //전 화면이랑 이어지지 않아서 아직 뒤로가기 안됨..!!!
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
                                alert.onWarning(context, '단어를 1개 이상 선택해주세요!', () { });
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
                      ]
                  ),
                )
              ]
          )
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        drawer: SideBar(),
        appBar: AppBar1(),
        body: Center(
          child: Text('No Data Received...'),
        ),
      );
    }
  }
}
