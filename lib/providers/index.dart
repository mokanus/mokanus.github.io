import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/classify.dart';
import 'package:tingfm/api/list_by_classify.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/classify.dart';
import 'package:tingfm/utils/functions.dart';

class IndexProvider with ChangeNotifier {
  // 加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  List<Classify> classifies = <Classify>[];
  Map<int, List<AlbumItem>> albums = <int, List<AlbumItem>>{};

  //获取当前专辑的数据
  flushData(BuildContext context) async {
    setApiRequestStatus(APIRequestStatus.loading);

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

        // ignore: use_build_context_synchronously
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
