import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreem extends StatefulWidget {
  final String path;
  const VideoPlayerScreem({
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPlayerScreem> createState() => _VideoPlayerScreemState();
}

class _VideoPlayerScreemState extends State<VideoPlayerScreem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
