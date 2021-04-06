import 'dart:developer';

import 'package:chat_app/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final MessageProvider provider;

  void _onCopy() {
    Clipboard.setData(
      ClipboardData(
        text: provider.messages[provider.selectedIndex].messageText,
      ),
    );

    // TODO: show toast saying `'message copied!'`
  }

  _onDelete() async {
    // if (Hive.box('user').get('userId') == this.isSelected.value.userId)
    //   deleteMessage.deleteMessage(this.isSelected.value.unid);

    // if (!Hive.isBoxOpen(id)) await Hive.openBox<Messages>(id);
    // Hive.box<Messages>(id).deleteAt(this.isSelected.value.index);
  }

  void _onForward() {
    // TODO : Implement on forward
    //
    // Message message = this.isSelected.value;
  }

  void _onReply() {
    // TODO : Implement on reply
    //

    provider.onReply();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, notifier, widget) {
        if (!notifier.isSelected) {
          return AppBar(
            // backgroundColor: Constants.themeGradientsMedium[0],
            title: Text('chatName'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(Icons.info),
                  onTap: () {
                    // if (isGroup != "2")
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => isGroup == "1"
                    //           ? GroupDescription(
                    //               groupId: id,
                    //               groupImage: dp,
                    //               groupName: chatName,
                    //             )
                    //           : ProfilePageViewData(id, chatName),
                    //     ),
                    //   );
                  },
                ),
              ),
            ],
          );
        }

        return AppBar(
          // backgroundColor: Constants.themeGradientsMedium[0],
          actions: [
            IconButton(
              icon: Icon(Icons.copy_rounded),
              onPressed: _onCopy,
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: _onDelete,
            ),
            IconButton(
              icon: Icon(Icons.forward_to_inbox_rounded),
              onPressed: _onForward,
            ),
            IconButton(
              icon: Icon(Icons.reply),
              onPressed: _onReply,
            ),
          ],
          // title: Text(chatName),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SelectedModel {
  final int index;
  final String unid;
  final Message selectedMessage;
  final String userId;
  Message replyMessage;

  SelectedModel({
    this.replyMessage,
    this.index,
    this.unid,
    this.selectedMessage,
    this.userId,
  });
}
