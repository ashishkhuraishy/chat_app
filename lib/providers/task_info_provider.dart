import 'dart:async';
import 'dart:developer';

import 'package:chat_app/config/download_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

class TaskInfoProvider {
  final String taskID;
  final BuildContext context;

  DownloadConfig _downloadConfig;

  StreamController<DownloadTask> _streamController =
      StreamController<DownloadTask>();
  bool active = true;

  TaskInfoProvider({
    @required this.context,
    @required this.taskID,
  }) {
    _downloadConfig = Provider.of<DownloadConfig>(this.context, listen: false);
    if (taskID.isNotEmpty) getData();
  }

  Stream<DownloadTask> get stream => _streamController.stream;

  getData() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      while (active) {
        log('Timer called');
        var task = await _downloadConfig.taskProgress(taskID);

        _streamController.add(task);

        if (task.status == DownloadTaskStatus.complete) {
          await _downloadConfig.addToDB(task);
          timer.cancel();
          active = false;
        }
      }
    });
  }

  dispose() {
    _streamController.close();
    print('Dispose called');
  }
}
