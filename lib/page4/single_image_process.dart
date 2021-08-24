import 'package:flutter/material.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class SingleImageProcess extends StatefulWidget {
  const SingleImageProcess({Key? key}) : super(key: key);

  @override
  _SingleImageProcessState createState() => _SingleImageProcessState();
}

class _SingleImageProcessState extends State<SingleImageProcess> {
  final List<String> _columns = ['No', '영어 단어', '의미'];

  List<DataColumn> _getColumns() {
    List<DataColumn> dataColumn = [];
    for(var i in _columns) {
      dataColumn.add(DataColumn(label: Text(i, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))));
    }
    return dataColumn;
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];
    for(var i=0; i < 15; i++) {
      List<DataCell> cells = [];
      for(var j in _columns) {
        if(j == 'No') {
          cells.add(DataCell(Text('${i+1}', style: TextStyle(color: Colors.black54))));
        } else {
          cells.add(DataCell(Text('test', style: TextStyle(color: Colors.black54))));
        }

      }
      dataRow.add(DataRow(
          key:ValueKey(i),
          selected: false,
          onSelectChanged: (bool? value) {
            print(value);
            setState(() {

            });
          },
          cells: cells
      ));
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
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                      child: Image.asset('imgs/main.JPG')
                  ),
                ],
              ),
              height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top) * 0.40,
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10),
              height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top) * 0.09,
              child: IconButton(
                onPressed: () => print('request audio api'),
                tooltip: 'Audio',
                icon: SvgPicture.asset(
                  'imgs/audio.svg',
                  placeholderBuilder: (BuildContext context) => Container(
                      child: const CircularProgressIndicator()
                  ),
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top) * 0.40,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  onSelectAll: (bool? isSelected) {
                    if (isSelected != null) {
                      // _items.forEach((item) {
                      //   item.isSelected = isSelected;
                      // });

                      setState(() {});
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
                      onPressed: () => print('나의 단어장에 저장'),
                      tooltip: 'Save',
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
