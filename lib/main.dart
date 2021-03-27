import 'package:chat_app/widgets/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/message_provider.dart';
import 'screens/message_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AudioPlayerUI(),
      ),
    );
  }
}
