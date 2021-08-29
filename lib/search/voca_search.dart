import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import '../database/dao/voca.dart';
import 'package:sizer/sizer.dart';
import '../setting/note_argument.dart';
import '../database/hive_module.dart';
// Widget fetchSearchPage() {
//
// }

Future<SearchPage<Voca>> vocaSearch(BuildContext context) async {

  return await fetchVocaList()
      .then((List<Voca> vocalList) =>
        SearchPage<Voca>(
          suggestion: Center(
            child: Text(
              '제목, 날짜, 단어로 검색해보세요!',
              style: TextStyle(
                fontSize: 16.0.sp,
                color: Colors.black54,
              ),
            ),
          ),
          failure: Center(
            child:Text(
              '검색 결과가 없어요 :(',
              style: TextStyle(
                fontSize: 16.0.sp,
                color: Colors.black54,
              ),
            ),
          ),
          items: vocalList,
          builder: (voca) => ListTile(
            title: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/mynote',
                    arguments: NoteArgument(seq: vocalList.indexOf(voca)));
              },
              child: Text(
                voca.title,
                style: TextStyle(
                  fontSize: 15.0.sp,
                  color: Colors.black54,
                ),
              ),
            ),
            subtitle: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/mynote',
                    arguments: NoteArgument(seq: vocalList.indexOf(voca)));
              },
              child: Text(
                new DateFormat('yyyy-MM-dd').format(voca.date),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: Colors.black54,
                ),
              ),
            ),
            trailing: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/mynote',
                    arguments: NoteArgument(seq: vocalList.indexOf(voca)));
              },
              child: Text(
                convertToString(voca.wordList),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.black54,
                ),
              ),
            )
          ),
          filter: (voca) => [
            voca.title,
            new DateFormat('yyyy-MM-dd').format(voca.date),
            convertToString(voca.wordList),
          ],
        )
  );
}

String convertToString(List<Map<String, String>> wordList) {
  Map<String, String> merge = new Map();
  for (var value in wordList) {
    value.removeWhere((key, value) => key == 'meaning');
    merge.addAll(value);
  }
  return merge.values.map((e) => e).join(', ');
}