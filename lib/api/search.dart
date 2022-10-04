// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/list_item_albums.dart';
import 'package:tingfm/utils/http.dart';

class SearchAPI {
  static Future<ListItemAlbumsEntity?> searchAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return ListItemAlbumsEntity.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
