import 'package:isar/isar.dart';

part 'product_cache_model.g.dart';

@collection
class ProductCacheModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? productId;

  String? title;
  double? basePrice;
  String? thumbnail;
  String? supplierName;
  bool? isVerified;
  
  DateTime? lastUpdated;
}
