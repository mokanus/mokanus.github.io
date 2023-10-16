// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:tingfm/api/album_banner.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/classify.dart';
import 'package:tingfm/api/list_by_classify.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/album_banner.dart';
import 'package:tingfm/entities/classify.dart';
import 'package:tingfm/utils/functions.dart';

class IndexProvider with ChangeNotifier {
  // 加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  var classifies = <Classify>[];
  var albums = <int, List<AlbumItem>>{};
  var albumBanners = <AlbumBannerItem>[];

  //获取当前专辑的数据
  flushData(BuildContext context) async {
    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {};
      var bannerRsp = await AlbumBannerAPI.albumBanners(
        url: APIRouter.router(APIRouter.albumBannerAPI),
        context: context,
        params: params,
      );
      if (bannerRsp != null) {
        albumBanners.clear();
        albumBanners.addAll(bannerRsp.data.banners);
      }
    } catch (e) {
      checkError(e);
    }

    try {
      Map<String, dynamic> params = {};

      var classifyRsp = await ClassifyAPI.getClassifies(
        url: APIRouter.router(APIRouter.classifiesAPI),
        context: context,
        params: params,
      );
      if (classifyRsp != null) {
        classifies.clear();
        classifies.addAll(classifyRsp.data.classifies);
      }
    } catch (e) {
      checkError(e);
    }

    for (var classify in classifies) {
      try {
        Map<String, dynamic> params = {
          "classify": classify.id,
          "offset": 0,
          "limit": 10,
        };

        var listByClassifyRsp = await ListByClassifyAPI.getAlbumsByClassify(
          url: APIRouter.router(APIRouter.lisByClassifyAPI),
          params: params,
          context: context,
        );
        if (listByClassifyRsp != null &&
            listByClassifyRsp.data.albums.isNotEmpty) {
          albums[classify.id] = listByClassifyRsp.data.albums;
        }
      } catch (e) {
        checkError(e);
      }
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
