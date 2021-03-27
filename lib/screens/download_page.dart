import 'dart:async';
import 'dart:developer';

import 'package:chat_app/config/download_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String videoUrl =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  StreamController<DownloadTask> _controller;

  DownloadConfig _downloadConfig;

  @override
  void initState() {
    super.initState();
    _controller = StreamController();
    _downloadConfig = DownloadConfig();
  }

  @override
  void dispose() {
    _downloadConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              var _controller =
                  await _downloadConfig.addTask(videoUrl, 'video');

              setState(() {
                this._controller = _controller;
              });
            },
            child: Text('Download'),
          ),
          Container(
            child: StreamBuilder<DownloadTask>(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  log(snapshot.data.toString());
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      value: snapshot.data.progress / 100,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
