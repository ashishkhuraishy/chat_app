import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmojiTextSwitch extends StatelessWidget {
  const EmojiTextSwitch({
    Key key,
    @required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  void _onClickEmoji(BuildContext context, ValueNotifier<bool> notifier) async {
    if (notifier.value) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }

    notifier.value = !notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ValueNotifier<bool>>(
        builder: (context, notifier, child) {
          return IconButton(
            icon: Icon(
              notifier.value
                  ? Icons.keyboard_rounded
                  : Icons.emoji_emotions_outlined,
            ),
            onPressed: () => _onClickEmoji(context, notifier),
          );
        },
      ),
    );
  }
}
