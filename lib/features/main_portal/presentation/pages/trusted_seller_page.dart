import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class TrustedSellerPage extends StatefulWidget {
  const TrustedSellerPage({super.key});

  @override
  State<TrustedSellerPage> createState() => _TrustedSellerPageState();
}

class _TrustedSellerPageState extends State<TrustedSellerPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _gold = Color(0xFFD97706);

  final _storeUrlController = TextEditingController(text: 'https://shop146829482.1688.com');
  final _companyNameController = TextEditingController(text: 'Zhejiang Superb Smart Home Appliance Co., Ltd.');
  final _usccCodeController = TextEditingController(text: '91330782MA28XXXX99');

  bool _isChecking = false;
  bool _hasResult = true;

  final List<Map<String, dynamic>> _verifiedSuppliers = [
    {
      'nameEn': 'Yiwu Golden Dragon Toys Co., Ltd.',
      'nameAr': 'شركة تنين إيوا الذهبي للألعاب',
      'category': 'Toys & Baby Products',
      'location': 'Yiwu, Zhejiang',
      'rating': 4.9,
      'ordersCount': '12,400+ orders',
      'years': 8,
      'isAudited': true,
    },
    {
      'nameEn': 'Shenzhen Apex Smart Electronics Ltd.',
      'nameAr': 'شركة شنتشن أبيكس للإلكترونيات الذكية',
      'category': 'Audio & Smart Gadgets',
      'location': 'Baoan, Shenzhen',
      'rating': 4.8,
      'ordersCount': '8,900+ orders',
      'years': 6,
      'isAudited': true,
    },
    {
      'nameEn': 'Guangzhou Elegance Leather & Bags Factory',
      'nameAr': 'مصنع قوانغتشو للحقائب والجلديات الفاخرة',
      'category': 'Leather Goods & Handbags',
      'location': 'Baiyun, Guangzhou',
      'rating': 4.9,
      'ordersCount': '15,200+ orders',
      'years': 11,
      'isAudited': true,
    },
  ];

  void _runVerification() async {
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _hasResult = true;
    });

    final isRtl = _loc.isRtl;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(isRtl ? 'تم فحص السجل التجاري بنجاح: مصنع نشط ومرخص' : 'Audit Complete: Active & Licensed China Entity'),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (context, _) {
        final isRtl = _loc.isRtl;
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
                isRtl ? 'التحقق من البائع الموثوق' : 'Trusted Seller Verification',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16.5, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.support_agent_rounded, color: _orange),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CustomerChatbotPage()),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB45309), Color(0xFF92400E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x20B45309), blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'تحقق من هوية ومصداقية أي مصنع صيني' : 'Verify Any Chinese Supplier Before Paying',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'فحص السجل التجاري الصيني والتحقق الميداني من الوجود الحقيقي'
                                    : 'Business license check, USCC registry validation & on-site visits',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Verification Input Form
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isRtl ? 'بيانات المصنع أو المتجر للتحقق' : 'Factory / Store to Validate',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _storeUrlController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رابط متجر 1688 / Taobao / Alibaba' : '1688 / Taobao / Alibaba Store URL',
                            prefixIcon: const Icon(Icons.link_rounded, color: _gold),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _companyNameController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'اسم الشركة بالصينية أو الإنجليزية' : 'Registered Company Name (Chinese / Pinyin)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _usccCodeController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رمز الائتمان الموحد USCC (إن وجد)' : 'Unified Social Credit Code (USCC)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isChecking ? null : _runVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isChecking
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.security_rounded, size: 18),
                                      const SizedBox(width: 8),
                                      Text(isRtl ? 'فحص السجل التجاري الآن' : 'Verify Supplier License Now',
                                          style: const TextStyle(fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Verification Result Card (If active)
                  if (_hasResult) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22),
                              const SizedBox(width: 8),
                              Text(
                                isRtl ? 'السجل التجاري الصيني موثق ورسمي' : 'Government Registered Entity: VERIFIED',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow(isRtl ? 'الاسم الرسمي:' : 'Legal Name:', 'Zhejiang Superb Smart Home Appliance Co.'),
                          _buildDetailRow(isRtl ? 'رقم السجل USCC:' : 'USCC License:', '91330782MA28XXXX99'),
                          _buildDetailRow(isRtl ? 'حالة المنشأة:' : 'Operational Status:', 'Normal & Active (في الخدمة)'),
                          _buildDetailRow(isRtl ? 'سنة التأسيس:' : 'Established:', '2016 (8 Years Operating)'),
                          _buildDetailRow(isRtl ? 'رأس المال المسجل:' : 'Registered Capital:', '¥ 10,000,000 RMB'),
                          _buildDetailRow(isRtl ? 'موقع المصنع الفعلي:' : 'Physical Factory:', 'Jinhua Economic Zone, Zhejiang'),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isRtl ? 'التقييم الائتماني العام:' : 'Credit Risk Score:',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(6)),
                                child: const Text('AAA Low Risk', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // ── Directory of Alibaba / Ababa Certified Factories
                  Text(isRtl ? 'دليل المصانع المعتمدة والمفحوصة ميدانياً' : 'Audited & Certified Supplier Network',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  const SizedBox(height: 10),

                  ..._verifiedSuppliers.map((supp) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.workspace_premium_rounded, color: _gold, size: 26),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        isRtl ? supp['nameAr'] : supp['nameEn'],
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text('${supp['category']} • ${supp['location']}',
                                    style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF6B7280))),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 15),
                                    const SizedBox(width: 3),
                                    Text('${supp['rating']}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                                    const SizedBox(width: 8),
                                    Text(supp['ordersCount'], style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
          const SizedBox(width: 6),
          Expanded(
            child: Text(val, style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          ),
        ],
      ),
    );
  }
}
