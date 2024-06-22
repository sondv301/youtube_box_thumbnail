library youtube_box_thumbnail;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_box_thumbnail/youtube_video.dart';
import 'package:http/http.dart' as http;

final _kBorderRadius = BorderRadius.circular(12);

class YoutubeBoxThumbnail extends StatefulWidget {
  const YoutubeBoxThumbnail({
    super.key,
    required this.url,
  });
  final String url;
  @override
  State<YoutubeBoxThumbnail> createState() => _YoutubeBoxThumbnailState();
}

class _YoutubeBoxThumbnailState extends State<YoutubeBoxThumbnail> {
  late final Future<YoutubeVideo> youtubeVideo;
  @override
  void initState() {
    youtubeVideo = _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 100,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: _kBorderRadius,
      ),
      child: FutureBuilder<YoutubeVideo>(
        future: youtubeVideo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _YoutubeVideoWidget(youtubeVideo: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("error");
          } else {
            return const _LoadingWidget();
          }
        },
      ),
    );
  }

  Future<YoutubeVideo> _loadData() async {
    try {
      final uri = Uri.parse(widget.url);
      final response = await http.get(uri);
      final htmlBody = response.body;
      final title =
          htmlBody.substring(htmlBody.indexOf("<title>") + 7, htmlBody.indexOf("</title>"));
      return YoutubeVideo(
        widget.url,
        title,
        "imageUrl",
      );
    } catch (ex) {
      rethrow;
    }
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: _kBorderRadius,
          ),
          child: const Icon(
            Icons.play_circle_outline,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: LinearProgressIndicator(
            borderRadius: _kBorderRadius,
          ),
        ),
      ],
    );
  }
}

class _YoutubeVideoWidget extends StatelessWidget {
  const _YoutubeVideoWidget({super.key, required this.youtubeVideo});
  final YoutubeVideo youtubeVideo;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: _kBorderRadius,
          ),
          child: const Icon(
            Icons.play_circle_outline,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            children: [
              Text(youtubeVideo.title),
            ],
          ),
        ),
      ],
    );
  }
}