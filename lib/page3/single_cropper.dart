import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noonsaegim/setting/image_argument.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../common/popup.dart';
import 'package:sizer/sizer.dart';
import '../ai_api/api_module.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SingleCropper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   /* if(ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as ImageArgument;*/

      return Scaffold(
        drawer: new SideBar(),
        body: Stack(children: <Widget>[
          Container(
            color: Colors.black12,
            height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top) * 0.8,// Your screen background color
            margin: EdgeInsets.only(top:AppBar().preferredSize.height +  MediaQuery.of(context).padding.top),
          ),
          Center(
            child: Cropper(/*imagePath: args.imagePath[0]*/),
          ),
          TransparentAppBar(),
        ]),
      );
   /* } else {
      return alert.onError(context, '사진이 찍히지 않았습니다!');
    }*/
  }
}

class Cropper extends StatefulWidget {
  final String imagePath = 'gallery/pc.jpg';
  //Cropper({required this.imagePath});

  @override
  _CropperState createState() => _CropperState();
}

class _CropperState extends State<Cropper> {
  final _cropController = CropController();
  var _imageData;
  var _loadingImage;
  var _fileType;

  @override
  void initState() {
    super.initState();
    //print('image path: ${widget.imagePath}');
    setState(() {
      _loadingImage = true;
      _fileType = _getFileType(widget.imagePath);
    });
    Future.delayed(Duration.zero, () {
        _setImagedata();
    });
    setState(() {
      _loadingImage = false;
    });
  }
  String _getFileType(String filePath) {
    String fileName = filePath.substring(filePath.lastIndexOf('/'));
    return fileName.split('.')[1];
  }

  Future<void> _setImagedata() async {

    await _load().then((Uint8List data) {
      setState(() {
        _imageData = data;
      });
    });
    // await File(widget.imagePath).readAsBytes()
    //     .then((List<int> bytes) =>
    //       setState((){
    //         _imageData = Uint8List.fromList(bytes);
    //       })
    //     );
  }

  Future<Uint8List> _load() async {
    final assetData = await rootBundle.load(widget.imagePath);
    return assetData.buffer.asUint8List();
  }

  var _isSumbnail = false;
  var _isCropping = false;
  var _isCircleUi = false;
  Uint8List? _croppedData;

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
                  children: <Widget>[
                    if (_croppedData == null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.5.sp),
                        child: Column(
                          children: [
                            Container(
                              height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top) * 0.75,
                              child: Visibility(
                                visible: _croppedData == null,
                                child: Stack(
                                  children: [
                                    if(_imageData != null)
                                    Crop(
                                      controller: _cropController,
                                      image: _imageData!,
                                      onCropped: (croppedData) async {
                                        setState(() {
                                          _croppedData = croppedData;
                                          _isCropping = true;
                                        });
                                        if(_croppedData != null) {
                                          if(_isCropping && _fileType != null) {
                                            await callApiProcess(context, [_croppedData!], [_fileType]);
                                          }
                                        }
                                      },
                                      withCircleUi: _isCircleUi,
                                      initialSize: 0.5,
                                      maskColor: _isSumbnail ? Colors.white : null,
                                      cornerDotBuilder: (size, edgeAlignment) => _isSumbnail
                                          ? const SizedBox.shrink()
                                          : const DotControl(),
                                    ),
                                    Positioned(
                                      right: 16.sp,
                                      bottom: 16.sp,
                                      child: GestureDetector(
                                        onTapDown: (_) => setState(() => _isSumbnail = true),
                                        onTapUp: (_) => setState(() => _isSumbnail = false),
                                        child: CircleAvatar(
                                          backgroundColor:
                                          _isSumbnail ? Colors.lightBlue.shade50 : Colors.lightBlue,
                                          child: Center(
                                            child: Icon(Icons.crop_free_rounded, color: Colors.white, size: 20.sp,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15.sp,),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8.0.sp,),
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
                                  onPressed: () => print('다시 찍기 to camera'),
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
                                onPressed: (){
                                  setState(() {
                                    _isCropping = true;
                                  });
                                  _isCircleUi
                                      ? _cropController.cropCircle()
                                      : _cropController.crop();
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
                              '다시 찍기',
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
              )
          ),
        ),
    );
  }
}