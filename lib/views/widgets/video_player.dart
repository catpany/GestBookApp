import 'dart:developer';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../styles.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String src;
  final bool fromNetwork;

  const VideoPlayerWidget(
      {Key? key, required this.src, this.fromNetwork = true})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool _playbackVisible = false;
  bool _slow = false;
  late Duration currentPosition;
  late Duration bufferedPosition;
  Key visibilityKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _videoPlayerController = widget.fromNetwork
        ? VideoPlayerController.network(widget.src)
        : VideoPlayerController.file(File(widget.src))
      ..addListener(() {
        setState(() {
          currentPosition = _videoPlayerController.value.position;
          bufferedPosition = _videoPlayerController.value.buffered.isNotEmpty
              ? _videoPlayerController.value.buffered.first.end
              : const Duration(seconds: 0);
        });
      })
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Widget _renderPlayer() {
    return _videoPlayerController.value.isInitialized
        ? Container(
            height: 212,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                        height: _videoPlayerController.value.size.height,
                        width: _videoPlayerController.value.size.width,
                        child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController))))))
        : Container(
            decoration: const BoxDecoration(
                color: ColorStyles.gray,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            alignment: AlignmentDirectional.center,
            width: double.infinity,
            height: 212,
            child: const Icon(Icons.play_arrow_rounded,
                color: ColorStyles.grayDark, size: 60),
          );
  }

  Widget _renderOverlay() {
    return _videoPlayerController.value.isInitialized
        ? InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _playbackVisible = !_playbackVisible;
              });
            },
            child: SizedBox(
              width: double.infinity,
              height: 212,
              child: _renderPlayback(),
            ))
        : const SizedBox.shrink();
  }

  void decreaseSpeed() {
    setState(() {
      _slow = !_slow;
      _slow
          ? _videoPlayerController.setPlaybackSpeed(0.5)
          : _videoPlayerController.setPlaybackSpeed(1);
    });
  }

  Widget _renderPlayback() {
    if (_playbackVisible) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: double.infinity,
            height: 212,
            decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Positioned(
              right: 5,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.speed_outlined,
                    size: 25,
                    color: _slow ? ColorStyles.grayDark : ColorStyles.white),
                onPressed: () {
                  decreaseSpeed();
                },
              )),
          _renderActionButton(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 64,
            child: _renderProgressBar(),
          )
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _renderActionButton() {
    if (_videoPlayerController.value.isPlaying) {
      return IconButton(
        iconSize: 60,
        onPressed: () {
          _videoPlayerController.pause();
        },
        icon: const Icon(Icons.pause, color: ColorStyles.white),
      );
    } else if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
      return IconButton(
        onPressed: () {
          _videoPlayerController.seekTo(Duration.zero);
          _videoPlayerController.play();
        },
        iconSize: 60,
        icon: const Icon(Icons.replay_rounded, color: ColorStyles.white),
      );
    }

    return IconButton(
      onPressed: () {
        _videoPlayerController.play();
      },
      iconSize: 60,
      icon: const Icon(Icons.play_arrow_rounded, color: ColorStyles.white),
    );
  }

  Widget _renderProgressBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // fullscreen button
        // Container(
        //     alignment: AlignmentDirectional.centerEnd,
        //     width: double.infinity,
        //     height: 20,
        //     child:
        //     ElevatedButton(
        //       style: ButtonStyle(
        //         overlayColor:
        //         MaterialStateProperty.all<Color>(Colors.transparent),
        //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        //             const EdgeInsets.all(0.0)),
        //         minimumSize: MaterialStateProperty.all<Size>(const Size(20, 20)),
        //         shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        //         backgroundColor:
        //         MaterialStateProperty.all<Color>(Colors.transparent),
        //         foregroundColor:
        //         MaterialStateProperty.all<Color>(Colors.transparent),
        //       ),
        //       child: const Icon(Icons.crop_free_rounded, size: 20, color: Colors.white), onPressed: () {  },
        //     )
        // ),
        Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
            child: ProgressBar(
              timeLabelLocation: TimeLabelLocation.below,
              timeLabelTextStyle: TextStyles.text12Regular,
              buffered: bufferedPosition,
              progress: currentPosition,
              total: _videoPlayerController.value.duration,
              onSeek: (duration) {
                _videoPlayerController.seekTo(duration);
              },
              baseBarColor: ColorStyles.white,
              bufferedBarColor: ColorStyles.grayDark,
              progressBarColor: ColorStyles.red,
              thumbColor: ColorStyles.red,
              thumbRadius: 4,
              barHeight: 3,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: visibilityKey,
        onVisibilityChanged: (VisibilityInfo info) {
          debugPrint("${info.visibleFraction} of my widget is visible");
          if (info.visibleFraction == 0 && _videoPlayerController.value.isInitialized) {
            _videoPlayerController.pause();
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [_renderPlayer(), _renderOverlay()],
        ));
  }
}
