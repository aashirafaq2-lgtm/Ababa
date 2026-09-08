import 'package:dio/dio.dart';
import '../../core/services/auth_token_service.dart';

/// Central Dio instance for My China Box & Futian APIs.
/// Base URL points to the Node.js backend running on port 5000.
class ChinaBoxApiClient {
  static const String baseUrl = 'http://72.62.50.86:5000/api/v1';

  static ChinaBoxApiClient? _instance;
  static ChinaBoxApiClient get instance =>
      _instance ??= ChinaBoxApiClient._();
  ChinaBoxApiClient._();

  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // ─── Auth Interceptor — inject Bearer token ────────────────────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthTokenService.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Surface 401 so callers can redirect to login
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => () {},
    ));

    return dio;
  }

  Dio get dio => _dio;
}
