import 'package:dio/dio.dart';
import '../../../../core/network/china_box_api_client.dart';
import '../../domain/models/futian_models.dart';

/// Real API-backed repository for the Futian Purchases module.
/// All data fetched from /api/v1/futian/* on the Node.js backend.
class ApiFutianRepository {
  ApiFutianRepository._();
  static final ApiFutianRepository instance = ApiFutianRepository._();

  Dio get _dio => ChinaBoxApiClient.instance.dio;

  // ─────────────────────────────────────────────────────────────────────────
  // GET ORDERS LIST (with metrics + optional status/search filter)
  // ─────────────────────────────────────────────────────────────────────────

  Future<FutianOrdersResponse> getOrders({
    FutianOrderStatus? statusFilter,
    String? searchQuery,
  }) async {
    try {
      final qp = <String, dynamic>{};
      if (statusFilter != null) qp['status'] = statusFilter.backendKey;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        qp['q'] = searchQuery.trim();
      }

      final res = await _dio.get('/futian/orders', queryParameters: qp);
      final body = res.data as Map<String, dynamic>;

      final rawMetrics = body['metrics'] as Map<String, dynamic>? ?? {};
      final metrics = FutianOrderMetrics(
        all: (rawMetrics['all'] as num?)?.toInt() ?? 0,
        underReview: (rawMetrics['underReview'] as num?)?.toInt() ?? 0,
        pricePending: (rawMetrics['pricePending'] as num?)?.toInt() ?? 0,
        approvalPending: (rawMetrics['approvalPending'] as num?)?.toInt() ?? 0,
        purchased: (rawMetrics['purchased'] as num?)?.toInt() ?? 0,
        shipped: (rawMetrics['shipped'] as num?)?.toInt() ?? 0,
        arrived: (rawMetrics['arrived'] as num?)?.toInt() ?? 0,
        cancelled: (rawMetrics['cancelled'] as num?)?.toInt() ?? 0,
      );

      final rawOrders = (body['orders'] as List? ?? [])
          .cast<Map<String, dynamic>>();

      final orders = rawOrders.map(_parseOrderItem).toList();

      return FutianOrdersResponse(metrics: metrics, orders: orders);
    } catch (_) {
      return const FutianOrdersResponse(
        metrics: FutianOrderMetrics(
          all: 0,
          underReview: 0,
          pricePending: 0,
          approvalPending: 0,
          purchased: 0,
          shipped: 0,
          arrived: 0,
          cancelled: 0,
        ),
        orders: [],
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GET SINGLE ORDER DETAIL + STATUS TIMELINE
  // ─────────────────────────────────────────────────────────────────────────

  Future<FutianOrderDetail?> getOrderDetail(String orderId) async {
    try {
      final res = await _dio
          .get('/futian/orders/${Uri.encodeComponent(orderId)}');
      final d = res.data as Map<String, dynamic>;

      final rawTimeline = (d['timeline'] as List? ?? [])
          .cast<Map<String, dynamic>>();

      return FutianOrderDetail(
        id: d['id'] ?? '',
        orderId: d['orderId'] ?? orderId,
        productNameAr: d['productNameAr'] ?? '',
        productNameEn: d['productNameEn'] ?? '',
        productUrl: d['productUrl'] ?? '',
        siteNameAr: d['siteNameAr'] ?? '',
        siteNameEn: d['siteNameEn'] ?? '',
        siteType: d['siteType'] ?? 'china',
        quantity: (d['quantity'] as num?)?.toInt() ?? 1,
        destinationCountry: d['destinationCountry'] ?? '',
        status: FutianOrderStatusX.fromBackend(d['status'] ?? ''),
        statusAr: d['statusAr'] ?? '',
        statusEn: d['statusEn'] ?? '',
        statusColorHex: d['statusColorHex'] ?? '#FF5500',
        statusBgHex: d['statusBgHex'] ?? '#FFF1EB',
        visualType: d['visualType'] ?? 'general',
        declaredValueUsd:
            (d['declaredValueUsd'] as num?)?.toDouble() ?? 0.0,
        unitPriceUsd: (d['unitPriceUsd'] as num?)?.toDouble() ?? 0.0,
        totalPriceUsd: (d['totalPriceUsd'] as num?)?.toDouble() ?? 0.0,
        notes: d['notes'] ?? '',
        createdAt: d['createdAt'] ?? '',
        updatedAt: d['updatedAt'] ?? '',
        timeline: rawTimeline
            .map((t) => FutianStatusHistoryEntry(
                  fromStatus: t['fromStatus'] as String?,
                  toStatus: t['toStatus'] ?? '',
                  toStatusLabelEn: t['toStatusLabelEn'] ?? '',
                  toStatusLabelAr: t['toStatusLabelAr'] ?? '',
                  changedByName: t['changedByName'] ?? '',
                  notes: t['notes'] ?? '',
                  timestamp: t['timestamp'] ?? '',
                ))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUBMIT NEW ORDER
  // ─────────────────────────────────────────────────────────────────────────

  Future<({bool success, String orderId, String? error})> submitOrder(
      NewFutianOrderDraft draft) async {
    try {
      final res = await _dio.post('/futian/orders', data: {
        'productName': draft.productName.trim(),
        'productUrl': draft.productUrl.trim(),
        'quantity': draft.quantity,
        'destinationCountry': draft.destinationCountry,
        'declaredValueUsd': draft.declaredValueUsd,
        'siteType': draft.siteType,
        'notes': draft.notes.trim(),
      });
      final body = res.data as Map<String, dynamic>;
      final order = body['order'] as Map<String, dynamic>? ?? {};
      return (
        success: true,
        orderId: order['order_id']?.toString() ?? '#AB-???',
        error: null
      );
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['error'] as String? ??
          'Submission failed. Please try again.';
      return (success: false, orderId: '', error: msg);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // APPROVE PRICING (customer action)
  // ─────────────────────────────────────────────────────────────────────────

  Future<bool> approveOrderPricing(String orderId) async {
    try {
      await _dio.patch(
          '/futian/orders/${Uri.encodeComponent(orderId)}/approve');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> createOrder(NewFutianOrderDraft draft) async {
    final res = await submitOrder(draft);
    return res.success ? res.orderId : null;
  }

  Future<bool> approvePrice(String orderId) => approveOrderPricing(orderId);

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  FutianOrderItem _parseOrderItem(Map<String, dynamic> d) {
    return FutianOrderItem(
      id: d['id'] ?? '',
      orderId: d['orderId'] ?? '',
      productNameAr: d['productNameAr'] ?? '',
      productNameEn: d['productNameEn'] ?? '',
      siteNameAr: d['siteNameAr'] ?? '',
      siteNameEn: d['siteNameEn'] ?? '',
      siteType: d['siteType'] ?? 'china',
      quantity: (d['quantity'] as num?)?.toInt() ?? 1,
      status: FutianOrderStatusX.fromBackend(d['status'] ?? ''),
      statusAr: d['statusAr'] ?? '',
      statusEn: d['statusEn'] ?? '',
      statusColorHex: d['statusColorHex'] ?? '#FF5500',
      statusBgHex: d['statusBgHex'] ?? '#FFF1EB',
      imageAsset: d['imageAsset'] as String?,
      visualType: d['visualType'] ?? 'general',
      declaredValueUsd:
          (d['declaredValueUsd'] as num?)?.toDouble() ?? 0.0,
      unitPriceUsd: (d['unitPriceUsd'] as num?)?.toDouble() ?? 0.0,
      totalPriceUsd: (d['totalPriceUsd'] as num?)?.toDouble() ?? 0.0,
      createdAt: d['createdAt'] ?? '',
      updatedAt: d['updatedAt'] ?? '',
    );
  }
}
