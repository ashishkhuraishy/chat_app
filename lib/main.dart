import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'config/download_config.dart';
import 'models/video/video.dart';
import 'providers/message_provider.dart';
import 'screens/message_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await FlutterDownloader.initialize(debug: true);

  Hive.registerAdapter<Video>(VideoAdapter());

  await Hive.openBox(IMAGE_BOX);
  await Hive.openBox(VIDEO_BOX);

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
          dispose: (context, value) => value.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MessagePage(),
      ),
    );
  }
}
