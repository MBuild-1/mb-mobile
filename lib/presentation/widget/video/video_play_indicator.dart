import 'package:flutter/material.dart';

class VideoPlayIndicator extends StatelessWidget {
  const VideoPlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          shape: BoxShape.circle
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}