import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import '../config/download_config.dart';

class DownloadWidgett extends StatefulWidget {
  const DownloadWidgett({
    Key key,
    @required this.url,
    @required this.fileType,
  }) : super(key: key);

  final String url;
  final FileType fileType;

  @override
  _DownloadWidgettState createState() => _DownloadWidgettState();
}

class _DownloadWidgettState extends State<DownloadWidgett> {
  bool clicked = false;
  StreamController<DownloadTask> _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<DownloadTask>();
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  _onDownloadPressed() async {
    setState(() => clicked = true);
    print('Start download for ${widget.url}');
    _controller = await Provider.of<DownloadConfig>(context, listen: false)
        .addTask(widget.url, widget.fileType);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.7),
          ),
          child: !clicked
              ? IconButton(
                  icon: Icon(
                    Icons.cloud_download_rounded,
                    size: 28,
                  ),
                  onPressed: _onDownloadPressed,
                )
              : DownloadProgress(controller: _controller),
        ),
      ),
    );
  }
}

class DownloadProgress extends StatelessWidget {
  const DownloadProgress({
    Key key,
    @required StreamController<DownloadTask> controller,
  })  : _controller = controller,
        super(key: key);

  final StreamController<DownloadTask> _controller;

  @override
  Widget build(BuildContext context) {
    // if (_controller == null) {
    //   return CircularProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    //   );
    // }

    return StreamBuilder<DownloadTask>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          log(snapshot.data.toString());

          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            );
          }

          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            value: snapshot.data.progress / 100,
          );
        });
  }
}
