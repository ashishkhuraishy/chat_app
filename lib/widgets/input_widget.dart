import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmojiVisible;
  final bool isKeyboardVisible;
  final Function onBlurred;
  final ValueChanged<String> onSentMessage;
  final focusNode = FocusNode();

  InputWidget({
    @required this.controller,
    @required this.isEmojiVisible,
    @required this.isKeyboardVisible,
    @required this.onSentMessage,
    @required this.onBlurred,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.5)),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                EmojiKeyboardSwitch(
                  isEmojiVisible: isEmojiVisible,
                  focusNode: focusNode,
                  isKeyboardVisible: isKeyboardVisible,
                  onBlurred: onBlurred,
                ),
                Expanded(
                  child: MessageTextField(
                    focusNode: focusNode,
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ),
        SendButton(
          controller: controller,
          onSentMessage: onSentMessage,
        ),
      ],
    );
  }
}

class EmojiKeyboardSwitch extends StatelessWidget {
  const EmojiKeyboardSwitch({
    Key key,
    @required this.isEmojiVisible,
    @required this.focusNode,
    @required this.isKeyboardVisible,
    @required this.onBlurred,
  }) : super(key: key);

  final bool isEmojiVisible;
  final FocusNode focusNode;
  final bool isKeyboardVisible;
  final Function onBlurred;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(
          isEmojiVisible
              ? Icons.keyboard_rounded
              : Icons.emoji_emotions_outlined,
        ),
        onPressed: onClickEmoji,
      ),
    );
  }

  void onClickEmoji() async {
    if (isEmojiVisible) {
      focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(Duration(milliseconds: 100));
    }
    onBlurred();
  }
}

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key key,
    @required this.focusNode,
    @required this.controller,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: 10,
      minLines: 1,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration.collapsed(
        hintText: 'Type your message...',
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({
    Key key,
    @required this.controller,
    @required this.onSentMessage,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onSentMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {
          if (controller.text.trim().isEmpty) {
            return;
          }

          onSentMessage(controller.text);
          controller.clear();
        },
      ),
    );
  }
}
