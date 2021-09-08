import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noonsaegim/cache/vo/cache_data.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import '../cache/cache_module.dart';
import 'package:sizer/sizer.dart';

class Recently extends StatefulWidget {
  @override
  _RecentlyState createState() => _RecentlyState();
}

class _RecentlyState extends State<Recently> {
  final List<String> _columns = ['날짜', '영어단어', '의미'];
  List<DataRow> _rowList = [];

  @override
  void initState() {
    print('initState');
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getCacheList().then((List<CacheData?> cacheList) {
        setState(() {
          _rowList = _getRows(cacheList).reversed.toList();
          print(_rowList);
        });
      });
    });
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

  List<DataRow> _getRows(List<CacheData?> cacheList) {
    List<DataRow> dataRow = [];
    cacheList.forEach((e) {
      if(e != null) {
        for(var i in e.wordList) {
          List<DataCell> cells = [];
          cells.add(DataCell(
              Text(
                new DateFormat('yyyy-MM-dd').format(e.date),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.5.sp,
                ),
                textAlign: TextAlign.center,
              )
          ));
          cells.add(DataCell(
              Text(
                i['word'].toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.5.sp,
                ),
                textAlign: TextAlign.center,
              )
          ));
          cells.add(DataCell(
              Text(
                i['meaning'].toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.5.sp,
                ),
                textAlign: TextAlign.center,
              )
          ));
          dataRow.add(DataRow(cells: cells));
        }
      }
    });
    return dataRow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar1(),
      body: Row(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 22.sp, bottom: 11.sp, left: 11.sp),
                      child: FutureBuilder(
                          future: fetchCacheableDays(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                              final _cacheable = snapshot.data as int;
                              return Text(
                                  "※ 최근 $_cacheable일 동안 조회된 단어만 확인하실 수 있습니다.",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0.sp,
                                  )
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.lightBlue),
                          columns: _getColumns(),
                          rows: _rowList,
                        )
                    ),
                  ],
                ),
              )
          )
        ]
      )
    );
  }
}

