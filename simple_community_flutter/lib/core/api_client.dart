import 'package:dio/dio.dart';
import 'package:simple_community_api/simple_community_api.dart';

import '../config/api_config.dart';

class ApiClient {
  late final Dio _dio;
  late final DefaultApi _api;

  ApiClient({String? baseUrl, String? accessToken}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    if (accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },
    ));
    _api = DefaultApi(_dio, standardSerializers);
  }

  void setAccessToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAccessToken() {
    _dio.options.headers.remove('Authorization');
  }

  DefaultApi get api => _api;
  Dio get dio => _dio;
}
