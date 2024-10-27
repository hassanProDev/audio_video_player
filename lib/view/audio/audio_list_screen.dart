import 'package:audio_video_player/model/audio_model.dart';
import 'package:audio_video_player/view/audio/audio_screen.dart';
import 'package:flutter/material.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f3ed),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xff017a0b),
                Color(0xff013a05),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "الصوتيات",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, index) {
          AudioModel audio = AudioModel.fromData();
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AudioScreen(audioUrls: [
                  audio,
                  audio,
                  audio,
                  audio,
                ], currentIndex: index);
              }));
            },
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 3,
                  color: Color(0xff017a0b),
                ),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Color(0xff017a0b),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(audio.audioName),
                Text(audio.speakerName),
              ],
            ),
            trailing: Text(audio.audioDuration),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 2,
            color: Colors.black12,
          );
        },
      ),
    );
  }
}
