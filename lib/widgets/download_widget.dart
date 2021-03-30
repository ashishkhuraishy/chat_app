import 'dart:async';

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
    setState(
      () async => _controller =
          await Provider.of<DownloadConfig>(context, listen: false)
              .addTask(widget.url, widget.fileType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: !clicked
              ? IconButton(
                  icon: Icon(Icons.download_rounded),
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
    return StreamBuilder<DownloadTask>(
        stream: _controller.stream,
        builder: (context, snapshot) {
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
