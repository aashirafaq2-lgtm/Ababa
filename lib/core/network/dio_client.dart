import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.options
      ..baseUrl = 'https://api.ahmedbaba.com/v1'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..responseType = ResponseType.json;

    _dio.interceptors.add(ForexCurrencyInterceptor());
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get instance => _dio;
}

class ForexCurrencyInterceptor extends Interceptor {
  // Static conversion rate (In production, this would be fetched from a dedicated Forex Service)
  static const double _cnyToUsdRate = 0.14; 

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      _processDataNode(data);
    } else if (data is List) {
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          _processDataNode(item);
        }
      }
    }

    super.onResponse(response, handler);
  }

  void _processDataNode(Map<String, dynamic> node) {
    // Intercept product-tier pricing strings and inject USD conversions
    // Expected patterns: "CNY 100.00", "¥ 500.00 - 1000.00"
    
    node.forEach((key, value) {
      if (value is String && (value.contains('CNY') || value.contains('¥'))) {
        final convertedValue = _convertCurrencyString(value);
        node['${key}_usd'] = convertedValue;
      } else if (value is Map<String, dynamic>) {
        _processDataNode(value);
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            _processDataNode(item);
          }
        }
      }
    });
  }

  String _convertCurrencyString(String original) {
    try {
      final numericPart = original.replaceAll(RegExp(r'[^0-9.]'), '');
      final price = double.tryParse(numericPart);
      
      if (price != null) {
        final usdPrice = price * _cnyToUsdRate;
        return 'USD ${usdPrice.toStringAsFixed(2)}';
      }
    } catch (_) {
      // Return original if conversion fails
    }
    return original;
  }
}
