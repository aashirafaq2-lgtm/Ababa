import '../../domain/entities/product_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProductMatrix(String? productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final dynamic remoteDataSource; // Mocking for internal BLoC logic dependency

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductMatrix(String? productId) async {
    // Implementation would call datasource
    return const Right([]);
  }
}

class FetchTieredProducts {
  final ProductRepository repository;

  FetchTieredProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String? productId) async {
    return await repository.getProductMatrix(productId);
  }
}
