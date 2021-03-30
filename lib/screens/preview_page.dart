import 'dart:io';

import 'package:chat_app/config/download_config.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class PreviewPage extends StatelessWidget {
  final File mediaFile;
  final FileType fileType;

  const PreviewPage({
    Key key,
    @required this.mediaFile,
    @required this.fileType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("User 1"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      extendBodyBehindAppBar: true,
      body: fileType == FileType.image
          ? ImageView(imgFile: mediaFile)
          : VideoView(videoFile: mediaFile),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({
    Key key,
    @required this.imgFile,
  }) : super(key: key);

  final File imgFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: FileImage(imgFile),
        heroAttributes: PhotoViewHeroAttributes(
          tag: imgFile.path,
        ),
      ),
    );
  }
}

class VideoView extends StatefulWidget {
  final File videoFile;

  const VideoView({
    Key key,
    @required this.videoFile,
  }) : super(key: key);
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initialisePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _initialisePlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _chewieController != null &&
              _chewieController.videoPlayerController.value.isInitialized
          ? Chewie(
              controller: _chewieController,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
