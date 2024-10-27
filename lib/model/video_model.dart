class VideoModel {
  String speakerName;
  String path;
  String videoDuration;
  String videoName;
  String description;
  String? imagePath;

  VideoModel({
    required this.speakerName,
    required this.path,
    required this.videoDuration,
    required this.videoName,
    required this.description,
    this.imagePath,
  });

  factory VideoModel.fromData() {
    int videoSecond = 1222;
    int sec, hour, minute;
    hour = videoSecond ~/ 360;
    videoSecond %= 360;
    minute = videoSecond ~/ 60;
    sec = videoSecond % 60;

    return VideoModel(
      speakerName: "احمد محمد احمد علي محمد",
      path: "assets/Video_2024-05-03_162751.mp4",
      videoDuration: "${hour}:${minute}:${sec}",
      videoName: "سير وتراجم شهداء غزوة بدر",
      imagePath: "assets/video_img_fake.png",
      description:
          "غزوة بدر هي أولى المعارك الكبرى في الإسلام، وقعت في السنة الثانية من الهجرة بين المسلمين بقيادة النبي محمد صلى الله عليه وسلم وقريش بقيادة أبو جهل. كانت الغزوة نقطة تحول، حيث انطلق المسلمون من المدينة المنورة بهدف اعتراض قافلة تجارية لقريش ردًا على ممارساتها العدائية تجاه المسلمين. التقى الجيشان عند بئر بدر، ورغم تفوق قريش العددي، استطاع المسلمون الانتصار بفضل إيمانهم وشجاعتهم. كانت النتيجة هزيمة قريش ومقتل عدد من قادتها. أكدت غزوة بدر على قوة المسلمين وأظهرت أنهم أصبحوا قوة يُحسب لها حساب في شبه الجزيرة العربية.",
    );
  }
}
