import 'dart:convert';

import 'package:tingfm/utils/global.dart';

class AlbumBannerRsp {
  int code;
  String message;
  Data data;

  AlbumBannerRsp({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AlbumBannerRsp.fromJson(String str) =>
      AlbumBannerRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumBannerRsp.fromMap(Map<String, dynamic> json) => AlbumBannerRsp(
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  List<AlbumBannerItem> banners;

  Data({
    required this.banners,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        banners: List<AlbumBannerItem>.from(
            json["banners"].map((x) => AlbumBannerItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toMap())),
      };
}

class AlbumBannerItem {
  int id;
  int albumId;
  String album;
  String artUri;

  AlbumBannerItem({
    required this.id,
    required this.albumId,
    required this.album,
    required this.artUri,
  });

  factory AlbumBannerItem.fromJson(String str) =>
      AlbumBannerItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumBannerItem.fromMap(Map<String, dynamic> json) => AlbumBannerItem(
        id: json["id"],
        albumId: json["albumId"],
        album: json["album"],
        artUri: json["artUri"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "albumId": albumId,
        "album": album,
        "artUri": artUri,
      };

  String imageURL() {
    return "${Global.ossBannerPre}$artUri";
  }

  String cacheKey() {
    return imageURL();
  }
}
