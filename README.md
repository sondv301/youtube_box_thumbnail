## Youtube Box Thumbnail

Package used to display video thumbnail box from youtube

## Getting started

### Depend on it
```dart
dependencies:
  youtube_box_thumbnail: ^1.0.0+1
```

## Example

![](https://raw.githubusercontent.com/sondv301/youtube_box_thumbnail/main/assets/images/sc1.png "Example")

```dart
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
```