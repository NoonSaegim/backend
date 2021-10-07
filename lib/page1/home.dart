import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../common/noon_appbar.dart';
import '../common/drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import '../page2/open_camera.dart';
import 'package:camera/camera.dart';
import 'package:sizer/sizer.dart';


Future<void> openCamera(BuildContext context) async {

  WidgetsFlutterBinding.ensureInitialized();

  // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
  final cameras = await availableCameras();
  // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
  final firstCamera = cameras.first;

  Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new SideBar(),
      appBar: new AppBar1(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcOver),
              child: Container(
                //color: Colors.black12,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                height: 220.0.sp,
                child: Image.asset('imgs/main.jpg'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0.sp),
              alignment: Alignment.center,
              child: GestureDetector(
                behavior:HitTestBehavior.translucent,
                onTap: () => Navigator.pushNamed(context, '/pick'),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.34,
                  height: 64.0.sp,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexColor("#0668C1").withOpacity(0.66),
                        HexColor("#11E2FF").withOpacity(0.51),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '사진 가져오기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.2.sp,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 6.8.sp, left: 6.8.sp),
              margin: EdgeInsets.only(top: 20.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    behavior:HitTestBehavior.translucent,
                    onTap: () => Navigator.pushNamed(context, '/recently'),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: 64.0.sp,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HexColor("#0668C1").withOpacity(0.66),
                            HexColor("#11E2FF").withOpacity(0.51),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '최근 조회한 단어',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.2.sp,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior:HitTestBehavior.translucent,
                    onTap: () => Navigator.pushNamed(context, '/mynote'),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: 64.0.sp,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HexColor("#0668C1").withOpacity(0.66),
                            HexColor("#11E2FF").withOpacity(0.51),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '나의 단어장',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.2.sp,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 83.0.sp,
                  width: MediaQuery.of(context).size.width,
                  //padding: EdgeInsets.only(bottom: ),
                  child: IconButton(
                    onPressed: () => openCamera(context),
                    tooltip: 'camera',
                    icon: SvgPicture.asset(
                      'imgs/diaphragm.svg',
                      placeholderBuilder: (BuildContext context) => Container(
                          child: const CircularProgressIndicator()
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }
}
