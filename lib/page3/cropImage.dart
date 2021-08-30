import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../common/noon_appbar.dart';


class showCropImage extends StatefulWidget {
  var imagePath;

  showCropImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _showCropImageState createState() => _showCropImageState();
}

class _showCropImageState extends State<showCropImage> {
  @override
  Widget build(BuildContext context) {
    Uint8List _image=  widget.imagePath;
    Image image = Image.memory(_image,
                                width : 1000,
                                height : 1000);

    return Scaffold(
      appBar: new AppBar2(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
          child : image
      ),
    );
  }
}

