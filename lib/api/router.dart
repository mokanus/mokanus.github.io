class APIRouter {
  static const String LocalHost = "http://localhost:80";

  /// 获取列表
  static const String getAlbumList = 'http://8.136.136.220:8080/albums/list';

  /// 搜索API
  static const String Search = 'http://localhost:8080/api/v1/album/search';
  static const String Recommend =
      'http://localhost:8080/api/v1/album/recommend';
}
