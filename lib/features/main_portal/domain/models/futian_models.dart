/// Canonical 7-status enum matching backend STATUS_MAP in futian.routes.ts
enum FutianOrderStatus {
  underReview,
  pricePending,
  approvalPending,
  purchased,
  shipped,
  arrived,
  cancelled,
}

extension FutianOrderStatusX on FutianOrderStatus {
  String get backendKey {
    switch (this) {
      case FutianOrderStatus.underReview:
        return 'UNDER_REVIEW';
      case FutianOrderStatus.pricePending:
        return 'PRICE_PENDING';
      case FutianOrderStatus.approvalPending:
        return 'APPROVAL_PENDING';
      case FutianOrderStatus.purchased:
        return 'PURCHASED';
      case FutianOrderStatus.shipped:
        return 'SHIPPED';
      case FutianOrderStatus.arrived:
        return 'ARRIVED';
      case FutianOrderStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static FutianOrderStatus fromBackend(String raw) {
    switch (raw.toUpperCase()) {
      case 'PRICE_PENDING':
        return FutianOrderStatus.pricePending;
      case 'APPROVAL_PENDING':
        return FutianOrderStatus.approvalPending;
      case 'PURCHASED':
        return FutianOrderStatus.purchased;
      case 'SHIPPED':
        return FutianOrderStatus.shipped;
      case 'ARRIVED':
        return FutianOrderStatus.arrived;
      case 'CANCELLED':
        return FutianOrderStatus.cancelled;
      default:
        return FutianOrderStatus.underReview;
    }
  }
}

class FutianOrderItem {
  final String id;
  final String orderId;
  final String productNameAr;
  final String productNameEn;
  final String siteNameAr;
  final String siteNameEn;
  final String siteType;
  final int quantity;
  final FutianOrderStatus status;
  final String statusAr;
  final String statusEn;
  final String statusColorHex;
  final String statusBgHex;
  final String? imageAsset;
  final String visualType;
  final double declaredValueUsd;
  final double unitPriceUsd;
  final double totalPriceUsd;
  final String createdAt;
  final String updatedAt;

  const FutianOrderItem({
    required this.id,
    required this.orderId,
    required this.productNameAr,
    required this.productNameEn,
    required this.siteNameAr,
    required this.siteNameEn,
    required this.siteType,
    required this.quantity,
    required this.status,
    required this.statusAr,
    required this.statusEn,
    required this.statusColorHex,
    required this.statusBgHex,
    this.imageAsset,
    required this.visualType,
    required this.declaredValueUsd,
    required this.unitPriceUsd,
    required this.totalPriceUsd,
    required this.createdAt,
    required this.updatedAt,
  });
}

class FutianOrderDetail extends FutianOrderItem {
  final String productUrl;
  final String destinationCountry;
  final String notes;
  final List<FutianStatusHistoryEntry> timeline;

  const FutianOrderDetail({
    required super.id,
    required super.orderId,
    required super.productNameAr,
    required super.productNameEn,
    required super.siteNameAr,
    required super.siteNameEn,
    required super.siteType,
    required super.quantity,
    required super.status,
    required super.statusAr,
    required super.statusEn,
    required super.statusColorHex,
    required super.statusBgHex,
    super.imageAsset,
    required super.visualType,
    required super.declaredValueUsd,
    required super.unitPriceUsd,
    required super.totalPriceUsd,
    required super.createdAt,
    required super.updatedAt,
    required this.productUrl,
    required this.destinationCountry,
    required this.notes,
    required this.timeline,
  });
}

class FutianStatusHistoryEntry {
  final String? fromStatus;
  final String toStatus;
  final String toStatusLabelEn;
  final String toStatusLabelAr;
  final String changedByName;
  final String notes;
  final String timestamp;

  const FutianStatusHistoryEntry({
    this.fromStatus,
    required this.toStatus,
    required this.toStatusLabelEn,
    required this.toStatusLabelAr,
    required this.changedByName,
    required this.notes,
    required this.timestamp,
  });
}

class FutianOrderMetrics {
  final int all;
  final int underReview;
  final int pricePending;
  final int approvalPending;
  final int purchased;
  final int shipped;
  final int arrived;
  final int cancelled;

  const FutianOrderMetrics({
    required this.all,
    required this.underReview,
    required this.pricePending,
    required this.approvalPending,
    required this.purchased,
    required this.shipped,
    required this.arrived,
    required this.cancelled,
  });
}

class FutianOrdersResponse {
  final FutianOrderMetrics metrics;
  final List<FutianOrderItem> orders;

  const FutianOrdersResponse({
    required this.metrics,
    required this.orders,
  });
}

class NewFutianOrderDraft {
  String productName = '';
  String productUrl = '';
  int quantity = 1;
  String destinationCountry = 'Libya';
  double declaredValueUsd = 0.0;
  String siteType = 'china'; // china | usa | turkey | shein
  String notes = '';

  bool get isValid => productName.trim().isNotEmpty && quantity > 0;
}
