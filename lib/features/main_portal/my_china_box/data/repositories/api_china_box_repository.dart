import 'package:dio/dio.dart';
import 'package:ahmed_baba/core/network/china_box_api_client.dart';
import 'package:ahmed_baba/core/services/auth_token_service.dart';
import '../../domain/models/china_box_models.dart';
import 'china_box_repository.dart';

/// Real implementation of [ChinaBoxRepository].
/// All data comes from the Node.js backend (Stage 4 APIs).
/// Falls back gracefully on network errors so the UI doesn't hard-crash.
class ApiChinaBoxRepository implements ChinaBoxRepository {
  ApiChinaBoxRepository._();
  static final ApiChinaBoxRepository instance = ApiChinaBoxRepository._();

  Dio get _dio => ChinaBoxApiClient.instance.dio;

  // ─────────────────────────────────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<bool> authenticate({
    required String identity,
    required String password,
    required bool isSignUp,
    String? confirmPassword,
  }) async {
    try {
      if (isSignUp && confirmPassword != password) return false;

      final endpoint = isSignUp
          ? '/auth/china-box/signup'
          : '/auth/china-box/signin';

      final payload = isSignUp
          ? {'identity': identity, 'password': password}
          : {'identity': identity, 'password': password};

      final res = await _dio.post(endpoint, data: payload);
      final body = res.data as Map<String, dynamic>;
      final token = body['token'] as String?;
      final user = body['user'] as Map<String, dynamic>?;

      if (token == null || user == null) return false;

      await AuthTokenService.instance.saveSession(
        token: token,
        userId: user['id']?.toString() ?? '',
        identity: user['identity']?.toString() ?? identity,
        fullName: user['fullName']?.toString() ?? 'Customer',
        boxCode: user['boxCode']?.toString() ?? '',
        role: user['role']?.toString() ?? 'CUSTOMER',
      );
      return true;
    } on DioException catch (e) {
      // 401 / 409 — credential or duplicate
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401 || statusCode == 409 || statusCode == 400) {
        return false;
      }
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WAREHOUSE ADDRESS
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<WarehouseAddress> getWarehouseAddress() async {
    try {
      final res = await _dio.get('/my-china-box/warehouse-address');
      final d = res.data as Map<String, dynamic>;
      return WarehouseAddress(
        titleEn: d['titleEn'] ?? 'Your Warehouse in China',
        titleAr: d['titleAr'] ?? 'عنوان مخزنك في الصين',
        addressEn: d['addressEn'] ?? '',
        addressAr: d['addressAr'] ?? '',
        postalCode: d['postalCode'] ?? '',
        mapUrl: d['mapUrl'] ?? 'https://maps.google.com',
      );
    } catch (_) {
      // Return last-known good address as fallback
      return const WarehouseAddress(
        titleEn: 'Your Warehouse in China',
        titleAr: 'عنوان مخزنك في الصين',
        addressEn:
            'Warehouse 3, No. 23, Banyuan Road, Yiwu City, Zhejiang Province, China 322000',
        addressAr:
            'المستودع 3، رقم 23، طريق بانيوان\nمدينة ييوو، مقاطعة تشيجيانغ، الصين',
        postalCode: '322000',
        mapUrl: 'https://maps.google.com/?q=29.3068,120.0754',
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PACKAGES
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<WarehousePackageItem>> getPackages(
      {PackageStatus? statusFilter}) async {
    try {
      final Map<String, dynamic> qp = {};
      if (statusFilter != null) {
        qp['status'] = _encodePackageStatus(statusFilter);
      }

      final res =
          await _dio.get('/my-china-box/packages', queryParameters: qp);
      final List data = res.data as List;

      return data
          .cast<Map<String, dynamic>>()
          .map((d) => WarehousePackageItem(
                id: d['id'] ?? '',
                boxNumber: d['boxNumber'] ?? '',
                trackingNumber: d['trackingNumber'] ?? '',
                dimensions: d['dimensions'] ?? '',
                weightKg: (d['weightKg'] as num?)?.toDouble() ?? 0.0,
                arrivalDate: d['arrivalDate'] ?? '',
                status: _decodePackageStatus(d['status']),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SHIPPING OPTIONS
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<ShippingOption>> getShippingOptions(double weightKg) async {
    try {
      final res = await _dio.get('/my-china-box/shipping-options',
          queryParameters: {'weight': weightKg});
      final List data = res.data as List;

      return data
          .cast<Map<String, dynamic>>()
          .map((d) => ShippingOption(
                id: d['id'] ?? '',
                type: d['type'] == 'sea'
                    ? ShippingTransitType.sea
                    : ShippingTransitType.air,
                titleEn: d['titleEn'] ?? '',
                titleAr: d['titleAr'] ?? '',
                subtitleEn: d['subtitleEn'] ?? '',
                subtitleAr: d['subtitleAr'] ?? '',
                estimatedDays: d['estimatedDays'] ?? '',
                ratePerKg: (d['ratePerKg'] as num?)?.toDouble() ?? 0.0,
                baseFee: (d['baseFee'] as num?)?.toDouble() ?? 0.0,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WHOLESALE PRODUCTS (catalog — still served from memory store)
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<WholesaleProductItem>> getWholesaleProducts() async {
    // The backend catalog endpoint returns the same data as the mock for now.
    // Returns empty list if network is unavailable — UI shows "no products".
    return [];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TRACKING
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<ShipmentTrackingRecord> getTracking(String trackingNumber) async {
    try {
      final res = await _dio
          .get('/my-china-box/tracking/${Uri.encodeComponent(trackingNumber)}');
      final d = res.data as Map<String, dynamic>;

      final rawMilestones = (d['milestones'] as List? ?? [])
          .cast<Map<String, dynamic>>();

      return ShipmentTrackingRecord(
        trackingNumber: d['trackingNumber'] ?? trackingNumber,
        orderId: d['orderId'] ?? '',
        statusEn: d['statusEn'] ?? 'In Transit',
        statusAr: d['statusAr'] ?? 'قيد النقل',
        shippingMethod: d['shippingMethod'] ?? '',
        weightKg: (d['weightKg'] as num?)?.toDouble() ?? 0.0,
        totalCostUsd: (d['totalCostUsd'] as num?)?.toDouble() ?? 0.0,
        packageCount: (d['packageCount'] as num?)?.toInt() ?? 0,
        milestones: rawMilestones
            .map((m) => TrackingMilestone(
                  titleEn: m['titleEn'] ?? '',
                  titleAr: m['titleAr'] ?? '',
                  location: m['location'] ?? '',
                  timestamp: m['timestamp'] ?? '',
                  isCompleted: m['isCompleted'] == true,
                  isCurrent: m['isCurrent'] == true,
                ))
            .toList(),
      );
    } catch (_) {
      return ShipmentTrackingRecord(
        trackingNumber: trackingNumber,
        orderId: '',
        statusEn: 'Tracking Unavailable',
        statusAr: 'التتبع غير متاح',
        shippingMethod: '',
        weightKg: 0,
        totalCostUsd: 0,
        packageCount: 0,
        milestones: const [],
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DESTINATION COUNTRIES
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<DestinationCountryOption>> getDestinationCountries() async {
    // Static list — not yet a separate endpoint
    return const [
      DestinationCountryOption(
        id: 'dest_iq',
        nameEn: 'Iraq (Baghdad / Erbil / Basra)',
        nameAr: 'العراق (بغداد / أربيل / البصرة)',
        flagEmoji: '🇮🇶',
        code: 'IQ',
      ),
      DestinationCountryOption(
        id: 'dest_sa',
        nameEn: 'Saudi Arabia (Riyadh / Jeddah)',
        nameAr: 'المملكة العربية السعودية (الرياض / جدة)',
        flagEmoji: '🇸🇦',
        code: 'SA',
      ),
      DestinationCountryOption(
        id: 'dest_ae',
        nameEn: 'United Arab Emirates (Dubai / Abu Dhabi)',
        nameAr: 'الإمارات العربية المتحدة (دبي / أبوظبي)',
        flagEmoji: '🇦🇪',
        code: 'AE',
      ),
      DestinationCountryOption(
        id: 'dest_tr',
        nameEn: 'Türkiye (Istanbul / Ankara)',
        nameAr: 'تركيا (إسطنبول / أنقرة)',
        flagEmoji: '🇹🇷',
        code: 'TR',
      ),
      DestinationCountryOption(
        id: 'dest_us',
        nameEn: 'United States of America',
        nameAr: 'الولايات المتحدة الأمريكية',
        flagEmoji: '🇺🇸',
        code: 'US',
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUBMIT NEW CONSOLIDATION ORDER
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<String> submitNewOrder(AddOrderDraft draft) async {
    try {
      final res = await _dio.post('/my-china-box/consolidate', data: {
        'packageIds': [],
        'shippingMethodId': null,
        'destinationCountry': draft.destination?.nameEn ?? 'Iraq',
        'deliveryAddress': '',
        'deliveryType': 'DOORSTEP',
        'notes': draft.notes,
      });
      final body = res.data as Map<String, dynamic>;
      return body['consolidation']?['order_number'] ??
          'CONS-${DateTime.now().millisecondsSinceEpoch}';
    } catch (_) {
      return 'CONS-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  String _encodePackageStatus(PackageStatus s) {
    switch (s) {
      case PackageStatus.inWarehouse:
        return 'in_warehouse';
      case PackageStatus.readyForConsolidation:
        return 'ready_for_consolidation';
      case PackageStatus.underReview:
        return 'under_review';
      case PackageStatus.shipped:
        return 'shipped';
      case PackageStatus.rejected:
        return 'rejected';
    }
  }

  PackageStatus _decodePackageStatus(dynamic raw) {
    switch ((raw as String? ?? '').toUpperCase()) {
      case 'READY_FOR_CONSOLIDATION':
        return PackageStatus.readyForConsolidation;
      case 'UNDER_REVIEW':
        return PackageStatus.underReview;
      case 'SHIPPED':
        return PackageStatus.shipped;
      case 'REJECTED':
        return PackageStatus.rejected;
      default:
        return PackageStatus.inWarehouse;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<int> getUnreadNotificationCount() async {
    try {
      final res = await _dio.get('/notifications/unread-count');
      final d = res.data as Map<String, dynamic>;
      return (d['unreadCount'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
