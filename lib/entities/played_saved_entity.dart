import 'dart:convert';

AudioPlayedSavedMeta audioPlayedSavedMetaFromJson(String str) =>
    AudioPlayedSavedMeta.fromJson(json.decode(str));

String audioPlayedSavedMetaToJson(AudioPlayedSavedMeta data) =>
    json.encode(data.toJson());

class AudioPlayedSavedMeta {
  AudioPlayedSavedMeta({
    required this.playedDurationHour,
    required this.playedDurationMinu,
    required this.playedDurationSecond,
    required this.playedIndex,
    required this.playedItemName,
  });

  int playedDurationHour;
  int playedDurationMinu;
  int playedDurationSecond;

  int playedIndex;
  String playedItemName;

  factory AudioPlayedSavedMeta.fromJson(Map<String, dynamic> json) =>
      AudioPlayedSavedMeta(
        playedDurationHour: json["played_duration_hour"],
        playedDurationMinu: json["played_duration_minu"],
        playedDurationSecond: json["played_duration_second"],
        playedIndex: json["played_index"],
        playedItemName: json["played_item_name"],
      );

  Map<String, dynamic> toJson() => {
        "played_duration_hour": playedDurationHour,
        "played_duration_minu": playedDurationMinu,
        "played_duration_second": playedDurationSecond,
        "played_index": playedIndex,
        "played_item_name": playedItemName,
      };
}
