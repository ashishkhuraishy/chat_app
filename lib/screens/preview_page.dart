import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class PreviewPage extends StatelessWidget {
  final File imgFile;

  const PreviewPage({
    Key key,
    @required this.imgFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User 1"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: PhotoView(
          imageProvider: FileImage(imgFile),
          heroAttributes: PhotoViewHeroAttributes(
            tag: imgFile.path,
          ),
        ),
      ),
    );
  }
}
