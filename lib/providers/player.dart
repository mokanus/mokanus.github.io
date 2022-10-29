import 'package:flutter/material.dart';
import 'package:tingfm/api/album_info.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/functions.dart';

class PlayerProvider with ChangeNotifier {
  // 加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  late AlbumItem item;
  //获取当前专辑的数据
  getAlbumInfo(BuildContext context, int id) async {
    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {"id": id};

      var albumInfoRsp = await AlbumInfoAPI.getAlbumInfo(
        url: APIRouter.router(APIRouter.albumInfoAPI),
        params: params,
        context: context,
      );

      if (albumInfoRsp != null) {
        item = albumInfoRsp.data;
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
