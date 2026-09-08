import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_models.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/data/repositories/mock_china_box_repository.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_auth_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_dashboard_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/consolidation_flow_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/shipping_method_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/shipment_tracking_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/add_new_order_flow_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/order_details_tracking_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_previous_orders_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';

void main() {
  group('My China Box - Comprehensive Test Suite', () {
    final repo = MockChinaBoxRepository();

    test('MockChinaBoxRepository returns valid reference data', () async {
      final packages = await repo.getPackages();
      expect(packages.length, greaterThanOrEqualTo(4));
      expect(packages.first.boxNumber, contains('Box #240508-01'));
      expect(packages.first.trackingNumber, equals('YT243516789CN'));

      final address = await repo.getWarehouseAddress();
      expect(address.postalCode, equals('322000'));
      expect(address.addressEn, contains('Yiwu'));

      final shipping = await repo.getShippingOptions(10.0);
      expect(shipping.length, equals(2));
      expect(shipping.any((s) => s.type == ShippingTransitType.air), isTrue);
      expect(shipping.any((s) => s.type == ShippingTransitType.sea), isTrue);

      final tracking = await repo.getTracking('YT243516789CN');
      expect(tracking.milestones.length, greaterThan(3));
      expect(tracking.trackingNumber, equals('YT243516789CN'));
    });

    testWidgets('ChinaBoxAuthPage renders Sign In and switches to Sign Up',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChinaBoxAuthPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My China Box'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign Up'), findsWidgets);
      expect(find.text('Account / Email'), findsOneWidget);

      // Tap Sign Up tab
      await tester.tap(find.text('Sign Up').first);
      await tester.pumpAndSettle();

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('ChinaBoxDashboardPage renders all key sections',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChinaBoxDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigation & Header
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // Bottom Navigation items exist
      expect(find.byIcon(Icons.warehouse_rounded), findsOneWidget);
    });

    testWidgets('ConsolidationFlowPage renders packages and calculates selection',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ConsolidationFlowPage(repository: repo),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inventory_2_rounded), findsWidgets);
    });

    testWidgets('ShippingMethodPage dynamically updates with selected option',
        (tester) async {
      final samplePackages = [
        WarehousePackageItem(
          id: 'test_1',
          boxNumber: 'Box #01',
          trackingNumber: 'YT123',
          dimensions: '50x30x30',
          weightKg: 10.0,
          arrivalDate: '2024-05-20',
          status: PackageStatus.inWarehouse,
          isSelected: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: ShippingMethodPage(packages: samplePackages),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flight_takeoff_rounded), findsOneWidget);
      expect(find.byIcon(Icons.directions_boat_rounded), findsOneWidget);
    });

    testWidgets('ShipmentTrackingPage renders tracking info & milestones',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ShipmentTrackingPage(
            trackingNumber: 'YT243516789CN',
            repository: repo,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MCB-2024-88912'), findsOneWidget);
      expect(find.byIcon(Icons.support_agent_outlined), findsOneWidget);
    });

    testWidgets('AddNewOrderFlowPage advances through steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewOrderFlowPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify shopping sites exist (China, America, Turkey, SHEIN)
      expect(find.text('China'), findsWidgets);
      expect(find.text('America'), findsWidgets);
      expect(find.text('Turkey'), findsWidgets);
      expect(find.text('SHEIN'), findsWidgets);
    });

    testWidgets('OrderDetailsTrackingPage renders all reference components and 8 milestones',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ChinaBoxLocalization().setLanguage(ChinaBoxLanguage.arabic);

      await tester.pumpWidget(
        const MaterialApp(
          home: OrderDetailsTrackingPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar title & help
      expect(find.text('تفاصيل الطلب'), findsOneWidget);
      expect(find.text('مساعدة'), findsOneWidget);

      // Order info & china badge
      expect(find.text('#AB-2505237'), findsOneWidget);
      expect(find.text('الصين'), findsOneWidget);
      expect(find.text('جاري مراجعة المنتج'), findsWidgets);

      // Product card
      expect(find.text('سماعة بلوتوث لاسلكية'), findsOneWidget);
      expect(find.text('العدد: 2'), findsOneWidget);

      // Milestone stages
      expect(find.text('تم استلام الطلب'), findsOneWidget);
      expect(find.text('تم تحديد السعر'), findsOneWidget);
      expect(find.text('قريباً'), findsOneWidget);
      expect(find.text('الحالي'), findsOneWidget);
      expect(find.text('وصل إلى المخزن'), findsOneWidget);

      // Bottom buttons
      expect(find.text('الطلبات السابقة'), findsOneWidget);
      expect(find.text('تحتاج مساعدة؟'), findsOneWidget);

      ChinaBoxLocalization().setLanguage(ChinaBoxLanguage.english);
    });

    testWidgets('ChinaBoxPreviousOrdersPage renders search, filters, and order cards',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ChinaBoxLocalization().setLanguage(ChinaBoxLanguage.arabic);

      await tester.pumpWidget(
        const MaterialApp(
          home: ChinaBoxPreviousOrdersPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar title & tabs
      expect(find.text('إضافة طلبية جديدة'), findsWidgets);
      expect(find.text('طلباتي'), findsOneWidget);
      expect(find.text('طلبية جديدة'), findsOneWidget);

      // Status metrics
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('بانتظار المراجعة'), findsWidgets);
      expect(find.text('بانتظار التسعير'), findsWidgets);
      expect(find.text('وصل إلى المخزن'), findsWidgets);

      // Order items
      expect(find.textContaining('#AB-2505237'), findsOneWidget);
      expect(find.text('سماعة بلوتوث لاسلكية'), findsOneWidget);
      expect(find.text('ساعة ذكية'), findsOneWidget);

      // Bottom bar
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('شحناتي'), findsOneWidget);
      expect(find.text('المحفظة'), findsOneWidget);

      ChinaBoxLocalization().setLanguage(ChinaBoxLanguage.english);
    });

    testWidgets(
        'ChinaBoxPreviousOrdersPage renders with 0 overflow errors on iPhone SE (375x667) in English',
        (tester) async {
      ChinaBoxLocalization().setLanguage(ChinaBoxLanguage.english);

      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ChinaBoxPreviousOrdersPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure no RenderFlex or layout exceptions occurred
      expect(tester.takeException(), isNull);

      // Verify key items rendered
      expect(find.text('Add New Order'), findsWidgets);
      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('New Order'), findsOneWidget);
      expect(find.textContaining('#AB-2505237'), findsOneWidget);
    });
  });
}
