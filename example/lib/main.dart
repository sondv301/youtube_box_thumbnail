import 'package:flutter/material.dart';
import 'package:youtube_box_thumbnail/youtube_box_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Youtube box thumbnail - Example"),
        ),
        body: const YoutubeBoxThumbnail(
          url: "https://www.youtube.com/watch?v=LiM8IXH5eWE",
        ),
      ),
    );
  }
}
