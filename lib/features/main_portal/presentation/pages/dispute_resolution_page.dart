import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class DisputeResolutionPage extends StatefulWidget {
  const DisputeResolutionPage({super.key});

  @override
  State<DisputeResolutionPage> createState() => _DisputeResolutionPageState();
}

class _DisputeResolutionPageState extends State<DisputeResolutionPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _red = Color(0xFFDC2626);

  final _orderIdController = TextEditingController(text: '#AB-24052201');
  final _sellerNameController = TextEditingController(text: 'Yiwu Great Wall Electronics Co.');
  final _disputeSubjectController = TextEditingController(text: 'Specification mismatch: ordered 1000m, received 600m');
  final _descriptionController = TextEditingController(
      text: 'The supplier shipped incomplete quantities and the color shade differs from the approved pre-production sample. We request replacement or escrow refund.');
  
  String _disputeCategory = 'Product Specification Mismatch (اختلاف المواصفات)';
  String _urgencyLevel = 'High Priority (أولوية عاجلة)';
  int _evidencePhotos = 3;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Product Specification Mismatch (اختلاف المواصفات)',
    'Delayed Factory Production & Shipment (تأخر الإنتاج والشحن)',
    'Damaged or Defective Goods (بضاعة تالفة أو مكسورة)',
    'Escrow Payment & Deposit Recovery (استرداد العربون)',
    'Missing Carton or Package (فقدان طرد أو كرتون)',
    'Supplier Non-Response / Fraud Alert (انقطاع تواصل المصنع)',
  ];

  final List<String> _urgencyOptions = [
    'Normal (عادي - حل خلال 48 ساعة)',
    'High Priority (أولوية عاجلة - تدخل فوري 12 ساعة)',
    'Critical Emergency (طارئ - حاوية في الميناء / تجميد دفع)',
  ];

  void _submitDisputeTicket() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isRtl = _loc.isRtl;
    final ticketRef = 'CASE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

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
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, color: _red, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'تم فتح تذكرة النزاع التجاري!' : 'Dispute Case Opened!',
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
                  ? 'رقم القضية: $ticketRef\nقام فريق الوساطة القانونية في مكتب الصين بتجميد الدفعة والتواصل مع المصنع مباشرة.'
                  : 'Case Reference: $ticketRef\nOur China legal mediation team has contacted the supplier and frozen escrow release.',
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
                child: Text(isRtl ? 'تم، متابعة' : 'Done & Return', style: const TextStyle(fontWeight: FontWeight.w800)),
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
                isRtl ? 'المساعدة في حل المشكلات والنزاعات' : 'Problem Solving & Disputes',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
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
                        colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x20DC2626), blurRadius: 10, offset: Offset(0, 4)),
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
                          child: const Icon(Icons.gavel_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'حماية حقوقك المالية والتجارية في الصين' : 'Financial & Trade Protection in China',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'فريق ميداني لحل النزاعات مع الموردين واسترداد حقوقك'
                                    : 'On-the-ground mediation, escrow protection & dispute recovery',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Dispute Category
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
                        Text(isRtl ? 'نوع المشكلة والنزاع' : 'Dispute Category',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _disputeCategory,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'تصنيف المشكلة' : 'Select Issue Type',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (v) => setState(() => _disputeCategory = v!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _urgencyLevel,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'مستوى الأهمية والاستعجال' : 'Urgency Level',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _urgencyOptions.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (v) => setState(() => _urgencyLevel = v!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Order Reference & Supplier
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
                        Text(isRtl ? 'بيانات الشحنة والمصنع المعني' : 'Order & Factory Details',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _orderIdController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رقم الطلب / الشحنة' : 'Order / Shipment Reference ID',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _sellerNameController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'اسم المورد / المصنع الصيني' : 'Chinese Supplier / Factory Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _disputeSubjectController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'عنوان الشكوى باختصار' : 'Subject of Complaint',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'شرح تفصيلي للمشكلة والحل المطلوب' : 'Detailed Problem Description & Desired Remedy',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Evidence & Photos
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
                            Text(isRtl ? 'الأدلة والمستندات والصور' : 'Evidence, Receipts & Photos',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                            Text('$_evidencePhotos ${isRtl ? 'ملفات مرفقة' : 'Files attached'}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _red)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => _evidencePhotos++);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isRtl ? 'تم إضافة إثبات جديد' : 'Evidence document attached!')),
                                );
                              },
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFECACA)),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded, color: _red, size: 24),
                                    SizedBox(height: 3),
                                    Text('Upload', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _red)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ...List.generate(_evidencePhotos.clamp(0, 3), (idx) {
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
                                      child: Icon(Icons.description_rounded, color: Colors.grey.shade400, size: 30),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
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

                  const SizedBox(height: 24),

                  // ── Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitDisputeTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              isRtl ? 'فتح تذكرة النزاع والتدخل الفوري' : 'Open Dispute & Mediation Case',
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
