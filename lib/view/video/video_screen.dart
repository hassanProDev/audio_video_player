import 'package:audio_video_player/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({super.key, required this.video});

  VideoModel video;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  bool _isDraggingSlider = false;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      widget.video.path, // Replace with a valid video URL
    )
      ..initialize().then((_) {
        setState(() {}); // Update UI once the video is initialized
      })
      ..addListener(() {
        if (!_isDraggingSlider) {
          setState(() {
            _sliderValue = _controller.value.position.inSeconds.toDouble();
          });
        }
      });
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
      if (isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f3ed),
      body: ListView(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_formatDuration(_controller.value.duration)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Slider(
                                min: 0.0,
                                max:
                                    _controller.value.duration.inSeconds.toDouble(),
                                value: _sliderValue,
                                onChangeStart: (value) {
                                  setState(() {
                                    _isDraggingSlider = true;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _sliderValue = value;
                                  });
                                },
                                onChangeEnd: (value) {
                                  setState(() {
                                    _isDraggingSlider = false;
                                    _controller
                                        .seekTo(Duration(seconds: value.toInt()));
                                  });
                                },
                              ),
                              Text(
                                "${_formatDuration(_controller.value.position)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: _toggleFullScreen,
                                  icon: Icon(isFullScreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.replay_5),
                                    onPressed: _rewind5Seconds,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.forward_5),
                                    onPressed: _fastForward5Seconds,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
          ListTile(
            title: Text("${widget.video.speakerName}"),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.video.speakerName}"),
                Text("${widget.video.videoDuration}"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("الوصف"),
                RichText(
                  text: TextSpan(
                      text: "${widget.video.description}",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _rewind5Seconds() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - Duration(seconds: 5);
    _controller
        .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _fastForward5Seconds() {
    final currentPosition = _controller.value.position;
    final maxPosition = _controller.value.duration;
    final newPosition = currentPosition + Duration(seconds: 5);
    _controller.seekTo(newPosition < maxPosition ? newPosition : maxPosition);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
