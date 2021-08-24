import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';
import '../page5/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class Cropper extends StatefulWidget {

  @override
  _CropperState createState() => _CropperState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CropperState extends State<Cropper> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new SideBar(),
      body: Stack(children: <Widget>[
        Container(
          color: Colors.black12,

          // height: (MediaQuery.of(context).size.height -
          //     AppBar().preferredSize.height -
          //     MediaQuery.of(context).padding.top),// Your screen background color
          // margin: EdgeInsets.only(top:AppBar().preferredSize.height +  MediaQuery.of(context).padding.top),
        ),
        Center(
          child: imageFile != null ? Image.file(imageFile!) : Container(),
        ),
        TransparentAppBar(),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          if(state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add, color: Colors.lightBlue,);
    else if (state == AppState.picked)
      return Icon(Icons.crop, color: Colors.lightBlue,);
    else if (state == AppState.cropped)
      return Icon(Icons.clear, color: Colors.lightBlue,);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}