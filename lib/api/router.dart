import 'package:tingfm/utils/global.dart';

class APIRouter {
  static const String baseAPI = 'http://tingfm.chiyustudio.com:8081';
  static const String debugBaseAPI = 'http://192.168.1.2:8081';

  static const String searchAPI = '/search_albums';
  static const String recommendAPI = '/recommend_albums';
  static const String recentAPI = '/recent_albums';
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
