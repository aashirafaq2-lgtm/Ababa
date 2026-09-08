import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/container_shipping_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_previous_orders_page.dart';

class HomeModals {
  static const Color _orange = Color(0xFFFF6B00);

  // ─── 1. Promotional Offers Modal ───────────────────────────────────────────
  static void showOffersModal(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isRtl = loc.isRtl;

    final coupons = [
      {
        'code': 'WELCOME20',
        'title': isRtl ? 'خصم 20% على أول شحنة جوية' : '20% Off First Air Cargo',
        'desc': isRtl ? 'صالح للشحنات أكثر من 10 كجم عبر صندوق الصين' : 'Valid for shipments over 10kg via My China Box',
        'discount': '20% OFF',
        'expiry': '30 Sep 2026',
      },
      {
        'code': 'AIRCARGO10',
        'title': isRtl ? 'تخفيض \$1.00 لكل كجم شحن جوي سريع' : '\$1.00/kg Discount on Express Air',
        'desc': isRtl ? 'شحن جوي سريع 4-7 أيام من مستودع إيوا' : 'Express Air 4-7 days from Yiwu warehouse',
        'discount': '-\$1.00/kg',
        'expiry': '15 Oct 2026',
      },
      {
        'code': 'FUTIANFREE',
        'title': isRtl ? 'فحص عينات مجاني في سوق فوتيان' : 'Free Sample Inspection in Futian',
        'desc': isRtl ? 'فحص وتصوير عينات المنتجات قبل الشحن مجاناً' : 'Free photos and quality check before shipping',
        'discount': 'FREE',
        'expiry': '31 Dec 2026',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: loc.textDirection,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_offer_rounded, color: _orange, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        isRtl ? 'العروض الحصرية وكوبونات الشحن' : 'Exclusive Shipping Offers',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...coupons.map((c) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFD4B2), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: _orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          c['discount']!,
                          style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['title']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                            const SizedBox(height: 2),
                            Text(c['desc']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: c['code']!));
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRtl ? 'تم نسخ الكوبون: ${c['code']} وتطبيقه بنجاح!' : 'Coupon ${c['code']} copied & applied!'),
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _orange),
                          foregroundColor: _orange,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(isRtl ? 'نسخ واستخدام' : 'Apply', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 2. Market News Modal ───────────────────────────────────────────────────
  static void showMarketNewsModal(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isRtl = loc.isRtl;

    final news = [
      {
        'title': isRtl ? 'تحديث أسعار الشحن الجوي لشهر سبتمبر 2026' : 'September 2026 Air Freight Rates Updated',
        'desc': isRtl ? 'تم تخفيض تعرفة الشحن الجوي من إيوا إلى \$8.50/كجم مع توصيل في 5 أيام.' : 'Air cargo tariff dropped to \$8.50/kg from Yiwu with 5-day delivery.',
        'date': '05 Sep 2026',
        'tag': 'Shipping',
      },
      {
        'title': isRtl ? 'مواعيد إجازة العيد الوطني في موانئ الصين' : 'Golden Week Holiday Port Operations Notice',
        'desc': isRtl ? 'مستودعنا في إيوا وقوانغتشو يعمل بكامل طاقته لاستقبال الطرود دون انقطاع.' : 'Our Yiwu & Guangzhou warehouses remain fully open for receiving cargo.',
        'date': '02 Sep 2026',
        'tag': 'Warehouse',
      },
      {
        'title': isRtl ? 'إطلاق مسار الشحن السريع إلى دول الخليج' : 'New Gulf Express Shipping Lane Launched',
        'desc': isRtl ? 'تخليص مسبق في مطار دبي والرياض لتسريع التوصيل إلى باب العميل.' : 'Pre-clearance in Riyadh & Dubai airports for next-day domestic courier.',
        'date': '28 Aug 2026',
        'tag': 'Customs',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: loc.textDirection,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.newspaper_rounded, color: Color(0xFF0284C7), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        isRtl ? 'آخر أخبار التجارة والشحن من الصين' : 'China Trade & Logistics News',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...news.map((n) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(6)),
                            child: Text(n['tag']!, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0369A1))),
                          ),
                          Text(n['date']!, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(n['title']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      Text(n['desc']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: Color(0xFF64748B), height: 1.3)),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 3. Quick Shipping Estimator Modal ──────────────────────────────────────
  static void showShippingEstimatorModal(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isRtl = loc.isRtl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) {
          return Directionality(
            textDirection: loc.textDirection,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calculate_rounded, color: _orange, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            isRtl ? 'حاسبة الشحن الفوري' : 'Instant Shipping Estimator',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFFD4B2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.airplanemode_active_rounded, color: _orange, size: 22),
                              const SizedBox(height: 6),
                              Text(isRtl ? 'شحن جوي سريع' : 'Air Express', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(isRtl ? '\$9.00 / كجم • 4-7 أيام' : '\$9.00 / kg • 4-7 Days', style: const TextStyle(fontSize: 11, color: Color(0xFF9A3412))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.directions_boat_rounded, color: Color(0xFF16A34A), size: 22),
                              const SizedBox(height: 6),
                              Text(isRtl ? 'شحن بحري حاويات' : 'Ocean Freight', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(isRtl ? '\$110 / CBM • 25-35 يوم' : '\$110 / CBM • 25-35 Days', style: const TextStyle(fontSize: 11, color: Color(0xFF166534))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ContainerShippingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isRtl ? 'حجز شحن أو فتح حاسبة الحاويات' : 'Open Container Booking Calculator',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── 4. Loyalty Points Modal ───────────────────────────────────────────────
  static void showLoyaltyPointsModal(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isRtl = loc.isRtl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: loc.textDirection,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isRtl ? 'نقاط مكافآت أبابا (Ababa Club)' : 'Ababa Rewards Points',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isRtl ? 'رصيد نقاطك الحالي' : 'Available Points Balance',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF92400E))),
                        const SizedBox(height: 4),
                        const Text('1,450 PTS',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Text(isRtl ? 'يعادل \$14.50' : 'Worth \$14.50',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF92400E))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isRtl ? 'تم تطبيق خصم 14.50\$ على شحنتك القادمة!' : '\$14.50 discount applied to next shipment!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isRtl ? 'استبدال النقاط بخصم شحن' : 'Redeem Points for Discount',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 5. China Market Guide Modal ───────────────────────────────────────────
  static void showChinaGuideModal(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isRtl = loc.isRtl;

    final markets = [
      {'name': isRtl ? 'سوق فوتيان الدولي (إيوا)' : 'Yiwu Futian International Market', 'desc': isRtl ? 'أكبر سوق جملة في العالم (70,000 كشك)' : 'World’s largest wholesale hub for consumer products'},
      {'name': isRtl ? 'سوق باييون للملابس (قوانغتشو)' : 'Guangzhou Baiyun Garment Market', 'desc': isRtl ? 'عاصمة الأزياء والحقائب والجلديات' : 'Global fashion, fabrics & leather market'},
      {'name': isRtl ? 'سوق هواكيانغ باي (شنتشن)' : 'Shenzhen Huaqiangbei Electronics', 'desc': isRtl ? 'سيليكون فالي الشرق للأجهزة والإلكترونيات' : 'World capital of electronic components & gadgets'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: loc.textDirection,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.temple_buddhist_rounded, color: Color(0xFFDC2626), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        isRtl ? 'دليل أسواق الصين بالجملة' : 'China Wholesale Markets Guide',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...markets.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Row(
                    children: [
                      const Icon(Icons.place_rounded, color: Color(0xFFDC2626), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(m['desc']!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
