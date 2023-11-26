import 'package:tingfm/utils/global.dart';

class APIRouter {
  // static const String baseAPI =
  //     'https://tingfm-server-9991-4-1314189171.sh.run.tcloudbase.com';

  static const String baseAPI = 'http://43.163.244.7:8081';

  static const String debugBaseAPI = 'http://192.168.1.2:8081';

  static const String searchAPI = '/search_albums';
  static const String recommendAPI = '/recommend_albums';
  static const String albumInfoAPI = '/album_info';
  static const String classifiesAPI = '/album_classify';
  static const String lisByClassifyAPI = '/classified_albums';
  static const String feedbackAPI = '/feed_back';
  static const String albumBannerAPI = '/album_banners';

  static String router(String api) {
    if (Global.isRelease) {
      return baseAPI + api;
    }
    return debugBaseAPI + api;
  }
}
