import 'package:flutter/material.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Image.asset("assets/images/daily_videos.png"),
    );
  }
}
