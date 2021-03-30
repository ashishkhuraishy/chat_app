import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/download_config.dart';
import '../models/message.dart';
import '../models/video/video.dart';
import '../screens/preview_page.dart';
import 'download_widget.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.all(4),
      child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box(VIDEO_BOX).listenable(keys: [message.url]),
          builder: (context, box, widget) {
            Video val = box.get(message.url,
                defaultValue: Video(thumbNailPath: '', filePath: ''));
            // log(val.toString());
            if (val.thumbNailPath.isEmpty || val.filePath.isEmpty) {
              return DownloadWidgett(
                url: message.url,
                fileType: FileType.video,
              );
            }

            return VideoWidget(video: val);
          }),
    );
  }
}

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            mediaFile: File(video.filePath),
            fileType: FileType.video,
          ),
        ),
      ),
      child: Hero(
        tag: video.filePath,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(video.thumbNailPath),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.7),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
