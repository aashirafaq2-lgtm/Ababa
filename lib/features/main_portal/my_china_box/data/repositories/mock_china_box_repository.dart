import '../../domain/models/china_box_models.dart';
import 'china_box_repository.dart';

class MockChinaBoxRepository implements ChinaBoxRepository {
  static final MockChinaBoxRepository _instance =
      MockChinaBoxRepository._internal();
  factory MockChinaBoxRepository() => _instance;
  MockChinaBoxRepository._internal();

  // Reference Address in Yiwu
  final WarehouseAddress _address = const WarehouseAddress(
    titleEn: 'Your Warehouse in China',
    titleAr: 'عنوان مخزنك في الصين',
    addressEn:
        'Warehouse 3, No. 23, Banyuan Road, Yiwu City, Zhejiang Province, China 322000',
    addressAr:
        'المستودع 3، رقم 23، طريق بانيوان\nمدينة ييوو، مقاطعة تشيجيانغ، الصين\nYiwu, Zhejiang, China 322000',
    postalCode: '322000',
    mapUrl: 'https://maps.google.com/?q=29.3068,120.0754',
  );

  // Reference Packages extracted directly from user screenshot
  final List<WarehousePackageItem> _packages = [
    WarehousePackageItem(
      id: 'pkg_1',
      boxNumber: 'Box #240508-01',
      trackingNumber: 'YT243516789CN',
      dimensions: '60 × 40 × 35 cm',
      weightKg: 12.50,
      arrivalDate: '2024-05-20',
      status: PackageStatus.inWarehouse,
      isSelected: true,
    ),
    WarehousePackageItem(
      id: 'pkg_2',
      boxNumber: 'Box #240519-02',
      trackingNumber: 'YT243516890CN',
      dimensions: '50 × 30 × 30 cm',
      weightKg: 8.30,
      arrivalDate: '2024-05-19',
      status: PackageStatus.inWarehouse,
      isSelected: true,
    ),
    WarehousePackageItem(
      id: 'pkg_3',
      boxNumber: 'Box #240518-03',
      trackingNumber: 'YT243517001CN',
      dimensions: '70 × 50 × 40 cm',
      weightKg: 15.20,
      arrivalDate: '2024-05-18',
      status: PackageStatus.inWarehouse,
      isSelected: true,
    ),
    WarehousePackageItem(
      id: 'pkg_4',
      boxNumber: 'Box #240517-04',
      trackingNumber: 'YT243517112CN',
      dimensions: '45 × 35 × 25 cm',
      weightKg: 6.70,
      arrivalDate: '2024-05-17',
      status: PackageStatus.inWarehouse,
      isSelected: false,
    ),
    WarehousePackageItem(
      id: 'pkg_5',
      boxNumber: 'Box #240515-05',
      trackingNumber: 'YT243517223CN',
      dimensions: '30 × 25 × 20 cm',
      weightKg: 3.40,
      arrivalDate: '2024-05-15',
      status: PackageStatus.readyForConsolidation,
      isSelected: false,
    ),
  ];

  // Wholesale catalog items
  final List<WholesaleProductItem> _wholesaleItems = const [
    WholesaleProductItem(
      id: 'wh_1',
      titleEn: 'Smart Watch Ultra Pro Bluetooth Call',
      titleAr: 'ساعة ذكية ألترا برو مع اتصال بلوتوث',
      supplierName: 'Shenzhen Tech Star Electronics Ltd.',
      minOrderQty: 50,
      unitPriceUsd: 14.50,
      category: 'Consumer Electronics',
      inStock: 5000,
    ),
    WholesaleProductItem(
      id: 'wh_2',
      titleEn: 'Wireless ANC Noise-Cancelling Headphones',
      titleAr: 'سماعات رأس لاسلكية بخاصية عزل الضوضاء',
      supplierName: 'Guangdong Audio Acoustics Factory',
      minOrderQty: 100,
      unitPriceUsd: 11.20,
      category: 'Audio',
      inStock: 3200,
    ),
    WholesaleProductItem(
      id: 'wh_3',
      titleEn: 'Industrial High-Speed Laser Engraver',
      titleAr: 'ماكينة نقش بالليزر صناعية عالية السرعة',
      supplierName: 'Jinan Precision CNC Machinery Co.',
      minOrderQty: 5,
      unitPriceUsd: 480.00,
      category: 'Machinery',
      inStock: 120,
    ),
    WholesaleProductItem(
      id: 'wh_4',
      titleEn: 'Minimalist Nordic LED Desk Lamp',
      titleAr: 'مصباح مكتب ليد عصري بتصميم نورديك',
      supplierName: 'Zhongshan Lighting Craft Corp.',
      minOrderQty: 200,
      unitPriceUsd: 4.80,
      category: 'Home & Lighting',
      inStock: 8000,
    ),
  ];

