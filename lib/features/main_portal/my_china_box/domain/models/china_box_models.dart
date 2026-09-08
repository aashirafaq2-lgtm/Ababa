enum StorageServiceType { wholesale, consolidation }

enum PackageStatus {
  inWarehouse,
  readyForConsolidation,
  underReview,
  shipped,
  rejected,
}

class WarehousePackageItem {
  final String id;
  final String boxNumber;
  final String trackingNumber;
  final String dimensions; // e.g. "60 x 40 x 35 cm"
  final double weightKg;
  final String arrivalDate;
  final PackageStatus status;
  bool isSelected;

  WarehousePackageItem({
    required this.id,
    required this.boxNumber,
    required this.trackingNumber,
    required this.dimensions,
    required this.weightKg,
    required this.arrivalDate,
    required this.status,
    this.isSelected = false,
  });

  WarehousePackageItem copyWith({bool? isSelected}) {
    return WarehousePackageItem(
      id: id,
      boxNumber: boxNumber,
      trackingNumber: trackingNumber,
      dimensions: dimensions,
      weightKg: weightKg,
      arrivalDate: arrivalDate,
      status: status,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class WarehouseAddress {
  final String titleEn;
  final String titleAr;
  final String addressEn;
  final String addressAr;
  final String postalCode;
  final String mapUrl;

  const WarehouseAddress({
    required this.titleEn,
    required this.titleAr,
    required this.addressEn,
    required this.addressAr,
    required this.postalCode,
    required this.mapUrl,
  });
}

class WholesaleProductItem {
  final String id;
  final String titleEn;
  final String titleAr;
  final String supplierName;
  final int minOrderQty;
  final double unitPriceUsd;
  final String category;
  final int inStock;

  const WholesaleProductItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.supplierName,
    required this.minOrderQty,
    required this.unitPriceUsd,
    required this.category,
    required this.inStock,
  });
}

class WholesaleBatchItem {
  final String id;
  final String boxNumber;
  final String trackingNumber;
  final bool isAirAvailable;
  final bool isSeaAvailable;
  final double volumeCbm;
  final int cartonCount;
  final String receiptDateAr;
  final String receiptDateEn;
  final String imagePath;
  bool isSelected;

  WholesaleBatchItem({
    required this.id,
    required this.boxNumber,
    required this.trackingNumber,
    required this.isAirAvailable,
    required this.isSeaAvailable,
    required this.volumeCbm,
    required this.cartonCount,
    required this.receiptDateAr,
    required this.receiptDateEn,
    required this.imagePath,
    this.isSelected = false,
  });
}

enum ShippingTransitType { air, sea }

class ShippingOption {
  final String id;
  final ShippingTransitType type;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String estimatedDays;
  final double ratePerKg;
  final double baseFee;

  const ShippingOption({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.estimatedDays,
    required this.ratePerKg,
    required this.baseFee,
  });

  double calculateTotal(double weightKg) {
    return baseFee + (ratePerKg * weightKg);
  }
}

class TrackingMilestone {
  final String titleEn;
  final String titleAr;
  final String location;
  final String timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingMilestone({
    required this.titleEn,
    required this.titleAr,
    required this.location,
    required this.timestamp,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class ShipmentTrackingRecord {
  final String trackingNumber;
  final String orderId;
  final String statusEn;
  final String statusAr;
  final String shippingMethod;
  final double weightKg;
  final double totalCostUsd;
  final int packageCount;
  final List<TrackingMilestone> milestones;

  const ShipmentTrackingRecord({
    required this.trackingNumber,
    required this.orderId,
    required this.statusEn,
    required this.statusAr,
    required this.shippingMethod,
    required this.weightKg,
    required this.totalCostUsd,
    required this.packageCount,
    required this.milestones,
  });
}

class DestinationCountryOption {
  final String id;
  final String nameEn;
  final String nameAr;
  final String flagEmoji;
  final String code;

  const DestinationCountryOption({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.flagEmoji,
    required this.code,
  });
}

class AddOrderDraft {
  DestinationCountryOption? destination;
  String productName = '';
  String productUrlOrTracking = '';
  int quantity = 1;
  double declaredValueUsd = 0.0;
  bool photoInspection = true;
  bool bubbleWrapRepack = false;
  bool removeInvoices = true;
  bool customsInsurance = false;
  String notes = '';

  bool get isStep1Valid => destination != null;
  bool get isStep2Valid => productName.trim().isNotEmpty && quantity > 0;
}
