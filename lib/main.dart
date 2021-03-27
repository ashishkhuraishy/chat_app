import 'package:chat_app/widgets/audio_player.dart';
import 'package:chat_app/config/download_config.dart';
import 'package:chat_app/screens/download_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'providers/message_provider.dart';
import 'screens/message_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        Provider<DownloadConfig>(
          create: (context) => DownloadConfig(),
          dispose: (context, value) {
            value.dispose();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: DownloadPage(),
      ),
    );
  }
}
