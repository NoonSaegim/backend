import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  // CameraController와 Future를 저장하기 위해 두 개의 변수를 state 클래스에 정의
  late CameraController Camcontroller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라의 현재 출력물을 보여주기 위해
    // CameraController를 생성합니다.
    Camcontroller = CameraController(
      // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
      widget.camera,
      // 적용할 해상도를 지정합니다.
      ResolutionPreset.medium,
    );

    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
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
            // If the Future is complete, display the preview.
            return CameraPreview(Camcontroller);
          } else {
            // Otherwise, display a loading indicator.
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
              await initializeControllerFuture;
              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await Camcontroller.takePicture();
              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
          tooltip: 'Audio',
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

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar2(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
       body: Container(
           child : Image.file(File(imagePath))
       ),
    );

  }
}