import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../config/download_config.dart';
import 'bloc/download_bloc.dart';

class DownloadWidgett extends StatelessWidget {
  const DownloadWidgett({
    Key key,
    @required this.url,
    @required this.fileType,
  }) : super(key: key);

  final String url;
  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DownloadBloc>(
      create: (context) => DownloadBloc(
        downloadConfig: Provider.of<DownloadConfig>(context, listen: false),
        fileType: fileType,
        url: url,
      ),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.7),
              ),
              child: BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (context, state) {
                if (state is DownloadInitial) {
                  return IconButton(
                    icon: Icon(
                      Icons.cloud_download_rounded,
                      size: 28,
                    ),
                    onPressed: () => BlocProvider.of<DownloadBloc>(context)
                        .add(DownloadStart(url: url, fileType: fileType)),
                  );
                } else if (state is DownloadProgressState) {
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    value: state.progress,
                  );
                }

                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                );
              })),
        ),
      ),
    );
  }
}

class DownloadableAudioPlayer extends StatelessWidget {
  final String url;

  const DownloadableAudioPlayer({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadBloc(
        url: url,
        fileType: FileType.audio,
        downloadConfig: Provider.of<DownloadConfig>(
          context,
          listen: false,
        ),
      ),
      child: Row(
        children: [
          BlocBuilder<DownloadBloc, DownloadState>(
            builder: (context, state) {
              if (state is DownloadInitial) {
                return IconButton(
                  icon: Icon(
                    Icons.download_rounded,
                  ),
                  onPressed: () => BlocProvider.of<DownloadBloc>(context).add(
                    DownloadStart(
                      url: url,
                      fileType: FileType.audio,
                    ),
                  ),
                );
              } else if (state is DownloadProgressState) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[200]),
                  value: state.progress,
                );
              }

              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[200]),
              );
            },
          ),
          Expanded(
            child: Slider(
              value: 0,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}


// class DownloadProgress extends StatefulWidget {
//   const DownloadProgress({
//     Key key,
//     @required this.taskID,
//   }) : super(key: key);

//   final String taskID;

//   @override
//   _DownloadProgressState createState() => _DownloadProgressState();
// }

// class _DownloadProgressState extends State<DownloadProgress> {
//   TaskInfoProvider _taskInfoProvider;

//   @override
//   void initState() {
//     super.initState();
//     _taskInfoProvider =
//         TaskInfoProvider(context: context, taskID: widget.taskID);
//     log("Initilised with " + widget.taskID);

//     if (widget.taskID.isNotEmpty) _taskInfoProvider.getData();
//   }

//   @override
//   void dispose() {
//     _taskInfoProvider.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.taskID == null) {
//       return CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//       );
//     }

//     return StreamBuilder<DownloadTask>(
//         stream: _taskInfoProvider.stream,
//         builder: (context, snapshot) {
//           // log(snapshot.data.toString());

//           // log(snapshot.toString());

//           if (!snapshot.hasData) {
//             return CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//             );
//           }

//           return CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//             value: snapshot.data.progress / 100,
//           );
//         });
//   }
// }
