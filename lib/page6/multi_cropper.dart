import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/page1/home.dart';
import 'package:noonsaegim/setting/image_argument.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import '../ai_api/api_module.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../common/popup.dart';

class MultiCropper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    if(ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as ImageArgument;

      return Scaffold(
        drawer: new SideBar(),
        body: Stack(children: <Widget>[
          Container(
            color: Colors.black12,
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.89,// Your screen background color
            margin: EdgeInsets.only(top:AppBar().preferredSize.height + AppBar().preferredSize.height * 0.1),
          ),
          Center(
            child: Cropper(imagePaths: args.imagePath),
          ),
          TransparentAppBar(),
        ]),
      );
    } else {
      return Scaffold(
        drawer: new SideBar(),
        body: Stack(
            children: <Widget>[
              Center(
                child: Text('선택된 사진이 없습니다!'),
              ),
              TransparentAppBar(),
            ]
        ),
      );
    }
  }
}

class Cropper extends StatefulWidget {
  final List<String> imagePaths;

  ///test variable
  // final List<String> imagePaths = [
  //   'gallery/wheel.jpg',
  //   'gallery/library.jpg',
  //   'gallery/market.jpg',
  //   'gallery/pc.jpg',
  //   'gallery/room.png',
  //   'gallery/coex.jpg',
  // ];
  Cropper({required this.imagePaths});

  @override
  _CropperState createState() => _CropperState();
}

class _CropperState extends State<Cropper> {

