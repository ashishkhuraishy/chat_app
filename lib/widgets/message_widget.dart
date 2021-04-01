import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/message.dart';
import 'audio_player.dart';
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
