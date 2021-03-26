import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerWidget({
    @required this.onEmojiSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      rows: 4,
      numRecommended: 6,
      onEmojiSelected: (emoji, category) => onEmojiSelected(emoji.emoji),
    );
  }
}