  final _cropController = CropController();
  final _imageDataList = <Uint8List>[]; ///final은 future로 받을수 있뜸
  var _fileTypes = <String>[];
  var _croppedDataList = <Uint8List>[];
  var _loadingImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fileTypes = _getFileTypes(widget.imagePaths);
    });
    _loadAllImages().then((value){
      setState(() {
        _croppedDataList = _imageDataList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    /// 위젯의 이미지 캐시 삭제
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
  }

  List<String> _getFileTypes(List<String> filePaths) {
    return List.generate(filePaths.length, (idx) {
      String fileName = filePaths[idx].substring(filePaths[idx].lastIndexOf('/'));
      return fileName.split('.')[1];
    });
  }

  Future<void> _loadAllImages() async {
    setState(() {
      _loadingImage = true;
    });
    /// test code
    for (final path in widget.imagePaths) {
      _imageDataList.add(await _load(path));
    }
    // for (final path in widget.imagePaths) {
    //   _imageDataList.add(await _loadFile(path));
    // }
    setState(() {
      _loadingImage = false;
    });
  }

  /// test code
  Future<Uint8List> _load(String assetName) async {
    final assetData = await rootBundle.load(assetName);
    return assetData.buffer.asUint8List();
  }

  Future<Uint8List> _loadFile(String path) async {
    Uint8List bytes = await File(path).readAsBytes();
    return bytes;
  }

  Uint8List? _croppedData;
  var _isSumbnail = false;
  var _isCropping = false;
  var _isCircleUi = false;
  int _currentImage = 0;
  set currentImage(int value) {
    setState(() {
      _currentImage = value;
    });
    _cropController.image = _imageDataList[_currentImage];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Visibility(
              visible: !_loadingImage && !_isCropping,
              child: Column(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top) * 0.58,
                    child: Visibility(
                      visible: _croppedData == null,
                      child: Stack(
                        children: [
                          if (_imageDataList.isNotEmpty)
                            Crop(
                              controller: _cropController,
                              image: _imageDataList[_currentImage],
                              onCropped: (croppedData) {
                                setState(() {
                                  _croppedData = croppedData;
                                  _croppedDataList[_currentImage] = _croppedData!;
                                  if(_currentImage == _imageDataList.length - 1) {
                                    _isCropping = true;
                                  } else {
                                    _isCropping = false;
                                  }
                                });
                              },
                              withCircleUi: _isCircleUi,
                              initialSize: 0.5,
                              maskColor: _isSumbnail ? Colors.white : null,
                              cornerDotBuilder: (size, edgeAlignment) => _isSumbnail
                                  ? const SizedBox.shrink()
                                  : const DotControl(),
                            ),
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => _isSumbnail = true),
                              onTapUp: (_) => setState(() => _isSumbnail = false),
                              child: CircleAvatar(
                                backgroundColor:
                                _isSumbnail ? Colors.lightBlue.shade50 : Colors.lightBlue,
                                child: Center(
                                  child: Icon(Icons.crop_free_rounded, color: Colors.white, size: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      replacement: Center(
                        child: _croppedData == null
                            ? SizedBox.shrink()
                            : Image.memory(_croppedData!),
                      ),
                    ),
                  ),
                  if (!_isCropping)
                    Padding(
                      padding: EdgeInsets.only(top: 15.sp, bottom: 3.5.sp),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.crop_7_5),
                                onPressed: () {
                                  _isCircleUi = false;
                                  _cropController.aspectRatio = 16 / 4;
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.crop_16_9),
                                onPressed: () {
                                  _isCircleUi = false;
                                  _cropController.aspectRatio = 16 / 9;
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.crop_5_4),
                                onPressed: () {
                                  _isCircleUi = false;
                                  _cropController.aspectRatio = 4 / 3;
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.crop_square),
                                onPressed: () {
                                  _isCircleUi = false;
                                  _cropController
                                    ..withCircleUi = false
                                    ..aspectRatio = 1;
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.circle),
                                  onPressed: () {
                                    _isCircleUi = true;
                                    _cropController.withCircleUi = true;
                                  }
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 8.sp),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      primary: Colors.white,
                                      shadowColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isCropping = true;
                                      });
                                      _isCircleUi
                                          ? _cropController.cropCircle()
                                          : _cropController.crop();
                                    },
                                    child: Text(
                                      'Crop it',
                                      style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (_imageDataList.length >= 2)
                    Container(
                        height: (MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top) * 0.2,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 10.sp),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageDataList.length,
                            itemBuilder: (BuildContext context, int index)
                            => Card(
                              child: _buildSumbnail(_imageDataList[index]),
                            )
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
                              height:(MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.15,
                              child: IconButton(
                                  onPressed:() => Navigator.pushNamed(context, '/pick'),
                                  tooltip: 'retake',
                                  icon: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: SvgPicture.asset(
                                      'imgs/redo.svg',
                                      alignment: Alignment.centerRight,
                                      placeholderBuilder: (BuildContext context) => Container(
                                          child: const CircularProgressIndicator()
                                      ),
                                    ),
                                  )
                              ),
                            )
                        ),
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
                              height:(MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.15,
                              child:IconButton(
                                onPressed: () {
                                  print('-------submit-----');

                                  if(_croppedDataList.isNotEmpty && _croppedDataList.length == _imageDataList.length) {
                                    if(_fileTypes.isNotEmpty && _fileTypes.length == _croppedDataList.length) {
                                      if(mounted){
                                        if(_isCropping) {
                                          service.callApiProcess(context, _croppedDataList, _fileTypes);
                                        } else {
                                          alert.onInform(context, '나머지 사진을 그대로 제출하시겠습니까?', () => service.callApiProcess(context, _croppedDataList, _fileTypes));
                                        }
                                      }
                                    }
                                  }
                                },
                                tooltip: 'Submit',
                                icon: SvgPicture.asset(
                                  'imgs/redo.svg',
                                  alignment: Alignment.centerRight,
                                  placeholderBuilder: (BuildContext context) => Container(
                                      child: const CircularProgressIndicator()
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 30.sp),
                            child: Text(
                              '다시 선택',
                              style: TextStyle(
                                fontSize: 11.sp,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Spacer(),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 30.sp),
                            child: Text(
                              '제출 하기',
                              style: TextStyle(
                                fontSize: 11.sp,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                replacement: const CircularProgressIndicator(),
            ),
          ),
        ),
    );
  }

  dynamic _buildSumbnail(Uint8List data) {
    final index = _imageDataList.indexOf(data);
    return InkWell(
        onTap: () {
          _croppedData = null;
          currentImage = index;
        },
        child: Container(
          height: (MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top) * 0.2,
          decoration: BoxDecoration(
            border: index == _currentImage
                ? Border.all(
              width: 5,
              color: Colors.lightBlueAccent,
            )
                : null,
          ),
          child: Image.memory(
            data,
            fit: BoxFit.cover,
          ),
        ),
      );
  }
}