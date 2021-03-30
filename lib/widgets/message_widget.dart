import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../config/download_config.dart';
import '../models/message.dart';
import '../screens/preview_page.dart';

enum MessageType { Text, Audio, Video, Image }

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool ownMessage;

  const MessageWidget({
    @required this.message,
    @required this.ownMessage,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    final alignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;
    final decoration = BoxDecoration(
      color: ownMessage ? Colors.grey[200] : Colors.green[200],
      borderRadius: borderRadius.subtract(
        BorderRadius.only(
          bottomRight: ownMessage ? radius : Radius.zero,
          bottomLeft: !ownMessage ? radius : Radius.zero,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: alignment,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
          ),
          child: Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: decoration,
            child: MessageItem(
              message: message,
            ),
          ),
        ),
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (message.messageType) {
      case MessageType.Text:
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            message.messageText,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
          ),
        );
        break;
      case MessageType.Image:
        return ImageMessage(message: message);
      default:
        return Container();
    }
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.all(4),
      child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box(IMAGE_BOX).listenable(keys: [message.url]),
          builder: (context, box, widget) {
            String val = box.get(message.url, defaultValue: '');
            log(val);
            if (val.isEmpty) {
              return DownloadWidgett(
                url: message.url,
              );
            }

            return ImageWidget(imgFile: File(val));
          }),
    );
  }
}

class DownloadWidgett extends StatefulWidget {
  const DownloadWidgett({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  _DownloadWidgettState createState() => _DownloadWidgettState();
}

class _DownloadWidgettState extends State<DownloadWidgett> {
  bool clicked = false;
  StreamController<DownloadTask> _controller;

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
    setState(
      () async => _controller =
          await Provider.of<DownloadConfig>(context, listen: false)
              .addTask(widget.url, FileType.image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: !clicked
              ? IconButton(
                  icon: Icon(Icons.download_rounded),
                  onPressed: _onDownloadPressed,
                )
              : DownloadProgress(controller: _controller),
        ),
      ),
    );
  }
}

class DownloadProgress extends StatelessWidget {
  const DownloadProgress({
    Key key,
    @required StreamController<DownloadTask> controller,
  })  : _controller = controller,
        super(key: key);

  final StreamController<DownloadTask> _controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DownloadTask>(
        stream: _controller.stream,
        builder: (context, snapshot) {
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

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    @required this.imgFile,
  }) : super(key: key);

  final File imgFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            imgFile: imgFile,
          ),
        ),
      ),
      child: Hero(
        tag: imgFile.path,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(
            imgFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
