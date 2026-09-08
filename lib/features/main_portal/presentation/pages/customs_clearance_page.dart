import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class CustomsClearancePage extends StatefulWidget {
  const CustomsClearancePage({super.key});

  @override
  State<CustomsClearancePage> createState() => _CustomsClearancePageState();
}

class _CustomsClearancePageState extends State<CustomsClearancePage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _emerald = Color(0xFF059669);

  final _invoiceValueController = TextEditingController(text: '8500');
  final _hsCodeController = TextEditingController(text: '8518.30');
  final _goodsDescriptionController = TextEditingController(text: 'Wireless Electronic Audio Equipment');
  
  String _clearancePort = 'Jeddah Islamic Port';
  String _shipmentMode = 'Sea Freight (بحري)';
  bool _hasSaberCert = true;
  bool _isSubmitting = false;

  final Map<String, bool> _uploadedDocs = {
    'Commercial Invoice': true,
    'Packing List': true,
    'Bill of Lading / Airway Bill': false,
    'Certificate of Origin': true,
  };

  final List<String> _ports = [
    'Jeddah Islamic Port',
    'King Abdulaziz Port (Dammam)',
    'King Khalid Int Airport (Riyadh Cargo)',
    'King Abdulaziz Int Airport (Jeddah Cargo)',
    'Dubai Port (Jebel Ali)',
    'Karachi Port Terminal',
  ];

  double get _dutyRate => 0.05; // 5% standard
  double get _vatRate => 0.15; // 15% VAT

  double get _invoiceVal => double.tryParse(_invoiceValueController.text) ?? 0.0;
  double get _calculatedDuty => _invoiceVal * _dutyRate;
  double get _calculatedVat => (_invoiceVal + _calculatedDuty) * _vatRate;
  double get _brokerFee => 250.0;
  double get _totalEstimatedFees => _calculatedDuty + _calculatedVat + _brokerFee;

  void _submitClearanceRequest() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isRtl = _loc.isRtl;
    final clearRef = 'CUSTOMS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

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
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user_rounded, color: _emerald, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'تم تسجيل بيان التخليص الجمركي!' : 'Customs Declaration Filed!',
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
                  ? 'رقم المعاملة الجمركية: $clearRef\nتم تعيين مخلص جمركي معتمد لمتابعة المعاملة في المنفذ.'
                  : 'Clearance Reference: $clearRef\nA licensed customs broker has been assigned to your shipment.',
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
                child: Text(isRtl ? 'حسناً، عودة' : 'Done & Return', style: const TextStyle(fontWeight: FontWeight.w800)),
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
                isRtl ? 'التخليص الجمركي والاستشارات' : 'Customs Clearance',
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
                        colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x200F766E), blurRadius: 10, offset: Offset(0, 4)),
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
                          child: const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'تخليص جمركي سريع وقانوني 100%' : 'Fast & Compliant Customs Clearance',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'إعفاءات، استشارات بنود جمركية وتخليص عبر منصة سابر'
                                    : 'Tariff classification, Saber certification & port release',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Port & Mode
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
                        Text(isRtl ? 'منفذ التخليص الجمركي' : 'Port of Clearance',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _clearancePort,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'المنفذ الجمركي' : 'Customs Port / Terminal',
                            prefixIcon: const Icon(Icons.account_balance_outlined, color: _emerald),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _ports.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (v) => setState(() => _clearancePort = v!),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _shipmentMode = 'Sea Freight (بحري)'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _shipmentMode.contains('Sea') ? const Color(0xFFF0FDF4) : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _shipmentMode.contains('Sea') ? _emerald : const Color(0xFFE2E8F0)),
                                  ),
                                  child: Center(
                                    child: Text(isRtl ? 'شحن بحري' : 'Sea Freight',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: _shipmentMode.contains('Sea') ? _emerald : const Color(0xFF4B5563))),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _shipmentMode = 'Air Cargo (جوي)'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _shipmentMode.contains('Air') ? const Color(0xFFF0FDF4) : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _shipmentMode.contains('Air') ? _emerald : const Color(0xFFE2E8F0)),
                                  ),
                                  child: Center(
                                    child: Text(isRtl ? 'شحن جوي' : 'Air Cargo',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: _shipmentMode.contains('Air') ? _emerald : const Color(0xFF4B5563))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Goods and Tax Calculator
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
                        Text(isRtl ? 'حاسبة الرسوم الجمركية والضريبة' : 'Duty & VAT Estimation',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _invoiceValueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: isRtl ? 'إجمالي قيمة الفاتورة التجارية (USD)' : 'Invoice Total Value (USD)',
                            prefixText: '\$ ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _hsCodeController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رمز النظام المنسق (HS Code)' : 'Harmonized System Code (HS Code)',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search_rounded, color: _emerald),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isRtl ? 'تم التحقق من الرمز: جمارك 5%' : 'HS Code Verified: Standard 5% Duty')),
                                );
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _goodsDescriptionController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'وصف البضاعة' : 'Goods Commercial Description',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Calculation Breakdown
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                          child: Column(
                            children: [
                              _buildCalcRow(isRtl ? 'الرسوم الجمركية التقديرية (5%):' : 'Estimated Customs Duty (5%):', '\$${_calculatedDuty.toStringAsFixed(2)}'),
                              const SizedBox(height: 6),
                              _buildCalcRow(isRtl ? 'ضريبة القيمة المضافة (15%):' : 'Value Added Tax (VAT 15%):', '\$${_calculatedVat.toStringAsFixed(2)}'),
                              const SizedBox(height: 6),
                              _buildCalcRow(isRtl ? 'أتعاب المخلص الجمركي والبيان:' : 'Brokerage & Declaration Fee:', '\$${_brokerFee.toStringAsFixed(2)}'),
                              const Divider(height: 16),
                              _buildCalcRow(
                                isRtl ? 'الإجمالي التقديري للفسح:' : 'Total Estimated Clearance Cost:',
                                '\$${_totalEstimatedFees.toStringAsFixed(2)}',
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Document Upload Tracker
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
                        Text(isRtl ? 'المستندات الجمركية المطلوبة' : 'Required Customs Documents',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        ..._uploadedDocs.entries.map((e) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: e.value ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: e.value ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                Icon(e.value ? Icons.check_circle_rounded : Icons.upload_file_rounded,
                                    color: e.value ? _emerald : const Color(0xFF9CA3AF), size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.key,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: e.value ? const Color(0xFF166534) : const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() => _uploadedDocs[e.key] = true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${e.key} attached successfully!')),
                                    );
                                  },
                                  child: Text(
                                    e.value ? (isRtl ? 'مرفق ✓' : 'Attached ✓') : (isRtl ? 'رفع الملف' : 'Upload'),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: e.value ? _emerald : _orange),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitClearanceRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              isRtl ? 'إرسال طلب التخليص الجمركي' : 'Submit Clearance Request',
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

  Widget _buildCalcRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isBold ? 13 : 11.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            )),
        Text(value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isBold ? 14.5 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: isBold ? _orange : const Color(0xFF0F172A),
            )),
      ],
    );
  }
}
