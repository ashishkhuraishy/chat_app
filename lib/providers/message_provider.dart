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
  }
}
