import 'package:flutter/material.dart';
import '../../domain/models/china_box_localization.dart';
import '../widgets/service_3d_icons.dart';

class ServiceComingSoonPage extends StatefulWidget {
  final int serviceId;
  final String? customTitleEn;
  final String? customTitleAr;
  final String? customSubtitleEn;
  final String? customSubtitleAr;

  const ServiceComingSoonPage({
    super.key,
    required this.serviceId,
    this.customTitleEn,
    this.customTitleAr,
    this.customSubtitleEn,
    this.customSubtitleAr,
  });

  @override
  State<ServiceComingSoonPage> createState() => _ServiceComingSoonPageState();
}

class _ServiceComingSoonPageState extends State<ServiceComingSoonPage>
    with SingleTickerProviderStateMixin {
  final _loc = ChinaBoxLocalization();
  bool _isNotified = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getServiceMetadata(bool isRtl) {
    switch (widget.serviceId) {
      case 3:
        return {
          'title': isRtl ? 'شحن الحاويات الكاملة والمجمعة' : 'Container Shipping (FCL / LCL)',
          'subtitle': isRtl
              ? 'خدمة شحن بحري مخصصة للحاويات 20ft و 40ft من موانئ الصين مباشرة إلى موانئ المملكة والخليج بأفضل الأسعار.'
              : 'Direct ocean freight forwarding for 20ft & 40ft containers from major Chinese ports directly to Saudi & GCC ports.',
          'highlights': isRtl
              ? [
                  'حاويات كاملة FCL وحاويات مجزأة LCL',
                  'شحن مباشر من نينغبو، شنتشن، وجوانزو',
                  'تتبع ملاحي حي لحركة السفينة',
                  'حجز مساحات مضمونة مع كبرى الخطوط الملاحية'
                ]
              : [
                  'Full Container (FCL) & Shared Cargo (LCL)',
                  'Direct lines from Ningbo, Shenzhen & Guangzhou',
                  'Real-time vessel position tracking',
                  'Guaranteed slot allocations on top ocean carriers'
                ],
          'tag': isRtl ? 'خدمات النقل البحري' : 'Ocean Freight',
        };
      case 4:
        return {
          'title': isRtl ? 'التخليص الجمركي واستشارات سابر' : 'Customs Clearance & Compliance',
          'subtitle': isRtl
              ? 'فريق تخليص جمركي معتمد في موانئ جدة، الدمام، الرياض والمطارات لضمان فسح شحناتكم بأسرع وقت وبدون تأخير.'
              : 'Certified customs brokerage teams across Jeddah, Dammam & Riyadh ports ensuring swift clearance without demurrage.',
          'highlights': isRtl
              ? [
                  'حساب فوري للرسوم الجمركية 5% وضريبة القيمة 15%',
                  'إصدار وتوثيق شهادات المطابقة سابر (SABER)',
                  'فسح البضائع التجارية والمواد الحساسة',
                  'إنهاء المعاملات إلكترونياً بنسبة 100%'
                ]
              : [
                  'Instant automated 5% customs duty & 15% VAT calculation',
                  'SABER conformity certification handling',
                  'Commercial cargo & sensitive goods clearance',
                  '100% digital paperwork processing'
                ],
          'tag': isRtl ? 'الإجراءات الجمركية' : 'Customs & Clearance',
        };
      case 6:
        return {
          'title': isRtl ? 'البحث عن منتج معين وتوريده' : 'Product Sourcing Concierge',
          'subtitle': isRtl
              ? 'خدمة وساطة متكاملة للبحث عن مصانع معتمدة لأي منتج بناءً على الصورة أو الرابط، مع التفاوض على السعر والكمية.'
              : 'End-to-end concierge sourcing: find certified factories for any item by photo or link with volume negotiation.',
          'highlights': isRtl
              ? [
                  'البحث بالصورة في أكثر من 100,000 مصنع موثوق',
                  'التفاوض المباشر للوصول لأقل سعر للمصنع',
                  'فحص وتدقيق العينات قبل الشراء بالجملة',
                  'عقود تجارية رسمية لحماية أموال المشتري'
                ]
              : [
                  'Photo search across 100,000+ verified factories',
                  'Direct price negotiation for lowest factory cost',
                  'Sample inspection before bulk production',
                  'Official escrow trade assurance contracts'
                ],
          'tag': isRtl ? 'التوريد والتصنيع' : 'Sourcing & OEM',
        };
      case 7:
        return {
          'title': isRtl ? 'السفر والتأشيرات والإقامة بالصين' : 'China Business Travel & Visas',
          'subtitle': isRtl
              ? 'خدمات متكاملة لرجال الأعمال الراغبين في زيارة أسواق ومصانع الصين، تشمل التأشيرات التجارية، والمترجمين، والفنادق.'
              : 'Complete business travel support: official commercial invitation letters, bilingual market translators & hotel bookings.',
          'highlights': isRtl
              ? [
                  'إصدار خطابات الدعوة التجارية الرسمية (M-Visa)',
                  'مترجمين عرب معتمدين لمرافقتك في أسواق إيوا وجوانزو',
                  'حجوزات فنادق قريبة من مجمعات فوتيان والمصانع',
                  'استقبال خاص من المطارات ومساعد شخصي للتنقل'
                ]
              : [
                  'Official M-Visa commercial invitation letters',
                  'Certified bilingual Arabic/Chinese market guides',
                  'Hotel bookings right next to Futian market',
                  'VIP airport pickup & personal transport logistics'
                ],
          'tag': isRtl ? 'السفر وخدمات الأعمال' : 'Travel & Hospitality',
        };
      case 8:
        return {
          'title': isRtl ? 'المساعدة في حل المشكلات والنزاعات' : 'Dispute Resolution & Legal Aid',
          'subtitle': isRtl
              ? 'فريق قانوني ولوجستي صيني عربي على الأرض للتدخل في حال حدوث أي خلاف تجاري أو تأخير أو عدم مطابقة للمواصفات.'
              : 'On-the-ground Chinese-Arab legal & logistics intervention for trade disputes, production delays or quality mismatches.',
          'highlights': isRtl
              ? [
                  'وساطة مباشرة داخل المصنع لحل الخلاف ودياً',
                  'تجميد الدفعات والضمان عبر الحساب الوسيط',
                  'استرجاع الأموال أو إعادة تصنيع المنتجات المعيبة',
                  'تقرير تدقيق قانوني وفني موثق للأدلة'
                ]
              : [
                  'Direct in-factory mediation for swift amicable resolution',
                  'Escrow payment holds to protect buyer capital',
                  'Full refund or defective batch remake enforcement',
                  'Official certified legal inspection evidence report'
                ],
          'tag': isRtl ? 'حماية التجارة' : 'Trade Protection',
        };
      case 10:
        return {
          'title': isRtl ? 'التحقق من البائع والمصنع الموثوق' : 'Trusted Seller Verification',
          'subtitle': isRtl
              ? 'خدمة استعلام أمني وتجاري شاملة عن الشركات والمصانع الصينية للتحقق من السجل التجاري والقدرة الإنتاجية قبل الدفع.'
              : 'Comprehensive background and credit checks for Chinese factories: official USCC license validation before payment.',
          'highlights': isRtl
              ? [
                  'التحقق من السجل التجاري الصيني الموحد (USCC)',
                  'فحص القوائم السوداء وقضايا النصب والاحتيال',
                  'زيارة ميدانية للمصنع والتحقق من خطوط الإنتاج',
                  'شهادة موثوقية معتمدة من منصة A.BABA'
                ]
              : [
                  'Unified Social Credit Code (USCC) authentication',
                  'Fraud, lawsuit & export blacklist screening',
                  'On-site factory physical visit & capacity audit',
                  'A.BABA verified merchant trust certificate'
                ],
          'tag': isRtl ? 'التدقيق والتوثيق' : 'Verification & Trust',
        };
      default:
        return {
          'title': isRtl ? 'الخدمة قيد التجهيز' : 'Service Coming Soon',
          'subtitle': isRtl
              ? 'نعمل حالياً على تجهيز هذه الخدمة اللوجستية المتطورة لتقديم أفضل تجربة تجارية لك.'
              : 'We are currently preparing this advanced logistics service to provide you with the best trade experience.',
          'highlights': isRtl
              ? ['خدمات رقمية متطورة', 'ربط مباشر مع موانئ ومصانع الصين', 'أمان عالي وضمان كامل']
              : ['Advanced digital capabilities', 'Direct integration with China ports & hubs', 'Complete trade assurance'],
          'tag': isRtl ? 'قريباً' : 'Coming Soon',
        };
    }
  }

  void _handleNotifyToggle(bool isRtl) {
    setState(() => _isNotified = !_isNotified);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isNotified ? Icons.check_circle_rounded : Icons.notifications_off_rounded,
              color: const Color(0xFFFF8C00),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _isNotified
                    ? (isRtl
                        ? 'تم تفعيل التنبيه! سنرسل لك إشعاراً فور إطلاق الخدمة.'
                        : 'Alert activated! We will notify you the moment this service launches.')
                    : (isRtl ? 'تم إلغاء التنبيه.' : 'Alert deactivated.'),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (context, _) {
        final isRtl = _loc.isRtl;
        final data = _getServiceMetadata(isRtl);
        final title = widget.customTitleAr != null && isRtl
            ? widget.customTitleAr!
            : (widget.customTitleEn != null && !isRtl ? widget.customTitleEn! : data['title'] as String);
        final subtitle = widget.customSubtitleAr != null && isRtl
            ? widget.customSubtitleAr!
            : (widget.customSubtitleEn != null && !isRtl ? widget.customSubtitleEn! : data['subtitle'] as String);
        final highlights = data['highlights'] as List<String>;
        final tag = data['tag'] as String;

        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: SafeArea(
              child: Column(
                children: [
                  // ─── 1. TOP APP BAR ──────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF8C00),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isRtl ? 'A.BABA قريباً' : 'A.BABA Coming Soon',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF334155),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        // Language switch toggle
                        GestureDetector(
                          onTap: () => _loc.toggleLanguage(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFFEDD5)),
                            ),
                            child: Text(
                              isRtl ? 'EN' : 'عربي',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF8C00),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── 2. SCROLLABLE BODY ──────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        children: [
                          // Top Hero Visual Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0xFFFFFBF7)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFFFE8D6), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0CFF8C00),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Category Tag Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E6),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFFFD4A8)),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFFF7A00),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Pulsing 3D Icon Container
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(
                                        colors: [Color(0xFFFFF2E5), Color(0xFFFFFFFF)],
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x18FF8C00),
                                          blurRadius: 24,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                      border: Border.all(color: const Color(0xFFFFE1C4), width: 2),
                                    ),
                                    child: Center(
                                      child: Service3DIcon(id: widget.serviceId, size: 68),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Live Status Pill with glowing indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF9800),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFFF9800),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isRtl ? 'قيد التطوير والتجهيز' : 'Under Active Development',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Title
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.5,
                                    height: 1.25,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Subtitle
                                Text(
                                  subtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Upcoming Features Sneak Peek Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x06000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stars_rounded,
                                      size: 18,
                                      color: Color(0xFFFF8C00),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isRtl ? 'ما ستقدمه هذه الخدمة فور إطلاقها:' : 'Upcoming Features & Capabilities:',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...highlights.map(
                                  (h) => Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF3E6),
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: const Color(0xFFFFD4A8), width: 1),
                                          ),
                                          child: const Icon(
                                            Icons.check_rounded,
                                            size: 11,
                                            color: Color(0xFFFF7A00),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            h,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF334155),
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // VIP Priority Notification Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF9F2), Color(0xFFFFF3E6)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFDEC2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x10FF8C00),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.mark_email_read_rounded,
                                    color: Color(0xFFFF8C00),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isRtl ? 'كن أول المستفيدين' : 'Be First to Experience It',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isRtl
                                            ? 'فعّل التنبيه للحصول على خصومات حصرية عند التدشين'
                                            : 'Enable notifications for early access & launch discounts',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── 3. BOTTOM ACTIONS BAR ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Action Button (Notify Me)
                        GestureDetector(
                          onTap: () => _handleNotifyToggle(isRtl),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: _isNotified
                                  ? const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFFFF8C00), Color(0xFFFF5500)],
                                    ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isNotified ? const Color(0xFF10B981) : const Color(0xFFFF6B00))
                                      .withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isNotified ? Icons.check_circle_rounded : Icons.notifications_active_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isNotified
                                        ? (isRtl ? 'تم تفعيل التنبيه بنجاح' : 'Alert Activated!')
                                        : (isRtl ? 'أشعرني فور إطلاق هذه الخدمة' : 'Notify Me When Available'),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Secondary Action Button (Return to Home)
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: double.infinity,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                isRtl ? 'العودة إلى الصفحة الرئيسية' : 'Return to Home',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
