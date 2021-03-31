import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/download_config.dart';
import '../models/message.dart';
import '../screens/preview_page.dart';
import 'download_widget.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 1.3,
      padding: EdgeInsets.all(4),
      child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box(IMAGE_BOX).listenable(keys: [message.url]),
          builder: (context, box, widget) {
            String val = box.get(message.url, defaultValue: '');
            // log(val);
            if (val.isEmpty) {
              return DownloadWidgett(
                url: message.url,
                fileType: FileType.image,
              );
            }

            return ImageWidget(imgFile: File(val));
          }),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    @required this.imgFile,
  }) : super(key: key);

  final File imgFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            mediaFile: imgFile,
            fileType: FileType.image,
          ),
        ),
      ),
      child: Hero(
        tag: imgFile.path,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(
            imgFile,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
