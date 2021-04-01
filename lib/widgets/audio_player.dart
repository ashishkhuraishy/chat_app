import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

// TODOD: extract audio player
class AudioPlayerUI extends StatefulWidget {
  final String path;

  const AudioPlayerUI({
    Key key,
    @required this.path,
  }) : super(key: key);

  @override
  _AudioPlayerUIState createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> {
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool playing = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: getAudio,
              child: Icon(
                !playing ? Icons.play_arrow_rounded : Icons.pause,
                size: 30,
              ),
            ),
            Expanded(
              child: Slider(
                label: position.inMinutes.toString() +
                    ":" +
                    position.inSeconds.toString(),
                min: 0.0,
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    audioPlayer.seek(new Duration(seconds: value.toInt()));
                  });
                },
                activeColor: Colors.green[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAudio() async {
    var url = widget.path;
    Uint8List bytes = await File(url).readAsBytes();
    print(url);
    if (playing) {
      //puase song
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      //play song
      var res = await audioPlayer.playBytes(bytes);
      print(res);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        print('Duration ' + d.toString());
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        position = d;
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        playing = false;
      });
    });
  }
}
