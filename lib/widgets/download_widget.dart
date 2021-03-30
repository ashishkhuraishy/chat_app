import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import '../config/download_config.dart';
import '../providers/task_info_provider.dart';

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

  String taskID = "";

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
    var taskID = await Provider.of<DownloadConfig>(context, listen: false)
        .addTask(widget.url, widget.fileType);
    log('Task ID $taskID');
    setState(() {
      this.taskID = taskID;
    });
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
              : DownloadProgress(
                  key: UniqueKey(),
                  taskID: taskID,
                ),
        ),
      ),
    );
  }
}

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({
    Key key,
    @required this.taskID,
  }) : super(key: key);

  final String taskID;

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress> {
  TaskInfoProvider _taskInfoProvider;

  @override
  void initState() {
    super.initState();
    _taskInfoProvider =
        TaskInfoProvider(context: context, taskID: widget.taskID);
    log("Initilised with " + widget.taskID);

    if (widget.taskID.isNotEmpty) _taskInfoProvider.getData();
  }

  @override
  void dispose() {
    _taskInfoProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.taskID == null) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      );
    }

    return StreamBuilder<DownloadTask>(
        stream: _taskInfoProvider.stream,
        builder: (context, snapshot) {
          // log(snapshot.data.toString());

          // log(snapshot.toString());

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
