import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

enum FileType { image, audio, video }
// Constant declared to keep track of the current download info
const String DOWNLOAD_NOTIFIER_PORT = 'DOWNLOAD_NOTIFIER_PORT';

class DownloadConfig {
  Map<String, String> _urlWithIDMap = {};
  Map<String, StreamController<DownloadTask>> _idWithControllerMap = {};

  ReceivePort _port = ReceivePort();

  DownloadConfig() {
    _registerDownload();
  }

  void addTask(String url, String fileType) async {
    var downloadDir = await _generateDownloadDir(fileType);
    if (downloadDir.isEmpty) return;

    final taskID = await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadDir,
      showNotification: false,
      openFileFromNotification: false,
    );

    _urlWithIDMap[url] = taskID;
    _idWithControllerMap[taskID] = StreamController<DownloadTask>();
  }

  // This method will initialise and create a port for main isolate
  // to listen to and register a call back to recive the download
  // progress of each tasks and send it to their subscriptions
  void _registerDownload() {
    // TODO: close port and isoloate on dispose
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      DOWNLOAD_NOTIFIER_PORT,
    );

    _port.listen((message) {
      String id = message[0];
      DownloadTaskStatus status = message[1];
      int downloadrogress = message[2];

      var taskInfo =
          DownloadTask(taskId: id, status: status, progress: downloadrogress);

      _idWithControllerMap[id].add(taskInfo);
    });

    FlutterDownloader.registerCallback(_downloadCallback);
  }

  // Download call back will invoke a callback to the send port which will
  // add data to the respective stream of each download task
  void _downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName(DOWNLOAD_NOTIFIER_PORT);
    send.send([id, status, progress]);
  }

  // This method will generate a download path for the file based on its type
  // which will be later dicoverable by external apps
  Future<String> _generateDownloadDir(String type) async {
    // Check wheather the app has permission to create a directory inside the
    // device. If it doesnt then return an empty string. That will indicate
    // we dont have a valid path to store the downloaded file
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return "";

    // TODO: change this to the app name
    String appName = "ChatApp";

    Directory _dir = Directory('/storage/emulated/0/$appName/$type');
    if (!await _dir.exists()) _dir.createSync(recursive: true);

    return _dir.path;
  }

  // [CheckStoragePermission] will check for storage permission and return
  // true if access granted. if access is denied / not set then this method
  // request for permission and return the updated status
  Future<bool> _checkStoragePermission() async {
    var permission = Permission.storage;
    var status = await permission.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      // TODO: show toast saying denied permenently
    }

    return await permission.request() == PermissionStatus.granted;
  }
}
