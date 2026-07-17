import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePage extends StatefulWidget {
  final String? ytKey;
  final String? title;
  const YoutubePage({this.ytKey, this.title});
  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.ytKey!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
        forceHD: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (mounted && isFullScreen != _controller.value.isFullScreen) {
      setState(() => isFullScreen = _controller.value.isFullScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              title: Text(widget.title ?? '', style: Styles.mMed.copyWith(fontSize: 16)),
              backgroundColor: AppColors.background,
              centerTitle: true,
            ),
      body: Center(
        child: YoutubePlayer(
          progressColors: const ProgressBarColors(
            handleColor: AppColors.primary,
            backgroundColor: AppColors.cardLight,
            bufferedColor: AppColors.textMuted,
            playedColor: AppColors.primary,
          ),
          controller: _controller,
          liveUIColor: AppColors.primary,
          topActions: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: Styles.mReg.copyWith(fontSize: 10),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
