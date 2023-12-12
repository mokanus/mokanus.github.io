// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/recent.dart';
import 'package:tingfm/utils/http.dart';

class RecentlyAlbumsAPI {
  static Future<RecentAlbumsRsp?> recentlyAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return RecentAlbumsRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
