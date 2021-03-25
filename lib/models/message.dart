import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final int id;
  final String messageText;
  final String path;
  final MessageType messageType;

  Message({
    this.path,
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
}
