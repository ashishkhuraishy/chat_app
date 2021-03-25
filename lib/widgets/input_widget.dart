import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isEmojiVisible;
  final bool isKeyboardVisible;
  final Function onBlurred;
  final ValueChanged<String> onSentMessage;

  InputWidget({
    @required this.controller,
    @required this.isEmojiVisible,
    @required this.isKeyboardVisible,
    @required this.onSentMessage,
    @required this.onBlurred,
    Key key,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black87,
                  width: 0.2,
                ),
              ),
              child: Row(
                children: <Widget>[
                  EmojiKeyboardSwitch(
                    isEmojiVisible: widget.isEmojiVisible,
                    focusNode: focusNode,
                    isKeyboardVisible: widget.isKeyboardVisible,
                    onBlurred: widget.onBlurred,
                  ),
                  Expanded(
                    child: MessageTextField(
                      focusNode: focusNode,
                      controller: _controller,
                      onChanged: (value) {
                        if (value.isEmpty != _isEmpty) {
                          setState(() {
                            _isEmpty = value.isEmpty;
                          });
                        }
                      },
                    ),
                  ),
                  _isEmpty ? FileInputWidget() : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          SendButton(
            controller: widget.controller,
            onSentMessage: widget.onSentMessage,
          ),
        ],
      ),
    );
  }
}

class FileInputWidget extends StatelessWidget {
  const FileInputWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () => print('Clicked camera'),
        ),
        // IconButton(
        //   icon: Icon(Icons.camera_alt),
        //   onPressed: () => print('Clicked camera'),
        // ),
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
    this.onChanged,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLines: 10,
        minLines: 1,
        onChanged: (value) => onChanged(value),
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration.collapsed(
          hintText: 'Type your message...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
        ),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green[900],
      ),
      child: IconButton(
        icon: Icon(
          Icons.mic_outlined,
          color: Colors.white,
        ),
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
