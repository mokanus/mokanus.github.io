import 'package:dio/dio.dart';

late Dio dio;

class HttpUtil {
  static HttpUtil get instance => _getInstance();
  static HttpUtil? _httpUtil;
  static HttpUtil _getInstance() {
    return _httpUtil ?? HttpUtil();
  }

  getHeader() {
    return {
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': "*",
      'User-Aagent': "4.1.0;android;6.0.1;default;A001",
      "HZUID": "2",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": true
    };
  }

  HttpUtil() {
    dio = Dio();
    dio.options
      ..baseUrl = "127.0.0.1"
      ..sendTimeout = 5000
      ..receiveTimeout = 5000
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = getHeader();
  }

  Future get(String url,
      {Map<String, dynamic>? parameters, Options? options}) async {
    Response response;
    if (parameters != null && options != null) {
      response =
          await dio.get(url, queryParameters: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.get(url, queryParameters: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.get(url, options: options);
    } else {
      response = await dio.get(url);
    }
    return response;
  }

  ///post
  Future post(String url,
      {required Map<String, dynamic>? parameters, Options? options}) async {
    Response response;
    if (parameters != null && options != null) {
      response = await dio.post(url, data: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.post(url, data: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.post(url, options: options);
    } else {
      response = await dio.post(url);
    }
    return response;
  }

  ///表单请求
  Future postFormData(String url,
      {required FormData? parameters, Options? options}) async {
    Response response;
    if (parameters != null && options != null) {
      response = await dio.post(url, data: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.post(url, data: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.post(url, options: options);
    } else {
      response = await dio.post(url);
    }
    return response;
  }
}
