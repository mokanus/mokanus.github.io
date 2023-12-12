import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/recent.dart';
import 'package:tingfm/api/recommend.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/functions.dart';

class RecentProvider with ChangeNotifier {
  ///加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  List<AlbumItem> recentAlbumnList = <AlbumItem>[];

  ///获取当前专辑的数据
  refreshRecentAlbumsData(BuildContext context, int offset, int limit) async {
    ///开始搜索
    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {
        "offset": offset,
        "limit": limit,
      };

      var recentlyAlbumsRsp = await RecentlyAlbumsAPI.recentlyAlbums(
        url: APIRouter.router(APIRouter.recentAPI),
        params: params,
        context: context,
      );
      if (recentlyAlbumsRsp != null &&
          recentlyAlbumsRsp.data.albums.isNotEmpty) {
        recentAlbumnList.clear();
        recentAlbumnList.addAll(recentlyAlbumsRsp.data.albums);
      }
    } catch (e) {
      checkError(e);
    }
    setApiRequestStatus(APIRequestStatus.loaded);
  }

  getRecentlyData(BuildContext context, int start, int len) async {
    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {
        "offset": start,
        "limit": len,
      };

      var recentlyRsp = await RecentlyAlbumsAPI.recentlyAlbums(
        url: APIRouter.router(APIRouter.recentAPI),
        params: params,
        context: context,
      );
      if (recentlyRsp != null && recentlyRsp.data.albums.isNotEmpty) {
        recentAlbumnList.addAll(recentlyRsp.data.albums);
      }
    } catch (e) {
      checkError(e);
    }

    setApiRequestStatus(APIRequestStatus.loaded);
  }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}
