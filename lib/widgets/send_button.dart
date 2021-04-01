import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/audio_recorder.dart';
import '../models/message.dart';
import '../providers/message_provider.dart';

class SendButton extends StatelessWidget {
  SendButton({
    Key key,
    @required this.onSubmit,
    @required this.hasText,
    this.onRecording,
  }) : super(key: key);

  final Function onSubmit;
  final bool hasText;

  final ValueChanged<Duration> onRecording;

  final AudioRecorderConfig _recorderConfig = AudioRecorderConfig();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // onRecording(Duration(milliseconds: 100));
        if (!hasText) {
          _recorderConfig.start();
        }
      },
      onLongPressEnd: (details) async {
        if (!hasText && await _recorderConfig.isRecording) {
          var path = await _recorderConfig.stop();
          if (path.isEmpty) return;

          var message = Message.audioMessage(path);
          Provider.of<MessageProvider>(context, listen: false)
              .addMessage(message);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[900],
        ),
        child: IconButton(
          icon: Icon(
            !hasText ? Icons.mic_outlined : Icons.send_rounded,
            color: Colors.white,
          ),
          onPressed: () => onSubmit(),
        ),
      ),
    );
  }
}
