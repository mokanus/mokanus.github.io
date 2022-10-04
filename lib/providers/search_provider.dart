import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/api/search.dart';
import 'package:tingfm/entities/list_item_albums.dart';
import 'package:tingfm/utils/functions.dart';

class SearchProvider with ChangeNotifier {
  ///加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  List<ListItemAlbum> searchedAlbumnList = <ListItemAlbum>[];

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
        url: APIRouter.getSearchAlbum,
        params: params,
        context: context,
      );

      if (searchAlbumnResponseEntity != null &&
          searchAlbumnResponseEntity.listItemAlbums.isNotEmpty) {
        searchedAlbumnList.addAll(searchAlbumnResponseEntity.listItemAlbums);
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
