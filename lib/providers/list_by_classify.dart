import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/list_by_classify.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/functions.dart';

class ListByClassifyProvider with ChangeNotifier {
  ///加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  List<AlbumItem> albumList = <AlbumItem>[];

  ///获取当前专辑的数据
  refreshAlbumsByClassify(
      BuildContext context, int classify, int offset, int limit) async {
    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {
        "classify": classify,
        "offset": offset,
        "limit": limit,
      };

      var listByClassifyRsp = await ListByClassifyAPI.getAlbumsByClassify(
        url: APIRouter.router(APIRouter.lisByClassifyAPI),
        params: params,
        context: context,
      );
      if (listByClassifyRsp != null &&
          listByClassifyRsp.data.albums.isNotEmpty) {
        albumList.clear();
        albumList.addAll(listByClassifyRsp.data.albums);
      }
    } catch (e) {
      checkError(e);
    }

    ///搜索完毕
    setApiRequestStatus(APIRequestStatus.loaded);
  }

  ///获取当前专辑的数据
  getAlbumsByClassify(
      BuildContext context, int classify, int offset, int limit) async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      Map<String, dynamic> params = {
        "classify": classify,
        "offset": offset,
        "limit": limit,
      };

      var listByClassifyRsp = await ListByClassifyAPI.getAlbumsByClassify(
        url: APIRouter.router(APIRouter.lisByClassifyAPI),
        params: params,
        context: context,
      );
      if (listByClassifyRsp != null &&
          listByClassifyRsp.data.albums.isNotEmpty) {
        albumList.addAll(listByClassifyRsp.data.albums);
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
