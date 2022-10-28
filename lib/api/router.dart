class APIRouter {
  static const String baseAPI =
      "https://tingfm-9991-5-1314189171.sh.run.tcloudbase.com";

  static const String getAlbumList = 'http://8.136.136.220:8080/albums/list';
  static const String searchAPI = 'http://localhost:8080/api/v1/album/search';
  static const String recommendAPI = '/api/v1/album/recommend';

  static String router(String api) {
    return baseAPI + api;
  }
}
