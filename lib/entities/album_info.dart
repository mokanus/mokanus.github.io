// To parse this JSON data, do
//
//     final coordinate = coordinateFromJson(jsonString);

import 'dart:convert';

class Coordinate {
  Coordinate({
    required this.album,
    required this.artist,
    required this.artUri,
    required this.mediaItems,
  });

  String album;
  String artist;
  String artUri;
  List<MediaItem> mediaItems;

  factory Coordinate.fromRawJson(String str) =>
      Coordinate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        album: json["album"],
        artist: json["artist"],
        artUri: json["artUri"],
        mediaItems: List<MediaItem>.from(
            json["media_items"].map((x) => MediaItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "album": album,
        "artist": artist,
        "artUri": artUri,
        "media_items": List<dynamic>.from(mediaItems.map((x) => x.toJson())),
      };
}

class MediaItem {
  MediaItem({
    required this.duration,
    required this.title,
    required this.url,
  });

  int duration;
  String title;
  String url;

  factory MediaItem.fromRawJson(String str) =>
      MediaItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
        duration: json["duration"],
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "title": title,
        "url": url,
      };
}
