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
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oups.. \nLooks like we cannot open this file yet!\nFile path is: ${widget.path}',
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
