import '../../domain/entities/product_entity.dart';

class ProductMatrixModel extends ProductEntity {
  const ProductMatrixModel({
    required super.id,
    required super.supplierId,
    required super.categoryPath,
    required super.wholesaleTiers,
    required super.skus,
  });

  factory ProductMatrixModel.fromJson(Map<String, dynamic> json) {
    return ProductMatrixModel(
      id: json['id'] as String,
      supplierId: json['supplier_id'] as String,
      categoryPath: List<String>.from(json['category_path'] as List),
      wholesaleTiers: (json['wholesale_tiers'] as List)
          .map((tier) => WholesaleTierModel.fromJson(tier as Map<String, dynamic>))
          .toList(),
      skus: (json['skus'] as List)
          .map((sku) => SkuNodeModel.fromJson(sku as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'category_path': categoryPath,
      'wholesale_tiers': wholesaleTiers
          .map((tier) => (tier as WholesaleTierModel).toJson())
          .toList(),
      'skus': skus.map((sku) => (sku as SkuNodeModel).toJson()).toList(),
    };
  }
}

class WholesaleTierModel extends WholesaleTierEntity {
  const WholesaleTierModel({
    required super.minQuantity,
    super.maxQuantity,
    required super.unitPriceCny,
    super.convertedPriceUsd,
  });

  factory WholesaleTierModel.fromJson(Map<String, dynamic> json) {
    return WholesaleTierModel(
      minQuantity: json['min_quantity'] as int,
      maxQuantity: json['max_quantity'] as int?,
      unitPriceCny: (json['unit_price_cny'] as num).toDouble(),
      convertedPriceUsd: json['unit_price_cny_usd'] as String?, // Injected by Interceptor
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_quantity': minQuantity,
      'max_quantity': maxQuantity,
      'unit_price_cny': unitPriceCny,
      'unit_price_cny_usd': convertedPriceUsd,
    };
  }
}

class SkuNodeModel extends SkuNodeEntity {
  const SkuNodeModel({
    required super.skuUuid,
    required super.attributes,
    required super.inventoryCount,
  });

  factory SkuNodeModel.fromJson(Map<String, dynamic> json) {
    return SkuNodeModel(
      skuUuid: json['sku_uuid'] as String,
      attributes: Map<String, String>.from(json['attributes'] as Map),
      inventoryCount: json['inventory_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku_uuid': skuUuid,
      'attributes': attributes,
      'inventory_count': inventoryCount,
    };
  }
}
