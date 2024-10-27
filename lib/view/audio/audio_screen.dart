import 'dart:math';

import 'package:audio_video_player/model/audio_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioScreen extends StatefulWidget {
  List<AudioModel> audioUrls;
  int currentIndex = 0;

  AudioScreen({super.key, required this.audioUrls, required this.currentIndex});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool isRepeat = false;
  bool isRandom = false;

  Duration _duration = Duration();
  Duration _position = Duration();
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    loadAudio();

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
        _sliderValue = (_position.inMilliseconds / _duration.inMilliseconds)
            .clamp(0.0, 1.0);
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (isRepeat) {
        audioPlayer.seek(Duration.zero);
        audioPlayer.play(AssetSource(widget.audioUrls[widget.currentIndex].path));
      } else {
        skipNext();
      }
    });
  }

  Future<void> loadAudio() async {
    await audioPlayer.setSource(AssetSource(widget.audioUrls[widget.currentIndex].path));
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(AssetSource(widget.audioUrls[widget.currentIndex].path));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void skipNext() {
    if (isRandom) {
      widget.currentIndex = Random().nextInt(widget.audioUrls.length);
    } else {
      if (widget.currentIndex < widget.audioUrls.length - 1) {
        widget.currentIndex++;
      } else {
        widget.currentIndex = 0;
      }
    }
    audioPlayer.setSource(AssetSource(widget.audioUrls[widget.currentIndex].path));
    audioPlayer.seek(Duration.zero);
    if (isPlaying) {
      audioPlayer.play(AssetSource(widget.audioUrls[widget.currentIndex].path));
    }
  }

  void skipPrevious() {
    if (isRandom) {
      widget.currentIndex = Random().nextInt(widget.audioUrls.length);
    } else {
      if (widget.currentIndex > 0) {
        widget.currentIndex--;
      } else {
        widget.currentIndex = widget.audioUrls.length - 1;
      }
    }
    audioPlayer.setSource(AssetSource(widget.audioUrls[widget.currentIndex].path));
    audioPlayer.seek(Duration.zero);
    if (isPlaying) {
      audioPlayer.play(AssetSource(widget.audioUrls[widget.currentIndex].path));
    }
  }

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f3ed),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: Color(0xff017a0b),
            ),
          ),
        ],
        title: Column(
          children: [
            Text(widget.audioUrls[widget.currentIndex].audioName),
            Text(widget.audioUrls[widget.currentIndex].speakerName),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff4f3ed),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/video_img_fake.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.audioUrls[widget.currentIndex].audioName,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.audioUrls[widget.currentIndex].speakerName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xe4017a0b),
              ),
            ),
          ),
          Slider(
            activeColor: Color(0xff017a0b),
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
                final position = Duration(
                    milliseconds: (_duration.inMilliseconds * value).toInt());
                audioPlayer.seek(position);
              });
            },
          ),
          Text(
              "${_position.toString().split('.').first}/${_duration.toString().split('.').first}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: isRandom ? Color(0xff017a0b) : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isRandom = !isRandom;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Color(0xff017a0b),
                ),
                onPressed: skipPrevious,
              ),
              TextButton(
                onPressed: playPause,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  color: Color(0xff017a0b),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Color(0xff017a0b),
                ),
                onPressed: skipNext,
              ),
              IconButton(
                icon: Icon(
                  isRepeat ? Icons.repeat_one : Icons.repeat,
                  color: Color(0xff017a0b),
                ),
                onPressed: toggleRepeat,
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
