import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../widgets/input_widget.dart';
import '../widgets/message_widget.dart';

class MessagePage extends StatelessWidget {
  final ValueNotifier<bool> _isEmojiVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ChatAppBar(
          provider: Provider.of<MessageProvider>(context, listen: false),
        ),
        body: WillPopScope(
          onWillPop: () => _onBackPress(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Consumer<MessageProvider>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: value.messages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            Provider.of<MessageProvider>(context, listen: false)
                                .selectMessage(value.messages[index], index);
                          },
                          onHorizontalDragEnd: (details) {
                            // TODO: set this message as reply message
                            Provider.of<MessageProvider>(context, listen: false)
                                .onReply(message: value.messages[index]);
                          },
                          child: MessageWidget(
                            message: value.messages[index],
                            ownMessage: index % 2 == 0,
                            isHighlighted: value.selectedIndex == index,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => _isEmojiVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> _onBackPress(BuildContext context) {
    var messageProvider = Provider.of<MessageProvider>(
      context,
      listen: false,
    );

    if (_isEmojiVisible.value) {
      // toggleEmojiKeyboard();
      _isEmojiVisible.value = false;
      return Future.value(false);
    } else if (messageProvider.isSelected) {
      messageProvider.cancelSelected();

      return Future.value(false);
    }

    return Future.value(true);
  }
}
