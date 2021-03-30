import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = <Message>[];
  Map<String, String> _urls = {};

  // Returns all the messages from the instance
  List<Message> get messages => _messages;

  // this method will add a new message to the top of the list
  addMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();

    if (messages.length % 2 == 0) {
      addMessage(Message(
        messageType: MessageType.Image,
        url:
            'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg',
        id: 5,
      ));
    }
  }
}
