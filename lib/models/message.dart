import 'dart:io';

import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Message {
  final int id;
  final String messageText;
  final File imgFile;
  final MessageType messageType;

  Message({
    this.imgFile,
    this.id,
    this.messageText,
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
}
