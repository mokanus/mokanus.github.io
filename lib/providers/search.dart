import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/api/search.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/utils/functions.dart';

class SearchProvider with ChangeNotifier {
  ///加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  List<AlbumItem> searchedAlbumnList = <AlbumItem>[];

  ///
  ///获取当前专辑的数据
  searchData(BuildContext context, String searchParams) async {
    ///开始搜索
    searchedAlbumnList.clear();

    setApiRequestStatus(APIRequestStatus.loading);

    try {
      Map<String, dynamic> params = {
        "album": searchParams,
      };

      var searchAlbumnResponseEntity = await SearchAPI.searchAlbums(
        url: APIRouter.searchAPI,
        params: params,
        context: context,
      );
      print(searchAlbumnResponseEntity);
      if (searchAlbumnResponseEntity != null &&
          searchAlbumnResponseEntity.data.isNotEmpty) {
        searchedAlbumnList.addAll(searchAlbumnResponseEntity.data);
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
