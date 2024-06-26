library youtube_box_thumbnail;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_box_thumbnail/youtube_video.dart';

final _kBorderRadius = BorderRadius.circular(12);

class YoutubeBoxThumbnail extends StatefulWidget {
  const YoutubeBoxThumbnail({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.loading,
    this.error,
    this.view,
  });
  final String url;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Widget? loading;
  final Widget Function(String url)? error;
  final Widget Function(YoutubeVideo youtubeVideo)? view;
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
      width: widget.width ?? double.maxFinite,
      height: widget.height ?? 100,
      padding: widget.padding ?? const EdgeInsets.all(12),
      margin: widget.margin ?? const EdgeInsets.all(12),
      decoration: widget.decoration ??
          BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: _kBorderRadius,
          ),
      child: FutureBuilder<YoutubeVideo>(
        future: youtubeVideo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (widget.view == null) {
              return _YoutubeVideoWidget(youtubeVideo: snapshot.data!);
            } else {
              return widget.view!.call(snapshot.data!);
            }
          } else if (snapshot.hasError) {
            if (widget.error == null) {
              return _ErrorWidget(
                url: widget.url,
              );
            } else {
              return widget.error!.call(widget.url);
            }
          } else {
            return widget.loading ?? const _LoadingWidget();
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
        "https://img.youtube.com/vi/${_getIdFromYoutubeUrl()}/0.jpg",
      );
    } catch (ex) {
      rethrow;
    }
  }

  String? _getIdFromYoutubeUrl() {
    for (var exp in [
      RegExp(r".*\?v=(.+?)&.+"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/www\.youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(widget.url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
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
    return InkWell(
      onTap: () async {
        await launchUrlString(youtubeVideo.url);
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: _kBorderRadius,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  youtubeVideo.imageUrl,
                ),
              ),
            ),
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  youtubeVideo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  youtubeVideo.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchUrlString(url);
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: _kBorderRadius,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Unable to retrieve content",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
