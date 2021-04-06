import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/message_widget.dart';

class Message {
  final int id;
  final String messageText;
  final File imgFile;
  final String url;
  final MessageType messageType;
  final String path;
  bool _hasReply;
  String _replyText;

  Message({
    this.url,
    this.imgFile,
    this.id = 3,
    this.messageText,
    this.path,
    @required this.messageType,
  });

  factory Message.textMessage(String message) {
    return Message(
      messageType: MessageType.Text,
      messageText: message,
    );
  }

  factory Message.imageMessage(PickedFile pickedFile) {
    File _file = File(pickedFile.path);

    return Message(
      messageType: MessageType.Image,
      imgFile: _file,
    );
  }

  factory Message.audioMessage(String path) {
    return Message(
      messageType: MessageType.Audio,
      path: path,
    );
  }

  String get replyText => _replyText ?? '';
  bool get hasReply => _hasReply ?? false;

  set replyText(String reply) {
    if (reply.isEmpty) return;

    this._replyText = reply;
    this._hasReply = true;
  }

  @override
  String toString() {
    return '''
    Message
      ${this.messageText}

      ${this.messageType}
  ''';
  }
}
