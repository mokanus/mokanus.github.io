import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/api/classify.dart';
import 'package:tingfm/api/router.dart';
import 'package:tingfm/entities/classify.dart';
import 'package:tingfm/utils/functions.dart';

class ClassifyProvider with ChangeNotifier {
  // 加载状态码
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  List<Classify> classifies = <Classify>[];
  //获取当前专辑的数据
  getClassifies(BuildContext context) async {
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
