import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../../config/download_config.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({
    @required this.url,
    @required this.fileType,
    @required this.downloadConfig,
  }) : super(DownloadInitial()) {
    _checkIfDownloading(this.url);
  }

  final DownloadConfig downloadConfig;
  final String url;
  final FileType fileType;

  StreamSubscription<DownloadEvent> _subscription;

  @override
  Stream<DownloadState> mapEventToState(
    DownloadEvent event,
  ) async* {
    if (event is DownloadStart) {
      yield DownloadStartState();
      var taskID = await downloadConfig.addTask(event.url, event.fileType);

      _subscription = _checkProgress(taskID).listen((event) => this.add(event));
    } else if (event is DownloadProgressEvent) {
      yield DownloadProgressState(progress: event.downloadTask.progress / 100);
    }
  }

  _checkIfDownloading(String url) {
    var id = downloadConfig.check(url);
    if (id.isNotEmpty)
      _subscription = _checkProgress(id).listen((event) => this.add(event));
  }

  Stream<DownloadEvent> _checkProgress(String taskID) async* {
    while (true) {
      var task = await downloadConfig.taskProgress(taskID);
      yield DownloadProgressEvent(downloadTask: task);

      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
