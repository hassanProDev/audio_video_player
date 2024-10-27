import 'package:audio_video_player/model/video_model.dart';
import 'package:audio_video_player/view/video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoListPage extends StatelessWidget {
  VideoListPage({super.key});

  List<VideoModel> video = [
    VideoModel.fromData(),
    VideoModel.fromData(),
    VideoModel.fromData(),
    VideoModel.fromData(),
    VideoModel.fromData(),
    VideoModel.fromData(),
  ];

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
          "المرئيات",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            height: 2,
            color: Colors.black,
          );
        },
        itemCount: video.length,
        itemBuilder: (context, index) {
          // return Container();
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoScreen(video: video[index],)));
            },
            leading: Stack(
              children: [
                Image.asset(video[index].imagePath!),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Color(0x50dddddd)
                //   ),
                //   child: Icon(Icons.play_arrow),
                // ),
              ],
            ),
            title: Text(video[index].videoName),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(video[index].speakerName),
                Text(video[index].videoDuration)
              ],
            ),
          );
        },
      ),
    );
  }
}
