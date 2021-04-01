import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../providers/message_provider.dart';
import 'emoji_picker.dart';
import 'emoji_text_switch.dart';
import 'send_button.dart';

class InputWidget extends StatefulWidget {
  InputWidget({
    Key key,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  FocusNode _focusNode;
  TextEditingController _controller;

  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    var text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<MessageProvider>(context, listen: false)
          .addMessage(Message.textMessage(text));
    }

    setState(() => _isEmpty = true);
    _controller.clear();
  }

  void _onEmojiSelected(String emoji) {
    setState(() => _controller.text += emoji);
  }

  void _onValueChange(String value) {
    if (value.isEmpty != _isEmpty) {
      setState(() => _isEmpty = value.isEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                      EmojiTextSwitch(
                        focusNode: _focusNode,
                        // onClick: _onEmojiClick,
                      ),
                      Expanded(
                        child: MessageTextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          onChanged: _onValueChange,
                        ),
                      ),
                      Visibility(
                        child: FileInputWidget(),
                        visible: _isEmpty,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              SendButton(
                onSubmit: _onSubmit,
                hasText: !_isEmpty,
                onRecording: (value) {},
              ),
            ],
          ),
        ),
        EmojiPickerWidget(
          onEmojiSelected: _onEmojiSelected,
        ),
      ],
    );
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
        minLines: 1,
        maxLines: null,
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

class FileInputWidget extends StatelessWidget {
  FileInputWidget({
    Key key,
  }) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              PickedFile img =
                  await _picker.getImage(source: ImageSource.gallery);
              print(img.path);

              Provider.of<MessageProvider>(context, listen: false)
                  .addMessage(Message.imageMessage(img));
            }),
        // IconButton(
        //   icon: Icon(Icons.camera_alt),
        //   onPressed: () => print('Clicked camera'),
        // ),
      ],
    );
  }
}
