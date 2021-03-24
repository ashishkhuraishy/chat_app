import 'package:chat_app/widgets/emoji_picker.dart';
import 'package:chat_app/widgets/input_widget.dart';
import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final messages = <String>[];
  final controller = TextEditingController();
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    KeyboardVisibility.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("User 1"),
        ),
        body: WillPopScope(
          onWillPop: onBackPress,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  children: messages
                      .map((message) => MessageWidget(
                            message: message,
                            ownMessage: true,
                            messageType: MessageType.Text,
                          ))
                      .toList(),
                ),
              ),
              InputWidget(
                onBlurred: toggleEmojiKeyboard,
                controller: controller,
                isEmojiVisible: isEmojiVisible,
                isKeyboardVisible: isKeyboardVisible,
                onSentMessage: (message) => setState(
                  () => messages.insert(0, message),
                ),
              ),
              Offstage(
                child: EmojiPickerWidget(onEmojiSelected: onEmojiSelected),
                offstage: !isEmojiVisible,
              ),
            ],
          ),
        ),
      );

  void onEmojiSelected(String emoji) => setState(() {
        controller.text = controller.text + emoji;
      });

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }
}
