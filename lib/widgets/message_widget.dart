import 'dart:ui';

import 'package:chat_app/config/download_config.dart';
import 'package:chat_app/widgets/audio_player.dart';
import 'package:chat_app/widgets/bloc/download_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import 'image_message_widget.dart';
import 'video_message_widget.dart';

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
      case MessageType.Video:
        return VideoMessage(message: message);
      case MessageType.Audio:
        return AudioMessage(message: message);
      default:
        return Container();
    }
  }
}

class AudioMessage extends StatelessWidget {
  final Message message;

  const AudioMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box(AUDIO_BOX).listenable(keys: [
          message.url,
        ]),
        builder: (context, box, widget) {
          String path = box.get(message.url, defaultValue: '');
          if (path.isEmpty) {
            return DownloadableAudioPlayer(url: message.url);
          }

          return AudioPlayerUI(
            path: path,
          );
        });
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
