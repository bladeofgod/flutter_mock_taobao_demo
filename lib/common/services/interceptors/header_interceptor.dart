import 'package:dio/dio.dart';

/**
 * header拦截器
 */

class HeaderInterceptors extends InterceptorsWrapper{


  @override
  onRequest(RequestOptions options) {
    // TODO: implement onRequest
    options.connectTimeout = 15000;
    return options;
  }
}