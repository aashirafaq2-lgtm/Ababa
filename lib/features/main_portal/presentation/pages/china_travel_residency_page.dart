import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';

class ChinaTravelResidencyPage extends StatefulWidget {
  const ChinaTravelResidencyPage({super.key});

  @override
  State<ChinaTravelResidencyPage> createState() => _ChinaTravelResidencyPageState();
}

class _ChinaTravelResidencyPageState extends State<ChinaTravelResidencyPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _indigo = Color(0xFF4F46E5);

  final _fullNameController = TextEditingController(text: 'Ahmed Al-Mansoor');
  final _passportNumberController = TextEditingController(text: 'N98765432');
  final _phoneController = TextEditingController(text: '+966 50 123 4567');
  final _daysCountController = TextEditingController(text: '7');

  String _tripPurpose = 'Canton Fair & Sourcing (معرض كانتون واستيراد)';
  String _destinationCity = 'Guangzhou & Yiwu (قوانغتشو وإيوا)';
  bool _needInvitationLetter = true;
  bool _needTranslator = true;
  bool _needAirportPickup = true;
  bool _needHotelBooking = true;
  bool _isSubmitting = false;

  final List<String> _purposes = [
    'Canton Fair & Sourcing (معرض كانتون واستيراد)',
    'Yiwu Wholesale Markets (أسواق إيوا بالجملة)',
    'Factory Visit & Quality Audit (زيارة مصانع)',
    'Business Residency & Setup (إقامة وتأسيس شركات)',
  ];

  final List<String> _cities = [
    'Guangzhou & Yiwu (قوانغتشو وإيوا)',
    'Yiwu City Only (مدينة إيوا فقط)',
    'Guangzhou City (مدينة قوانغتشو)',
    'Shenzhen (شنتشن للتقنية والإلكترونيات)',
    'Shanghai & Ningbo (شنغهاي ونينغبو)',
  ];

  void _submitTravelRequest() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isRtl = _loc.isRtl;
    final visaRef = 'VISA-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

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
                color: Color(0xFFE0E7FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flight_takeoff_rounded, color: _indigo, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isRtl ? 'تم تقديم طلب السفر والتأشيرة!' : 'Travel & Visa Request Placed!',
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
                  ? 'رقم المعاملة: $visaRef\nتم إرسال متطلبات الدعوة الرسمية (M-Visa) إلى قسم العلاقات التجارية في الصين.'
                  : 'Booking Reference: $visaRef\nOur trade relations desk in China is preparing your official invitation dossier.',
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
                isRtl ? 'السفر والتأشيرات والإقامة' : 'China Travel & Business Visas',
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
                        colors: [Color(0xFF4338CA), Color(0xFF3730A3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x204338CA), blurRadius: 10, offset: Offset(0, 4)),
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
                          child: const Icon(Icons.airplane_ticket_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'رحلتك التجارية إلى الصين أسهل معنا' : 'Your China Business Trip Made Easy',
                                style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl
                                    ? 'دعوات تجارية رسمية، مترجم عربي مرافق، واستقبال من المطار'
                                    : 'Official M-Visa invitations, Arabic/Chinese guides & airport pickups',
                                style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.9), fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Personal Info
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
                        Text(isRtl ? 'بيانات المسافر والجواز' : 'Traveler & Passport Details',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'الاسم كما في جواز السفر' : 'Full Name (as on Passport)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passportNumberController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رقم جواز السفر' : 'Passport Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'رقم الواتساب للتواصل' : 'WhatsApp Contact Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Trip Details
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
                        Text(isRtl ? 'تفاصيل الزيارة التجارية' : 'Business Trip Itinerary',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _tripPurpose,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'الغرض من الزيارة' : 'Trip Purpose',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (v) => setState(() => _tripPurpose = v!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _destinationCity,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'المدن المستهدفة' : 'Target Cities in China',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5)))).toList(),
                          onChanged: (v) => setState(() => _destinationCity = v!),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _daysCountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: isRtl ? 'مدة الإقامة المتوقعة (أيام)' : 'Expected Duration (Days)',
                            suffixText: isRtl ? 'أيام' : 'Days',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Concierge Add-ons
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
                        Text(isRtl ? 'الخدمات اللوجستية المطلوبة في الصين' : 'In-China Concierge Services',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'خطاب دعوة رسمية لتأشيرة التجارة (M-Visa)' : 'Official Commercial M-Visa Invitation Letter',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needInvitationLetter,
                          activeColor: _indigo,
                          onChanged: (v) => setState(() => _needInvitationLetter = v!),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'مترجم عربي/صيني مرافق في الأسواق والمصانع' : 'Dedicated Arabic/Chinese Market Guide & Translator',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needTranslator,
                          activeColor: _indigo,
                          onChanged: (v) => setState(() => _needTranslator = v!),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'استقبال وتوصيل خاص من المطار' : 'Private Airport Transfer & Chauffeured Car',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needAirportPickup,
                          activeColor: _indigo,
                          onChanged: (v) => setState(() => _needAirportPickup = v!),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(isRtl ? 'حجز فندق شريك قريب من سوق فوتيان' : 'Partner Hotel Near Yiwu / Canton Fair',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          value: _needHotelBooking,
                          activeColor: _indigo,
                          onChanged: (v) => setState(() => _needHotelBooking = v!),
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
                      onPressed: _isSubmitting ? null : _submitTravelRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              isRtl ? 'تقديم طلب تأشيرة وسفر الصين' : 'Submit China Travel & Visa Request',
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
