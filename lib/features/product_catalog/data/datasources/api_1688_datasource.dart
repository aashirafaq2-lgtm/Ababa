import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/failures.dart';
import '../models/product_matrix_model.dart';

abstract class Api1688DataSource {
  Future<ProductMatrixModel> getProductDetails(String productId);
}

class Api1688DataSourceImpl implements Api1688DataSource {
  final DioClient client;

  Api1688DataSourceImpl({required this.client});

  @override
  Future<ProductMatrixModel> getProductDetails(String productId) async {
    try {
      final response = await client.instance.get(
        '/products/$productId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-Sourcing-Mode': 'wholesale',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductMatrixModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerFailure('Unrecognized status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timed out. Please check your global routing.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const AuthenticationFailure();
        } else if (statusCode == 429) {
          return const SourcingLimitFailure();
        }
        return ServerFailure('Server returned error: $statusCode');
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled by the system.');
      default:
        return const NetworkFailure();
    }
  }
}
