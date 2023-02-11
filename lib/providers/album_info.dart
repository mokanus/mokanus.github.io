import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/api/album_info.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/album_meta.dart';
import 'package:tingfm/utils/functions.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class AlbumInfoProvider with ChangeNotifier {
  // 加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  AlbumItem? item;
  AlbumMeta? historyMeta;
  bool readyFavorate = false;

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

    await flushHistoryMeta();
    await flushFavorateState();

    setApiRequestStatus(APIRequestStatus.loaded);
  }

  Future<void> flushHistoryMeta() async {
    if (item != null) {
      var metaBox = await Hive.openBox(HiveBoxes.albumMetaDB);
      var metaData = metaBox.get('album_${item?.album}');
      if (metaData != null) {
        historyMeta = AlbumMeta.fromJson(metaData.toString());
      }
    }
  }

  Future<void> flushFavorateState() async {
    var favorateBox = await Hive.openBox<AlbumItemDB>(HiveBoxes.favorateDB);
    var allFavorites = favorateBox.keys;
    readyFavorate = allFavorites.any((element) => element == item!.album);
  }

  String getAlbumMetaInfo() {
    if (historyMeta == null) {
      return "";
    } else {
      return "播放到 : ${historyMeta?.title}";
    }
  }

  String getDuration() {
    if (historyMeta == null) {
      return "";
    } else {
      return "播放到 : ${historyMeta?.hour}:${historyMeta?.minu}:${historyMeta?.second}";
    }
  }

  bool isPlayed() {
    return historyMeta != null;
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
