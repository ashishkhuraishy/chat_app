import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'download_config.dart';

class AudioRecorderConfig {
  Future<bool> get isRecording async => Record.isRecording();

  String _path = '';

  void start() async {
    // Check and request permission
    if (await Record.hasPermission()) {
      var name = DateTime.now().toString().split(' ').join('_');
      var path = await _generateDownloadDir('.recordings/');
      path += '$name.m4a';
      _path = path;
      await Record.start(
        path: path,
      );
    }
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

  Future<String> stop() async {
    await Record.stop();

    return _path;
  }
}
