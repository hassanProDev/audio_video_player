class AudioModel {
  String speakerName;
  String path;
  String audioDuration;
  String audioName;

  AudioModel({
    required this.speakerName,
    required this.path,
    required this.audioDuration,
    required this.audioName,
  });

  factory AudioModel.fromData() {
    int audioSecond = 1222;
    int sec, hour, minute;
    hour = audioSecond ~/ 360;
    audioSecond %= 360;
    minute = audioSecond ~/ 60;
    sec = audioSecond % 60;

    return AudioModel(
      speakerName: "احمد علي محمد محمد",
      path: "ambient_c_motion.mp3",
      audioDuration: "${hour}:${minute}:${sec}",
      audioName: "تفسير سورة البقرة",
    );
  }
}
