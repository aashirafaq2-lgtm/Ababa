import '../../domain/models/china_box_models.dart';

abstract class ChinaBoxRepository {
  Future<List<WarehousePackageItem>> getPackages({PackageStatus? statusFilter});
  Future<WarehouseAddress> getWarehouseAddress();
  Future<List<WholesaleProductItem>> getWholesaleProducts();
  Future<List<ShippingOption>> getShippingOptions(double weightKg);
  Future<ShipmentTrackingRecord> getTracking(String trackingNumber);
  Future<List<DestinationCountryOption>> getDestinationCountries();
  Future<bool> authenticate({
    required String identity,
    required String password,
    required bool isSignUp,
    String? confirmPassword,
  });
  Future<String> submitNewOrder(AddOrderDraft draft);
}
