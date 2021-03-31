part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadStart extends DownloadEvent {
  const DownloadStart({
    @required this.url,
    @required this.fileType,
  });

  final String url;
  final FileType fileType;

  @override
  List<Object> get props => [url, fileType];
}

class DownloadProgressEvent extends DownloadEvent {
  const DownloadProgressEvent({
    @required this.downloadTask,
  });

  final DownloadTask downloadTask;

  @override
  List<Object> get props => [downloadTask];
}
