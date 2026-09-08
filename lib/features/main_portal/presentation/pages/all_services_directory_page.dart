import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/splash/presentation/pages/splash_screen_viewport.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_dashboard_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/add_new_order_flow_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_previous_orders_page.dart';
import 'container_shipping_page.dart';
import 'customs_clearance_page.dart';
import 'product_sourcing_page.dart';
import 'china_travel_residency_page.dart';
import 'dispute_resolution_page.dart';
import 'trusted_seller_page.dart';
import 'service_coming_soon_page.dart';

class AllServicesDirectoryPage extends StatefulWidget {
  const AllServicesDirectoryPage({super.key});

  @override
  State<AllServicesDirectoryPage> createState() => _AllServicesDirectoryPageState();
}

class _AllServicesDirectoryPageState extends State<AllServicesDirectoryPage> {
  final _loc = ChinaBoxLocalization();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color _orange = Color(0xFFFF6B00);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (context, _) {
        final isRtl = _loc.isRtl;

        final allServices = [
          {
            'id': 1,
            'title': isRtl ? 'سوق علي بابا الصيني' : 'Chinese Alibaba Market',
            'desc': isRtl ? 'تصفح ملايين المنتجات من المصانع الصينية بأسعار الجملة' : 'Millions of wholesale factory products direct from China',
            'icon': Icons.storefront_rounded,
            'color': const Color(0xFFFF6B00),
            'page': const SplashViewport(),
          },
          {
            'id': 2,
            'title': isRtl ? 'صندوق الصين (My China Box)' : 'My China Box',
            'desc': isRtl ? 'إدارة شحناتك وتجميع الطرود وشحنها من مستودعنا في إيوا' : 'Virtual China address, parcel consolidation & air cargo',
            'icon': Icons.warehouse_rounded,
            'color': const Color(0xFF0284C7),
            'page': const ChinaBoxDashboardPage(),
          },
          {
            'id': 3,
            'title': isRtl ? 'شحن الحاويات البحرية (FCL/LCL)' : 'Container Ocean Freight',
            'desc': isRtl ? 'شحن بحري مباشر للحاويات 20 و40 قدم والشحن بالطن والمتر' : 'Full & partial container booking from China ports',
            'icon': Icons.directions_boat_rounded,
            'color': const Color(0xFF0284C7),
            'page': const ContainerShippingPage(),
          },
          {
            'id': 4,
            'title': isRtl ? 'التخليص الجمركي واستشارات سابر' : 'Customs Clearance & Saber',
            'desc': isRtl ? 'فسح جمركي شامل في الموانئ والمطارات وحساب الرسوم' : 'Port declaration, duty calculation & compliance',
            'icon': Icons.assignment_turned_in_rounded,
            'color': const Color(0xFF059669),
            'page': const CustomsClearancePage(),
          },
          {
            'id': 5,
            'title': isRtl ? 'إضافة طلب شراء جديد (فوتيان)' : 'Add New Order (Futian)',
            'desc': isRtl ? 'طلب شراء منتجات وعينات من أسواق فوتيان بالصين' : 'Order placement & purchasing from Yiwu Futian',
            'icon': Icons.add_shopping_cart_rounded,
            'color': const Color(0xFFEA580C),
            'page': const AddNewOrderFlowPage(),
          },
          {
            'id': 6,
            'title': isRtl ? 'البحث عن منتج معين وتوريده' : 'Product Sourcing Concierge',
            'desc': isRtl ? 'ابحث عن مصنع لأي منتج بالصورة والمواصفات بأقل سعر' : 'Find certified manufacturers by photo or link',
            'icon': Icons.search_rounded,
            'color': const Color(0xFF7C3AED),
            'page': const ProductSourcingPage(),
          },
          {
            'id': 7,
            'title': isRtl ? 'السفر والتأشيرات والإقامة' : 'China Travel & Business Visas',
            'desc': isRtl ? 'خطابات دعوة رسمية، حجز مترجم عربي، وفنادق في إيوا' : 'M-Visa invitations, bilingual market guides & hotel bookings',
            'icon': Icons.flight_takeoff_rounded,
            'color': const Color(0xFF4F46E5),
            'page': const ChinaTravelResidencyPage(),
          },
          {
            'id': 8,
            'title': isRtl ? 'المساعدة في حل المشكلات والنزاعات' : 'Problem Solving & Disputes',
            'desc': isRtl ? 'وساطة قانونية لحل النزاعات مع المصانع وتجميد الدفعات' : 'On-ground mediation, fraud protection & escrow claims',
            'icon': Icons.gavel_rounded,
            'color': const Color(0xFFDC2626),
            'page': const DisputeResolutionPage(),
          },
          {
            'id': 9,
            'title': isRtl ? 'مشترياتي وشحناتي السابقة' : 'My Orders & Shipments',
            'desc': isRtl ? 'متابعة مراحل الطلبات، الشحنات، الفواتير والتسعير' : 'Track orders, invoices, inspection milestones & deliveries',
            'icon': Icons.receipt_long_rounded,
            'color': const Color(0xFFF59E0B),
            'page': const ChinaBoxPreviousOrdersPage(),
          },
          {
            'id': 10,
            'title': isRtl ? 'التحقق من البائع الموثوق' : 'Trusted Seller Verification',
            'desc': isRtl ? 'فحص السجل التجاري الصيني والتحقق من مصداقية المصنع' : 'Business license check, USCC registry validation & audits',
            'icon': Icons.verified_user_rounded,
            'color': const Color(0xFFD97706),
            'page': const TrustedSellerPage(),
          },
        ];

        final filtered = allServices.where((s) {
          final t = s['title'] as String;
          final d = s['desc'] as String;
          return t.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Directionality(
          textDirection: _loc.textDirection,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
                    color: const Color(0xFF111827), size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                isRtl ? 'دليل جميع خدمات أبابا' : 'All Ababa Services Directory',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
            ),
            body: Column(
              children: [
                // Search Field
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      hintText: isRtl ? 'ابحث في الخدمات اللوجستية والتجارية...' : 'Search services, shipping, customs...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ),

                // Services List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final s = filtered[idx];
                      final color = s['color'] as Color;

                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => s['page'] as Widget),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: const [
                              BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Icon(s['icon'] as IconData, color: color, size: 26),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['title'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      s['desc'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11.5,
                                        color: Color(0xFF64748B),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                                color: const Color(0xFF94A3B8),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
