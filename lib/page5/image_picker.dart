import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonsaegim/page3/single_cropper.dart';
import 'package:noonsaegim/page6/multi_cropper.dart';
import 'package:noonsaegim/setting/image_argument.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: ImagePick(title: 'Gallery'));
  }
}

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key, required this.title}) : super(key: key);
  final String? title;
  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  List<XFile>? _imageFileList;
  var testList; ///test variable
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }
  dynamic _pickImageError;
  String? _retrieveDataError;
  bool _isDone = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if(isMultiImage) {
        try {
          final pickedFileList = await _picker.pickMultiImage();
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
    } else {
        try {
            final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
    }
  }

  /// test variable
  /*final List<String> imagePaths = [
    'gallery/wheel.jpg',
    'gallery/library.jpg',
    'gallery/market.jpg',
    'gallery/pc.jpg',
    'gallery/room.png',
    'gallery/coex.jpg',
  ];*/

  /*@override
  void initState() {
    // TODO: test code
    super.initState();
    Future.delayed(Duration.zero, () async {
        await setXFileList().then((List<Uint8List> list) {
          setState(() {
            testList = list;
          });
        });
    });
  }*/
  /// test code
  /*Future<List<Uint8List>> setXFileList() async {
    List<Uint8List> dummyList = [];
    for(var path in imagePaths) {
      dummyList.add(await getImageFileToByteData(path));
    }
    return dummyList;
  }*/
  /// test code
  Future<Uint8List> getImageFileToByteData(String path) async {
    final byteData = await rootBundle.load('$path');
    return byteData.buffer.asUint8List();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
    //if (testList != null) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return Semantics(
                label: '선택한 사진',
                //child: Image.memory(testList[index]),
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Image.file(File(_imageFileList![index].path)),
              );
            },
            itemCount: testList.length,
          ),
          label: '선택한 사진');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        style: TextStyle(fontSize: 15.0.sp, color: Colors.black45),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        '선택한 사진 없음.',
        style: TextStyle(fontSize: 15.0.sp, color: Colors.black45),
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _handlePreview() {

    Future.delayed(Duration.zero, () {
      setState(() {
        _isDone = true;
      });
    });
    return _previewImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      body: Stack(children: <Widget>[
        Container(
        color: Colors.white,// Your screen background color
      )
      ,Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? FutureBuilder<void>(
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              /*if(snapshot.connectionState != null) {
                return _handlePreview(); */ ///test code

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Text(
                    '선택한 사진 없음',
                    style: TextStyle(fontSize: 15.0.sp, color: Colors.black45),
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.done:
                  return _handlePreview();
                default:
                  if (snapshot.hasError) {
                    return Text(
                      '사진 오류: ${snapshot.error}}',
                      style: TextStyle(fontSize: 15.0.sp, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      '선택한 사진 없음.',
                      style: TextStyle(fontSize: 15.0.sp, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  }
                }
              /*} else {
                return CircularProgressIndicator();
              }*////test code
            },
        ) : _handlePreview(),
      ),
      TransparentAppBar()
      ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image picker from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'single',
              tooltip: 'Pick a Image from gallery',
              child: const Icon(Icons.photo,),
              backgroundColor: Colors.lightBlue,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14.5.sp),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                );
              },
              heroTag: 'multi',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(Icons.photo_library),
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
          if(_isDone)
            Padding(
              padding: EdgeInsets.only(top: 14.5.sp),
              child: FloatingActionButton(
                onPressed: () async {
                  ///test code
                  //final List<String> _imagePathList = imagePaths;
                  final List<String> _imagePathList
                    = List.generate(_imageFileList?.length as int,
                            (index) => _imageFileList![index].path);

                  if(_imagePathList.isNotEmpty) {
                    if(_imagePathList.length == 1) {
                      await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SingleCropper(),
                              settings: RouteSettings(
                                arguments: ImageArgument(imagePath: _imagePathList),
                              )
                          )
                      );
                    } else if(_imagePathList.length >= 2) {
                      await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => MultiCropper(),
                              settings: RouteSettings(
                                arguments: ImageArgument(imagePath: _imagePathList),
                              )
                          )
                      );
                    }
                  }
                },
                heroTag: 'submit',
                tooltip: 'Submit',
                child: SvgPicture.asset(
                  'imgs/right-arrow.svg',
                  placeholderBuilder: (BuildContext context) => Container(
                      child: const CircularProgressIndicator()
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);


