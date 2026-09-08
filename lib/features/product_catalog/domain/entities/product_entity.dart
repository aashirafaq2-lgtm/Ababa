import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String supplierId;
  final List<String> categoryPath;
  final List<WholesaleTierEntity> wholesaleTiers;
  final List<SkuNodeEntity> skus;

  const ProductEntity({
    required this.id,
    required this.supplierId,
    required this.categoryPath,
    required this.wholesaleTiers,
    required this.skus,
  });

  @override
  List<Object?> get props => [id, supplierId, categoryPath, wholesaleTiers, skus];
}

class WholesaleTierEntity extends Equatable {
  final int minQuantity;
  final int? maxQuantity;
  final double unitPriceCny;
  final String? convertedPriceUsd;

  const WholesaleTierEntity({
    required this.minQuantity,
    this.maxQuantity,
    required this.unitPriceCny,
    this.convertedPriceUsd,
  });

  @override
  List<Object?> get props => [minQuantity, maxQuantity, unitPriceCny, convertedPriceUsd];
}

class SkuNodeEntity extends Equatable {
  final String skuUuid;
  final Map<String, String> attributes;
  final int inventoryCount;

  const SkuNodeEntity({
    required this.skuUuid,
    required this.attributes,
    required this.inventoryCount,
  });

  @override
  List<Object?> get props => [skuUuid, attributes, inventoryCount];
}
