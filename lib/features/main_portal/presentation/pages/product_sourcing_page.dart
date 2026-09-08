import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class ProductSourcingPage extends StatefulWidget {
  const ProductSourcingPage({super.key});

  @override
  State<ProductSourcingPage> createState() => _ProductSourcingPageState();
}

class _ProductSourcingPageState extends State<ProductSourcingPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _purple = Color(0xFF7C3AED);

  final _productNameController = TextEditingController(text: 'Custom Wireless Mechanical Keyboard');
  final _specsController = TextEditingController(text: 'RGB backlit, hot-swappable switches, Arabic/English laser engraved keycaps, 500 units.');
  final _refUrlController = TextEditingController(text: 'https://detail.1688.com/offer/7123456789.html');
  final _targetPriceController = TextEditingController(text: '18.50');
  final _quantityController = TextEditingController(text: '500');

  String _marketPreference = 'Yiwu & Shenzhen Markets';
  bool _needSample = true;
  bool _needInspection = true;
  bool _needPrivateLabel = true;
  bool _isSubmitting = false;

  int _attachedPhotoCount = 2;

  final List<String> _markets = [
    'Yiwu & Shenzhen Markets',
    'Guangzhou Wholesale Center',
    'Ningbo Manufacturing Hub',
    'Any Verified China Factory',
  ];

  void _submitSourcingRequest() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isRtl = _loc.isRtl;
    final rfqCode = 'SRC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFF3E8FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.saved_search_rounded, color: _purple, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'تم تقديم طلب توريد المنتج!' : 'Sourcing Request Placed!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isRtl
                  ? 'رقم طلب البحث والتوريد: $rfqCode\nسيتواصل معك وسيطنا في الصين مع أفضل 3 عروض أسعار مصنعية.'
                  : 'Sourcing Inquiry: $rfqCode\nOur China sourcing agent will present top 3 factory quotes within 24h.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isRtl ? 'حسناً، تم' : 'Done', style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
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
                isRtl ? 'البحث عن منتج معين وتوريده' : 'Product Sourcing Concierge',
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
                        colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x207C3AED), blurRadius: 10, offset: Offset(0, 4)),
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
                          child: const Icon(Icons.search_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'ابحث عن أي منتج من المصنع مباشرة' : 'Source Direct from China Factories',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'فريقنا في فوتيان وإيوا يجد لك أفضل جودة وأقل سعر'
                                    : 'Our team in Yiwu & Guangzhou finds the best price & quality',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Product Details Section
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
                        Text(isRtl ? 'معلومات المنتج المطلوب' : 'Product Information',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _productNameController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'اسم المنتج' : 'Product Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _specsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'المواصفات المطلوبة، الألوان، الخامة' : 'Detailed Specifications & Requirements',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _refUrlController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رابط المنتج من 1688 / Taobao / Alibaba (إن وجد)' : 'Reference URL (1688 / Taobao / Alibaba)',
                            prefixIcon: const Icon(Icons.link_rounded, color: _purple),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Photos and Reference Samples
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(isRtl ? 'صور المنتج والعينات' : 'Product Photos & Samples',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                            Text('$_attachedPhotoCount ${isRtl ? 'صور مرفقة' : 'Photos'}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _purple)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => _attachedPhotoCount++);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isRtl ? 'تم إضافة صورة للمنتج' : 'Photo added to sourcing request!')),
                                );
                              },
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFD8B4FE), style: BorderStyle.solid),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded, color: _purple, size: 24),
                                    SizedBox(height: 3),
                                    Text('Upload', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _purple)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ...List.generate(_attachedPhotoCount.clamp(0, 3), (idx) {
                              return Container(
                                width: 75,
                                height: 75,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(Icons.image_rounded, color: Colors.grey.shade400, size: 32),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                                        child: const Icon(Icons.check, size: 10, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Quantity & Target Budget
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
                        Text(isRtl ? 'الكمية والميزانية المستهدفة' : 'Target Quantity & Price',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: isRtl ? 'الكمية (قطعة)' : 'Quantity (Units)',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _targetPriceController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  labelText: isRtl ? 'السعر المستهدف' : 'Target Unit Price',
                                  prefixText: '\$ ',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _marketPreference,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'سوق التوريد المفضل' : 'Sourcing Region',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _markets.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (v) => setState(() => _marketPreference = v!),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'طلب عينة فحص أولاً' : 'Order Physical Sample First',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needSample,
                          activeColor: _purple,
                          onChanged: (v) => setState(() => _needSample = v!),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'فحص جودة المصنع قبل الشحن' : 'Pre-Shipment Quality Inspection',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needInspection,
                          activeColor: _purple,
                          onChanged: (v) => setState(() => _needInspection = v!),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'طباعة شعاري الخاص (Private Label)' : 'Custom Logo & Packaging (Private Label)',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needPrivateLabel,
                          activeColor: _purple,
                          onChanged: (v) => setState(() => _needPrivateLabel = v!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitSourcingRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              isRtl ? 'إرسال طلب البحث والتوريد' : 'Submit Sourcing Request',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
