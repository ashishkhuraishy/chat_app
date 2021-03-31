part of 'download_bloc.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

class DownloadInitial extends DownloadState {}

class DownloadStartState extends DownloadState {}

class DownloadProgressState extends DownloadState {
  const DownloadProgressState({
    @required this.progress,
  });

  final double progress;

  @override
  List<Object> get props => [progress];
}

class DownloadFinished extends DownloadState {}
