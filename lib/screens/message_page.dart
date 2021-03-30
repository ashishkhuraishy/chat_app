import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../widgets/input_widget.dart';
import '../widgets/message_widget.dart';

class MessagePage extends StatelessWidget {
  final ValueNotifier<bool> _isEmojiVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("User 1"),
        ),
        body: WillPopScope(
          onWillPop: () => _onBackPress(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Consumer<MessageProvider>(
                  builder: (context, value, child) {
                    return ListView(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      children: value.messages
                          .map((message) => MessageWidget(
                                message: message,
                                ownMessage: message.id != 5,
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => _isEmojiVisible,
                child: InputWidget(),
              ),
            ],
          ),
        ),
      );

  Future<bool> _onBackPress(BuildContext context) {
    if (_isEmojiVisible.value) {
      // toggleEmojiKeyboard();
      _isEmojiVisible.value = false;
      return Future.value(false);
    }
    Navigator.pop(context);
    return Future.value(true);
  }
}
