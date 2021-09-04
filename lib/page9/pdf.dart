import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as provider;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'package:pdf/widgets.dart' as pw;
import '../database/dto/voca.dart';

Future<void> createPdf(Voca voca) async {

  final arial = await rootBundle.load("font/arial.ttf");
  final meaning = Font.ttf(arial);
  final header = await rootBundle.load("font/arial-bold.ttf");
  final bold = Font.ttf(header);
  final italic = await rootBundle.load("font/arial-italic.ttf");
  final title = Font.ttf(italic);

  final themeData = pw.ThemeData(
    tableHeader: pw.TextStyle(font: bold, fontSize: 30),
    tableCell: pw.TextStyle(font: meaning, fontSize: 20),
    header0: pw.TextStyle(font: title, fontSize: 50),
  );

  final pdf = pw.Document(
      title: voca.title,
      producer: '눈새김',
      theme: themeData,
      deflate: zlib.encode
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      margin: pw.EdgeInsets.all(40),
      build: (pw.Context context) {
        return <pw.Widget> [
          pw.Header(
            level: 0,
            child: pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 25),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget> [
                    pw.Text(voca.title, textScaleFactor: 5, textAlign: pw.TextAlign.center),
                  ]
              )
            )
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Table(
              children: [
                pw.TableRow(
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(12.0),
                        child:  pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text('단어', style: pw.TextStyle(font: bold, fontSize: 30)),
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text('의미',style: pw.TextStyle(font: bold, fontSize: 30)),
                                  ]
                              ),
                            ]
                        )
                      )
                    ]
                ),
                for(var i in voca.wordList)
                  pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5.5),
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(i['word'].toString(), style: pw.TextStyle(font: meaning, fontSize: 20)),
                                      //pw.Divider(thickness: 1),
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [

                                      pw.Text(
                                          i['meaning'].toString(),
                                          style: pw.TextStyle(font: meaning, fontSize: 20)
                                      ),
                                      //pw.Divider(thickness: 1),
                                    ]
                                ),
                              ]
                          )
                        ),
                      ]
                  )
              ],
            ),
          )
        ];
      }
    )
  );

  if(io.Platform.isAndroid) {
    bool status = await Permission.storage.isGranted;
    if (!status) await Permission.storage.request();
  }

  final externalDir = await provider.getExternalStorageDirectory();
  final path = '${externalDir!.path}/${voca.title}_${voca.date}.pdf';
  final List<int> data = await pdf.save();

  await io.File(path).writeAsBytes(data)
      .then((File file) => OpenFile.open(path));
}
