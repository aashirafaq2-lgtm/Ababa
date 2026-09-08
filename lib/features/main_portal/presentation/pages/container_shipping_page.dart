import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class ContainerShippingPage extends StatefulWidget {
  const ContainerShippingPage({super.key});

  @override
  State<ContainerShippingPage> createState() => _ContainerShippingPageState();
}

class _ContainerShippingPageState extends State<ContainerShippingPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);

  // Form State
  String _loadType = 'FCL'; // 'FCL' or 'LCL'
  String _containerSize = '40ft Standard';
  String _originPort = 'Ningbo';
  String _destPort = 'Jeddah';
  String _commodity = 'General Cargo';
  final _cbmController = TextEditingController(text: '15.0');
  final _weightController = TextEditingController(text: '3500');
  final _notesController = TextEditingController();
  bool _includeCustoms = true;
  bool _includeInsurance = true;
  bool _isSubmitting = false;

  final List<String> _originPorts = [
    'Ningbo',
    'Shenzhen (Yantian)',
    'Guangzhou (Nansha)',
    'Yiwu (Dry Port)',
    'Qingdao',
    'Shanghai',
  ];

  final List<String> _destPorts = [
    'Jeddah Islamic Port',
    'King Abdulaziz Port (Dammam)',
    'Dubai (Jebel Ali)',
    'Riyadh Dry Port',
    'Karachi Port',
    'Tripoli Port',
    'Alexandria Port',
  ];

  final List<String> _commodities = [
    'General Cargo',
    'Textiles & Garments',
    'Electronics & Gadgets',
    'Furniture & Decor',
    'Machinery & Spare Parts',
    'Toys & Plastics',
  ];

  double get _estimatedCost {
    double base = _loadType == 'FCL'
        ? (_containerSize == '20ft Standard' ? 2450.0 : 3850.0)
        : (double.tryParse(_cbmController.text) ?? 15.0) * 110.0;
    if (_includeCustoms) base += 350.0;
    if (_includeInsurance) base += 120.0;
    return base;
  }

  void _submitBooking() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isRtl = _loc.isRtl;
    final bookingRef = 'CONT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

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
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'تم تقديم طلب الشحن بنجاح!' : 'Booking Request Submitted!',
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
                  ? 'رقم مرجع الحاوية: $bookingRef\nسيقوم فريق الشحن البحري بالتواصل معك خلال ساعتين.'
                  : 'Container Reference: $bookingRef\nOur sea freight team will contact you within 2 hours.',
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
                child: Text(isRtl ? 'تم، العودة' : 'Done & Return', style: const TextStyle(fontWeight: FontWeight.w800)),
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
                isRtl ? 'شحن الحاويات البحرية' : 'Container Shipping',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
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
                        colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x200284C7), blurRadius: 10, offset: Offset(0, 4)),
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
                          child: const Icon(Icons.directions_boat_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'خدمة الشحن بالحاويات الكاملة والجزئية' : 'FCL & LCL Ocean Freight',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'شحن مباشر من موانئ الصين مع التخليص والتوصيل'
                                    : 'Direct shipping from China ports with clearance & delivery',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Load Type (FCL vs LCL)
                  Text(isRtl ? 'نوع الشحن' : 'Shipping Mode',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectCard(
                          title: isRtl ? 'حاوية كاملة (FCL)' : 'Full Container (FCL)',
                          subtitle: isRtl ? 'للبضائع الكبيرة والمصانع' : 'For bulk cargo & factories',
                          isSelected: _loadType == 'FCL',
                          icon: Icons.inventory_2_rounded,
                          onTap: () => setState(() => _loadType = 'FCL'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSelectCard(
                          title: isRtl ? 'شحن جزئي (LCL)' : 'Partial / CBM (LCL)',
                          subtitle: isRtl ? 'للحمولات الصغيرة بالمتر المكعب' : 'By CBM volume',
                          isSelected: _loadType == 'LCL',
                          icon: Icons.all_inbox_rounded,
                          onTap: () => setState(() => _loadType = 'LCL'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Container Size (if FCL) or CBM input (if LCL)
                  if (_loadType == 'FCL') ...[
                    Text(isRtl ? 'حجم الحاوية' : 'Container Size',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    Row(
                      children: ['20ft Standard', '40ft Standard', '40ft High Cube'].map((size) {
                        final isSel = _containerSize == size;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _containerSize = size),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFFFF7ED) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSel ? _orange : const Color(0xFFE2E8F0), width: isSel ? 1.8 : 1),
                              ),
                              child: Center(
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.5,
                                    fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                                    color: isSel ? _orange : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    Text(isRtl ? 'حجم الشحنة (متر مكعب CBM)' : 'Volume (CBM)',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cbmController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixText: 'CBM',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Ports Selection
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
                        Text(isRtl ? 'مسار الشحن البحري' : 'Shipping Route',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _originPort,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'ميناء التحميل (الصين)' : 'Origin Port (China)',
                            prefixIcon: const Icon(Icons.location_on_outlined, color: _orange),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _originPorts.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (v) => setState(() => _originPort = v!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _destPort,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'ميناء الوصول (الوجهة)' : 'Destination Port',
                            prefixIcon: const Icon(Icons.flag_outlined, color: Color(0xFF0284C7)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _destPorts.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (v) => setState(() => _destPort = v!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Commodity & Weight
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
                        Text(isRtl ? 'تفاصيل البضاعة' : 'Cargo Details',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _commodity,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'نوع البضاعة' : 'Commodity Type',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _commodities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (v) => setState(() => _commodity = v!),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'الوزن التقريبي (كجم)' : 'Estimated Weight (kg)',
                            suffixText: 'KG',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'إضافة التخليص الجمركي' : 'Include Customs Clearance',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700)),
                          subtitle: Text(isRtl ? 'تخليص الميناء ومعاملات البيان' : 'Port declaration & customs clearance',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                          value: _includeCustoms,
                          activeColor: _orange,
                          onChanged: (v) => setState(() => _includeCustoms = v),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'تأمين بحري شامل' : 'Comprehensive Marine Insurance',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700)),
                          subtitle: Text(isRtl ? 'حماية ضد أخطار الغرق والتلف' : 'Coverage against damage & loss',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                          value: _includeInsurance,
                          activeColor: _orange,
                          onChanged: (v) => setState(() => _includeInsurance = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Live Instant Estimate Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFD4B2), width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isRtl ? 'السعر التقديري للشحن' : 'Estimated Freight Total',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9A3412))),
                            const SizedBox(height: 2),
                            Text('\$${_estimatedCost.toStringAsFixed(2)}',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900, color: _orange)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            isRtl ? '25-35 يوم إبحار' : '25-35 Transit Days',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF374151)),
                          ),
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
                      onPressed: _isSubmitting ? null : _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              isRtl ? 'حجز شحنة الحاوية الآن' : 'Book Container Shipment Now',
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

  Widget _buildSelectCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? _orange : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? _orange : const Color(0xFF6B7280), size: 24),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: isSelected ? _orange : const Color(0xFF1E293B))),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontFamily: 'Inter', fontSize: 10.5, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}