  // Air vs Sea Shipping options
  final List<ShippingOption> _shippingOptions = const [
    ShippingOption(
      id: 'ship_air',
      type: ShippingTransitType.air,
      titleEn: 'Air Express Shipping',
      titleAr: 'شحن جوي سريع',
      subtitleEn: 'Fastest door-to-door transit via direct airline cargo',
      subtitleAr: 'أسرع شحن مباشر من الباب للباب عبر خطوط الشحن الجوي',
      estimatedDays: '3 - 5 Days',
      ratePerKg: 7.50,
      baseFee: 15.00,
    ),
    ShippingOption(
      id: 'ship_sea',
      type: ShippingTransitType.sea,
      titleEn: 'Sea Freight Shipping',
      titleAr: 'شحن بحري اقتصادي',
      subtitleEn: 'Economical bulk container shipping with customs clearance',
      subtitleAr: 'شحن حاويات بحري اقتصادي شامل التخليص الجمركي',
      estimatedDays: '18 - 25 Days',
      ratePerKg: 2.20,
      baseFee: 35.00,
    ),
  ];

  // Destination country options
  final List<DestinationCountryOption> _destinations = const [
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
    DestinationCountryOption(
      id: 'dest_shein',
      nameEn: 'SHEIN / Regional Logistics Hub',
      nameAr: 'مركز شي إن اللوجستي الإقليمي',
      flagEmoji: '📦',
      code: 'SHN',
    ),
  ];

  @override
  Future<List<WarehousePackageItem>> getPackages(
      {PackageStatus? statusFilter}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (statusFilter == null) return List.from(_packages);
    return _packages.where((p) => p.status == statusFilter).toList();
  }

  @override
  Future<WarehouseAddress> getWarehouseAddress() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _address;
  }

  @override
  Future<List<WholesaleProductItem>> getWholesaleProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_wholesaleItems);
  }

  @override
  Future<List<ShippingOption>> getShippingOptions(double weightKg) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_shippingOptions);
  }

  @override
  Future<ShipmentTrackingRecord> getTracking(String trackingNumber) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ShipmentTrackingRecord(
      trackingNumber: trackingNumber,
      orderId: 'MCB-2024-88912',
      statusEn: 'In Transit to Destination Airport',
      statusAr: 'قيد النقل إلى مطار الوجهة',
      shippingMethod: 'Air Express Cargo',
      weightKg: 36.00,
      totalCostUsd: 285.00,
      packageCount: 3,
      milestones: const [
        TrackingMilestone(
          titleEn: 'Order Created & Consolidate Requested',
          titleAr: 'تم إنشاء الطلب وطلب تجميع الشحنة',
          location: 'A.BABA System',
          timestamp: '2024-05-21 09:30',
          isCompleted: true,
        ),
        TrackingMilestone(
          titleEn: 'Packages Consolidated & Repackaged',
          titleAr: 'تم تجميع الطرود وإعادة التغليف الآمن',
          location: 'Yiwu Warehouse, China',
          timestamp: '2024-05-21 14:15',
          isCompleted: true,
        ),
        TrackingMilestone(
          titleEn: 'Customs Clearance Export Passed',
          titleAr: 'اجتياز التخليص الجمركي للتصدير بنجاح',
          location: 'Shanghai Pudong Int. Airport (PVG)',
          timestamp: '2024-05-22 18:00',
          isCompleted: true,
        ),
        TrackingMilestone(
          titleEn: 'Departed China Flight SV-982',
          titleAr: 'مغادرة الرحلة الجوية من الصين',
          location: 'In Flight',
          timestamp: '2024-05-23 02:45',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingMilestone(
          titleEn: 'Arrival at Destination Airport',
          titleAr: 'الوصول إلى مطار الوجهة والتخليص المحلي',
          location: 'Destination Customs',
          timestamp: 'Estimated: 2024-05-24',
          isCompleted: false,
        ),
        TrackingMilestone(
          titleEn: 'Out for Final Delivery',
          titleAr: 'خارج للتسليم النهائي إلى العنوان',
          location: 'Local Courier',
          timestamp: 'Estimated: 2024-05-25',
          isCompleted: false,
        ),
      ],
    );
  }

  @override
  Future<List<DestinationCountryOption>> getDestinationCountries() async {
    return List.from(_destinations);
  }

  @override
  Future<bool> authenticate({
    required String identity,
    required String password,
    required bool isSignUp,
    String? confirmPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identity.trim().isEmpty || password.trim().isEmpty) return false;
    if (isSignUp && (confirmPassword != password)) return false;
    return true;
  }

  @override
  Future<String> submitNewOrder(AddOrderDraft draft) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final newId =
        'BOX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    return newId;
  }
}
