// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/http.dart';

class RecommendAPI {
  static Future<AlbumRsp?> recommendAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return AlbumRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
