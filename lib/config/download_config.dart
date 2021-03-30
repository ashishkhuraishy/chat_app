import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/video/video.dart';

// TODO: Handle errors gracefully

enum FileType { image, audio, video }
// Constant declared to keep track of the current download info
const DOWNLOAD_NOTIFIER_PORT = 'DOWNLOAD_NOTIFIER_PORT';
const IMAGE_BOX = 'IMAGE_BOX';
const VIDEO_BOX = 'VIDEO_BOX';

// TODO: change app name
const APP_NAME = "ChatApp";

class DownloadConfig {
  final Map<String, String> _urlWithIDMap = {};
  final Map<String, StreamController<DownloadTask>> _idWithControllerMap = {};
  final Map<String, FileType> _taskType = {};

  final ReceivePort _port = ReceivePort();

  DownloadConfig() {
    _registerDownload();
  }

  Future<StreamController<DownloadTask>> addTask(
      String url, FileType fileType) async {
    var downloadDir = await _generateDownloadDir(fileType.stringify);
    if (downloadDir.isEmpty) return null;

    final taskID = await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadDir,
      showNotification: false,
      openFileFromNotification: false,
    );

    _urlWithIDMap[url] = taskID;
    _taskType[taskID] = fileType;
    _idWithControllerMap[taskID] = StreamController<DownloadTask>();

    return _idWithControllerMap[taskID];
  }

  void dispose() async {
    await FlutterDownloader.cancelAll();

    IsolateNameServer.removePortNameMapping(DOWNLOAD_NOTIFIER_PORT);
    _port.close();
  }

  // This method will initialise and create a port for main isolate
  // to listen to and register a call back to recive the download
  // progress of each tasks and send it to their subscriptions
  void _registerDownload() {
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      DOWNLOAD_NOTIFIER_PORT,
    );

    _port.listen((message) async {
      String id = message[0];
      DownloadTaskStatus status = message[1];

      var taskInfo = await _taskProgress(id);

      if (status == DownloadTaskStatus.complete) _addToDB(taskInfo.url, id);

      _idWithControllerMap[id].add(taskInfo);
    });

    FlutterDownloader.registerCallback(_downloadCallback);
  }

  // Download call back will invoke a callback to the send port which will
  // add data to the respective stream of each download task
  static void _downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
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

    log(hasPermission.toString());

    Directory _dir = Directory('/storage/emulated/0/$APP_NAME/Media/$type');
    if (!await _dir.exists()) _dir.createSync(recursive: true);

    return _dir.path;
  }

  // [CheckStoragePermission] will check for storage permission and return
  // true if access granted. if access is denied / not set then this method
  // request for permission and return the updated status
  Future<bool> _checkStoragePermission() async {
    var permission = Permission.storage;
    var status = await permission.status;

    log(status.toString());
    if (status.isGranted) return true;

    return await permission.request() == PermissionStatus.granted;
  }

  // Add to DB will take the url and find the stored path, then
  // adds those data into hive db and make it referncable on the UI
  void _addToDB(String url, String taskID) async {
    var task = await _taskProgress(taskID);

    var storedPath = task.savedDir + '/' + task.filename;
    log(storedPath);

    var type = _taskType[taskID];

    if (type == FileType.image) {
      Hive.box(IMAGE_BOX).put(url, storedPath);
    } else if (type == FileType.video) {
      var _thumbNail = await _generateThumbnail(storedPath);

      log(_thumbNail);
      var video = Video(filePath: storedPath, thumbNailPath: _thumbNail);
      Hive.box(VIDEO_BOX).put(url, video);
    }

    _idWithControllerMap[taskID].close();

    _urlWithIDMap.remove(url);
    _idWithControllerMap.remove(taskID);
    _taskType.remove(taskID);
  }

  // This method will generate and store a thumbnail from a given video
  // file which will be later used to show on chat page
  Future<String> _generateThumbnail(String filePath) async {
    var dir = await _generateDownloadDir(".thumbnails");
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: filePath,
      thumbnailPath: dir,
      imageFormat: ImageFormat.PNG,
    );

    return thumbPath;
  }

  Future<DownloadTask> _taskProgress(String taskID) async {
    var query = "SELECT * FROM task WHERE task_id='$taskID'";
    var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);

    var task = tasks?.first;
    log(task.toString());

    return task;
  }
}

// FileTypeExtension is to add a stringify method on to FileType so that
// we can return valid string name from the enum to create folder names.
extension FileTypeExtension on FileType {
  String get stringify {
    switch (this) {
      case FileType.image:
        return "${APP_NAME}_image";
        break;
      case FileType.video:
        return "${APP_NAME}_video";
        break;
      case FileType.audio:
        return "${APP_NAME}_audio";
        break;
      default:
        return ".misc";
    }
  }
}
