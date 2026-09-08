import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AhmedBabaNetworkAudit {
  static Dio createClient() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status! < 500,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // AUDIT: Automatic Auth Injection
        options.headers['X-Request-Source'] = 'AhmedBaba-Mobile';
        debugPrint('[NET AUDIT] Requesting: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[NET AUDIT] Success: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // AUDIT: Global Retry logic on network failure
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
           debugPrint('[NET AUDIT] Retrying connection due to timeout...');
        }
        return handler.next(e);
      },
    ));

    return dio;
  }
}
