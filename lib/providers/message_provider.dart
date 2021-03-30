import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = <Message>[];

  // Returns all the messages from the instance
  List<Message> get messages => _messages;

  // this method will add a new message to the top of the list
  addMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();

    if (messages.length % 2 == 0) {
      addMessage(Message(
        messageType: MessageType.Video,
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        id: 5,
      ));
    }
  }
}
