import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import '../vo/wordData.dart';
import 'package:sizer/sizer.dart';

class Recently extends StatefulWidget {
  @override
  _RecentlyState createState() => _RecentlyState();
}

class _RecentlyState extends State<Recently> {
  int _cacheable = 3;
  final List<String> _columns = ['날짜', '영어 단어', '의미'];

  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(
      gutterSize: 30,
    );
  }

  List<DataColumn> _getColumns() {
    List<DataColumn> dataColumn = [];
    for(var i in _columns) {
      if(i == '날짜') {
        dataColumn.add(
            DataColumn(
              label: Text(
                  i, style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ), textAlign: TextAlign.center,
                  ),
                  tooltip: i,
                  //onSort: _dataColumnSort
            )
        );
      } else {
        dataColumn.add(
            DataColumn(
                label: Text(
                    i, style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ), textAlign: TextAlign.center,
                    ), tooltip: i
            )
        );
      }
    }
    return dataColumn;
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];

    Map<String, List<String>> dummyData = new Map();
    List<String> first = ['2021-08-01', 'apple', '사과'];
    List<String> second = ['2021-08-02', 'cherry', '체리'];
    List<String> third = ['2021-08-03', 'mango', '망고'];
    dummyData['날짜'] = first;
    dummyData['영어 단어'] = second;
    dummyData['의미'] = third;

    for(var i in _columns) {
      List<DataCell> cells = [];
      for(var j=0; j < dummyData[i]!.length; j++) {
        var dataCells = dummyData[i];
        cells.add(
            DataCell(
                Text(
                    dataCells![j],
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12.5.sp,
                    ),
                    textAlign: TextAlign.center,
                )
            )
        );
      }
      dataRow.add(DataRow(cells: cells));
    }
    return dataRow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar2(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(

            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 22.sp, bottom: 11.sp, left: 11.sp),
                child: Text(
                    "※ 최근 $_cacheable일 동안 조회된 단어만 확인하실 수 있습니다.",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 11.0.sp,
                    )
                ),
              ),
              Container(
                child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.lightBlue),
                    columns: _getColumns(),
                    rows: _getRows()
                ),
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
      ),
    );
  }
}

