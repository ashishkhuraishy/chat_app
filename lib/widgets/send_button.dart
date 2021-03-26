import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    Key key,
    @required this.onSubmit,
  }) : super(key: key);

  final Function onSubmit;

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
        onPressed: () => onSubmit(),
      ),
    );
  }
}
