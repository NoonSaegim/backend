import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noonsaegim/page3/single_cropper.dart';
import 'package:noonsaegim/setting/image_argument.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, required this.camera,}) : super(key: key);
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController Camcontroller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    Camcontroller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    initializeControllerFuture = Camcontroller.initialize();
  }

  @override
  void dispose() {
    // 위젯의 생명주기 종료시 컨트롤러 역시 해제시켜줍니다.
    Camcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      drawer: SideBar(),
      appBar: TransparentAppBar(),
      // 카메라 프리뷰를 보여주기 전에 컨트롤러 초기화를 기다려야 합니다. 컨트롤러 초기화가
      // 완료될 때까지 FutureBuilder를 사용하여 로딩 스피너를 보여주세요.
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(Camcontroller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Container(
        color:Colors.white,
        height: (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top) * 0.16,
        child : IconButton(
          onPressed: () async {
            //사진찍기
            try {
              await initializeControllerFuture
                  .then((value) async =>
              await Camcontroller.takePicture()
                  .then((XFile image) async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SingleCropper(),
                          settings: RouteSettings(
                            arguments: ImageArgument(imagePath: [image.path]),
                          )
                      )
                    );
                  }
                )
              );
            } catch (e) {
              print(e);
            }
          },
          tooltip: 'Camera',
          icon: SvgPicture.asset(
            'imgs/diaphragm.svg',
            placeholderBuilder: (BuildContext context) => Container(
                child: const CircularProgressIndicator()
            ),
          ),
        ),
        // Provide an onPressed callback.
        //    child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
