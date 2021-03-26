import '../models/message.dart';
import '../providers/message_provider.dart';
import 'emoji_picker.dart';
import 'emoji_text_switch.dart';
import 'send_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class InputWidget extends StatefulWidget {
  InputWidget({
    Key key,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  FocusNode focusNode = FocusNode();
  TextEditingController _controller;

  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  _onSubmit() {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    Provider.of<MessageProvider>(context, listen: false)
        .addMessage(Message.textMessage(_controller.text));

    setState(() => _isEmpty = true);
    _controller.clear();
  }

  void onEmojiSelected(String emoji) {
    setState(() {
      _controller.text += emoji;
    });
  }

  void _onValueChange(String value) {
    if (value.isEmpty != _isEmpty) {
      setState(() {
        _isEmpty = value.isEmpty;
      });
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
                        focusNode: focusNode,
                        // onClick: _onEmojiClick,
                      ),
                      Expanded(
                        child: MessageTextField(
                          focusNode: focusNode,
                          controller: _controller,
                          onChanged: _onValueChange,
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
                onSubmit: _onSubmit,
              ),
            ],
          ),
        ),
        Consumer<ValueNotifier<bool>>(
          builder: (context, notifier, child) {
            return Offstage(
              child: EmojiPickerWidget(
                onEmojiSelected: onEmojiSelected,
              ),
              offstage: !notifier.value,
            );
          },
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
