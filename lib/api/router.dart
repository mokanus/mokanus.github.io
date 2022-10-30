import 'package:tingfm/global/global.dart';

class APIRouter {
  static const String baseAPI =
      "https://tingfm-9991-5-1314189171.sh.run.tcloudbase.com";

  static const String debugBaseAPI = "http://127.0.0.1:80";

  static const String searchAPI = '/api/v1/album/search';
  static const String recommendAPI = '/api/v1/album/recommend';
  static const String albumInfoAPI = '/api/v1/album/album_info';
  static const String classifiesAPI = '/api/v1/album/classify';
  static const String lisByClassifyAPI = '/api/v1/album/list_by_classify';

  static String router(String api) {
    if (Global.isRelease) {
      return baseAPI + api;
    }
    return debugBaseAPI + api;
  }
}
