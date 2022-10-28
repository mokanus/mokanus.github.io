import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/recommend.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/functions.dart';

class RecommendProvider with ChangeNotifier {
  ///加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  List<AlbumItem> recommendAlbumnList = <AlbumItem>[];

  ///
  ///获取当前专辑的数据
  getRecommendData(BuildContext context, int start, int len) async {
    ///开始搜索
    recommendAlbumnList.clear();

    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {
        "start": start,
        "len": len,
      };

      var recommendRsp = await RecommendAPI.recommendAlbums(
        url: APIRouter.router(APIRouter.recommendAPI),
        params: params,
        context: context,
      );
      if (recommendRsp != null && recommendRsp.data.isNotEmpty) {
        recommendAlbumnList.addAll(recommendRsp.data);
      }
    } catch (e) {
      checkError(e);
    }

    ///搜索完毕
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
