import 'package:flutter/material.dart';

enum MessageType { Text, Audio, Video, Image }

class MessageWidget extends StatelessWidget {
  final String message;
  final MessageType messageType;
  final bool ownMessage;

  const MessageWidget({
    @required this.message,
    @required this.messageType,
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
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            decoration: decoration,
            child: Text(
              message,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
