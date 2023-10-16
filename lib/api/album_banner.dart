// 专辑banner信息类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/album_banner.dart';
import 'package:tingfm/utils/http.dart';

class AlbumBannerAPI {
  static Future<AlbumBannerRsp?> albumBanners({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return AlbumBannerRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
