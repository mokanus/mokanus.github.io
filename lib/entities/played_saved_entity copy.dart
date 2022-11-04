import 'dart:convert';

class AudioSavedData {
  AudioSavedData({
    required this.hour,
    required this.minu,
    required this.second,
    required this.index,
    required this.album,
  });

  int index;
  String album;
  int hour;
  int minu;
  int second;

  factory AudioSavedData.fromJson(Map<String, dynamic> json) => AudioSavedData(
        hour: json["hour"],
        minu: json["minu"],
        second: json["second"],
        index: json["index"],
        album: json["album"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minu": minu,
        "second": second,
        "index": index,
        "album": album,
      };
}

AudioSavedData fromJson(String str) =>
    AudioSavedData.fromJson(json.decode(str));

String toJson(AudioSavedData data) => json.encode(data.toJson());
