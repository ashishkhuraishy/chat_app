import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'video.g.dart';

@HiveType(typeId: 0)
class Video {
  @HiveField(0)
  final String thumbNailPath;
  @HiveField(1)
  final String filePath;

  Video({
    @required this.thumbNailPath,
    @required this.filePath,
  });
}
