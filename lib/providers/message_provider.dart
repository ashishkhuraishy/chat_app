import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = <Message>[];

  Message _selectedMessage;
  int _selectedIndex;

  Message _replyMessage;

  math.Random rnd = math.Random();

  // Returns all the messages from the instance
  List<Message> get messages => _messages;

  bool get isSelected => _selectedMessage != null;
  bool get hasreply => _replyMessage != null;

  Message get replyMessage => _replyMessage;
  int get selectedIndex => _selectedIndex ?? -1;

  selectMessage(Message message, int index) {
    _selectedMessage = message;
    _selectedIndex = index;

    log(_selectedMessage.toString());

    notifyListeners();
  }

  cancelSelected() {
    _selectedMessage = null;
    _selectedIndex = -1;

    notifyListeners();
  }

  onReply({Message message}) {
    _replyMessage = message ?? _selectedMessage;

    log(_selectedMessage.toString());
    cancelSelected();
  }

  cancelReply() {
    _replyMessage = null;

    notifyListeners();
  }

  onForward() {}

  onDelete() {}

  // this method will add a new message to the top of the list
  addMessage(Message message) {
    _messages.insert(0, message);

    cancelReply();
    // if (messages.length % 3 == 0) {
    //   addMessage(_mockMessages[rnd.nextInt(_mockMessages.length)]);
    // }
  }
}

// Mock Media data
//
// List<Message> _mockMessages = [
//     Message(
//       messageType: MessageType.Audio,
//       url: 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Video,
//       url:
//           'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Image,
//       url:
//           'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Image,
//       url:
//           'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Image,
//       url:
//           'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Image,
//       url:
//           'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg',
//       id: 5,
//     ),
//     Message(
//       messageType: MessageType.Video,
//       url:
//           'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//       id: 5,
//     ),
//   ];

