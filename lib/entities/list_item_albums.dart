// To parse this JSON data, do
//
//     final coordinate = coordinateFromJson(jsonString);

import 'dart:convert';

class ListItemAlbumsEntity {
  ListItemAlbumsEntity({
    required this.listItemAlbums,
  });

  List<ListItemAlbum> listItemAlbums;

  factory ListItemAlbumsEntity.fromRawJson(String str) =>
      ListItemAlbumsEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListItemAlbumsEntity.fromJson(Map<String, dynamic> json) =>
      ListItemAlbumsEntity(
        listItemAlbums: List<ListItemAlbum>.from(
            json["list_item_albums"].map((x) => ListItemAlbum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list_item_albums":
            List<dynamic>.from(listItemAlbums.map((x) => x.toJson())),
      };
}

class ListItemAlbum {
  ListItemAlbum({
    required this.album,
    required this.artist,
    required this.artUri,
    required this.id,
    required this.title,
  });

  String album;
  String artist;
  String artUri;
  String id;
  String title;

  factory ListItemAlbum.fromRawJson(String str) =>
      ListItemAlbum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListItemAlbum.fromJson(Map<String, dynamic> json) => ListItemAlbum(
        album: json["album"],
        artist: json["artist"],
        artUri: json["artUri"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "album": album,
        "artist": artist,
        "artUri": artUri,
        "id": id,
        "title": title,
      };
}
