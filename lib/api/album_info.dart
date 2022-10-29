import 'package:flutter/material.dart';
import 'package:tingfm/entities/album_info.dart';
import 'package:tingfm/utils/http.dart';

class AlbumInfoAPI {
  static Future<AlbumInfoRsp?> getAlbumInfo({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return AlbumInfoRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
