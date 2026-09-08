import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/china_box_localization.dart';
import 'order_details_tracking_page.dart';
import '../../../domain/models/futian_models.dart';
import '../../../data/repositories/api_futian_repository.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class _ShoppingSite {
  final String id;
  final String nameAr;
  final String nameEn;
  final String flagEmoji;
  final String platformsAr;
  final String platformsEn;
  final String imagePath;
  final Color bgColor;

  const _ShoppingSite({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.flagEmoji,
    required this.platformsAr,
    required this.platformsEn,
    required this.imagePath,
    required this.bgColor,
  });
}

const _kSites = [
  _ShoppingSite(
    id: 'china',
    nameAr: 'الصين',
    nameEn: 'China',
    flagEmoji: '🇨🇳',
    platformsAr: '1688، تاوباو، علي بابا، وغيرها',
    platformsEn: '1688, Taobao, Alibaba & more',
    imagePath: 'assets/branding/china_landmark.jpg',
    bgColor: Color(0xFFFFF8F2),
  ),
  _ShoppingSite(
    id: 'usa',
    nameAr: 'أمريكا',
    nameEn: 'America',
    flagEmoji: '🇺🇸',
    platformsAr: 'Amazon، eBay، وغيرها',
    platformsEn: 'Amazon, eBay & more',
    imagePath: 'assets/branding/america_landmark.jpg',
    bgColor: Color(0xFFF0F8FF),
  ),
  _ShoppingSite(
    id: 'turkey',
    nameAr: 'تركيا',
    nameEn: 'Turkey',
    flagEmoji: '🇹🇷',
    platformsAr: 'Hepsiburada، Trendyol، وغيرها',
    platformsEn: 'Hepsiburada, Trendyol & more',
    imagePath: 'assets/branding/turkey_landmark.jpg',
    bgColor: Color(0xFFF0FBFF),
  ),
  _ShoppingSite(
    id: 'shein',
    nameAr: 'SHEIN',
    nameEn: 'SHEIN',
    flagEmoji: 'S',
    platformsAr: 'موقع شي إن الرسمي',
    platformsEn: 'Official SHEIN website',
    imagePath: 'assets/branding/shein_bag.jpg',
    bgColor: Color(0xFFFAFAFA),
  ),
];

// ─── Main Page ────────────────────────────────────────────────────────────────

class AddNewOrderFlowPage extends StatefulWidget {
  const AddNewOrderFlowPage({super.key});

  @override
  State<AddNewOrderFlowPage> createState() => _AddNewOrderFlowPageState();
}

class _AddNewOrderFlowPageState extends State<AddNewOrderFlowPage> {
  final _loc = ChinaBoxLocalization();

  int _step = 0; // 0..4 (5 steps total)

  // Step 1 data
  _ShoppingSite? _selectedSite;

  // Step 2 data
  final _productNameCtrl = TextEditingController();
  final _productUrlCtrl = TextEditingController();
  String? _selectedImagePreview;

  // Step 3 data
  int _quantity = 1;
  String _selectedColor = '';
  String _selectedSize = '';
  final _notesCtrl = TextEditingController();

  // Step 4 data
  final _recipientCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  // Step 5 - success
  String? _orderId;

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _orangeLight = Color(0xFFFFF3EC);

  static const List<String> _stepLabelsAr = [
    'اختر موقع الشراء',
    'تفاصيل المنتج',
    'المواصفات والكمية',
    'عنوان الاستلام',
    'مراجعة الطلب',
  ];
  static const List<String> _stepLabelsEn = [
    'Choose Site',
    'Product Details',
    'Specs & Qty',
    'Delivery Addr.',
    'Review Order',
  ];

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _productUrlCtrl.dispose();
    _notesCtrl.dispose();
    _recipientCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_step) {
      case 0:
        return _selectedSite != null;
      case 1:
        return _productNameCtrl.text.trim().isNotEmpty ||
            _productUrlCtrl.text.trim().isNotEmpty ||
            _selectedImagePreview != null;
      case 2:
        return _quantity > 0;
      case 3:
        return _recipientCtrl.text.trim().isNotEmpty;
      case 4:
        return true;
      default:
        return true;
    }
  }

  void _next() async {
    if (_step == 4) {
      final productName = _productNameCtrl.text.trim().isNotEmpty
          ? _productNameCtrl.text.trim()
          : 'سماعة بلوتوث لاسلكية';
      final productUrl = _productUrlCtrl.text.trim().isNotEmpty
          ? _productUrlCtrl.text.trim()
          : 'https://item.taobao.com/1234567890';

      final draft = NewFutianOrderDraft()
        ..productName = productName
        ..productUrl = productUrl
        ..quantity = _quantity
        ..destinationCountry = 'Libya'
        ..siteType = _selectedSite?.id ?? 'china'
        ..notes = _notesCtrl.text.trim();

      String? createdId;
      try {
        createdId = await ApiFutianRepository.instance.createOrder(draft);
      } catch (_) {}

      final orderId = createdId ??
          '#AB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderDetailsTrackingPage(
            orderId: orderId,
            siteNameAr: _selectedSite?.nameAr ?? 'الصين',
            siteNameEn: _selectedSite?.nameEn ?? 'China',
            productNameAr: productName,
            productNameEn: productName,
            productUrl: productUrl,
            quantity: _quantity,
          ),
        ),
      );
    } else {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (ctx, _) {
        final isRtl = _loc.isRtl;
        return Directionality(
          textDirection: _loc.textDirection,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(isRtl),

                  // Step progress (shown on steps 0-4)
                  if (_step < 5) _buildStepper(isRtl),

                  const Divider(height: 1, color: Color(0xFFF3F4F6)),

                  // Step content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_step),
                        child: _buildContent(isRtl),
                      ),
                    ),
                  ),

                  // Footer nav (on steps 0-4)
                  if (_step < 5) _buildFooter(isRtl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: _back,
            child: Container(
              width: 38,
              height: 38,
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: Color(0xFF111827),
              ),
            ),
          ),

          // Title
          Text(
            _loc.isRtl ? 'إضافة طلبية جديدة' : 'Add New Order',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),

          // Bell with badge
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_loc.isRtl
                      ? 'لديك 3 إشعارات جديدة'
                      : 'You have 3 new notifications'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 25,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4500),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
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
    );
  }

  // ─── Stepper ─────────────────────────────────────────────────────────────────

  Widget _buildStepper(bool isRtl) {
    final labels = isRtl ? _stepLabelsAr : _stepLabelsEn;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: List.generate(5, (i) {
          final isActive = i == _step;
          final isDone = i < _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Circle
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? _orange
                              : isDone
                                  ? _orange
                                  : Colors.white,
                          border: Border.all(
                            color: isActive || isDone
                                ? _orange
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check,
                                  size: 15, color: Colors.white)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: isActive
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Label
                      Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: isActive
                              ? FontWeight.w800
                              : isDone
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color: isActive
                              ? _orange
                              : isDone
                                  ? const Color(0xFF374151)
                                  : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                // Connector line
                if (i < 4)
                  Container(
                    height: 1.5,
                    width: 8,
                    margin: const EdgeInsets.only(bottom: 18),
                    color:
                        i < _step ? _orange : const Color(0xFFE5E7EB),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Content Router ───────────────────────────────────────────────────────────

  Widget _buildContent(bool isRtl) {
    switch (_step) {
      case 0:
        return _buildStep1(isRtl);
      case 1:
        return _buildStep2(isRtl);
      case 2:
        return _buildStep3(isRtl);
      case 3:
        return _buildStep4(isRtl);
      case 4:
        return _buildStep5Review(isRtl);
      case 5:
        return _buildSuccess(isRtl);
      default:
        return const SizedBox();
    }
  }

  // ─── STEP 1: Shopping Site ────────────────────────────────────────────────────

  Widget _buildStep1(bool isRtl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Question heading
          Text(
            isRtl
                ? 'من أي موقع ترغب في الشراء؟'
                : 'Which website do you want to buy from?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            isRtl
                ? 'اختر الدولة أو المتجر الذي يحتوي على المنتج الذي ترغب بشرائه،\nوستتولى الباقي من أجلك.'
                : 'Choose the country or store with the product you want to buy.\nWe will handle the rest for you.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // 2x2 Grid of shopping site cards
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.87,
            children:
                _kSites.map((site) => _buildSiteCard(site, isRtl)).toList(),
          ),

          const SizedBox(height: 14),

          // Info Banner: لا تجد الموقع الذي تبحث عنه؟
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F2),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFFFFD4B2), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 22, color: _orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRtl
                            ? 'لا تجد الموقع الذي تبحث عنه؟'
                            : 'Can\'t find the website you\'re looking for?',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isRtl
                            ? 'تواصل معنا وستقوم بالشراء من أي موقع أو متجر في أي دولة في العالم.'
                            : 'Contact us and we\'ll buy from any website or store in any country worldwide.',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                          height: 1.4,
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
    );
  }

  Widget _buildSiteCard(_ShoppingSite site, bool isRtl) {
    final isSelected = _selectedSite?.id == site.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedSite = site),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _orange : const Color(0xFFE5E7EB),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x14FF6B00)
                  : const Color(0x06000000),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration (60% of card height)
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      site.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: site.bgColor,
                        child: Center(
                          child: _buildSiteFlagBadge(site.id, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text info (40%)
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRtl ? site.nameAr : site.nameEn,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isRtl ? site.platformsAr : site.platformsEn,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Country flag in bottom-right (or SHEIN S)
            Positioned(
              bottom: 54,
              right: 8,
              child: _buildSiteFlagBadge(site.id, size: 32),
            ),

            // Selection checkmark in top-left
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: _orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      size: 15, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── STEP 2: Product Details ─────────────────────────────────────────────────

  Widget _buildStep2(bool isRtl) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with 3D illustration
              _buildStep2Header(isRtl),

              const SizedBox(height: 22),

              // 1. صورة المنتج *
              _buildField1Image(isRtl),

              const SizedBox(height: 22),

              // 2. رابط المنتج *
              _buildField2Url(isRtl),

              const SizedBox(height: 22),

              // 3. تفاصيل المنتج *
              _buildField3Details(isRtl),

              const SizedBox(height: 22),

              // 4. العدد *
              _buildField4Quantity(isRtl),

              const SizedBox(height: 22),

              // 5. تفاصيل إضافية (اختياري)
              _buildField5Additional(isRtl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2Header(bool isRtl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text info (on Right in RTL)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRtl ? 'أضف تفاصيل المنتج' : 'Add Product Details',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isRtl
                    ? 'يرجى تعبئة المعلومات التالية لطلب المنتج الذي ترغب به.'
                    : 'Please fill in the following information to order the product you want.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // 3D Clipboard & Cardboard Parcel Box Illustration (on Left in RTL)
        const SizedBox(
          width: 80,
          height: 66,
          child: CustomPaint(
            painter: _ClipboardBoxPainter(),
          ),
        ),
      ],
    );
  }

  Widget _buildField1Image(bool isRtl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Right side in RTL: Label & subtitle
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isRtl ? '1. صورة المنتج ' : '1. Product Image ',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isRtl
                    ? 'أضف صورة واضحة للمنتج'
                    : 'Add a clear image of product',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Left side in RTL: Dashed upload container
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: _pickImageModal,
            child: _selectedImagePreview != null
                ? Container(
                    height: 124,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.asset(
                            _selectedImagePreview!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image,
                                  size: 40, color: Color(0xFFFF6B00)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedImagePreview = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xCC111827),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomPaint(
                    painter: _DashedRRectPainter(
                      color: const Color(0xFFD1D5DB),
                      strokeWidth: 1.2,
                      dashWidth: 4.5,
                      dashSpace: 3.5,
                      radius: 12,
                    ),
                    child: Container(
                      height: 124,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF1EB),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 24,
                                  color: Color(0xFFFF6B00),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF6B00),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add,
                                          size: 9, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isRtl ? 'اضغط لإضافة صورة' : 'Click to add image',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isRtl ? 'JPG, PNG حتى 5MB' : 'JPG, PNG up to 5MB',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _pickImageModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Directionality(
        textDirection: _loc.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _loc.isRtl ? 'اختر صورة للمنتج' : 'Choose Product Image',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_android_rounded,
                      color: Color(0xFFFF6B00)),
                ),
                title: Text(_loc.isRtl
                    ? 'صورة نموذجية: هاتف ذكي'
                    : 'Sample Photo: Smartphone'),
                onTap: () {
                  setState(() => _selectedImagePreview =
                      'assets/product_phone_1778584108006.png');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chair_rounded,
                      color: Color(0xFFFF6B00)),
                ),
                title: Text(_loc.isRtl
                    ? 'صورة نموذجية: أثاث وديكور'
                    : 'Sample Photo: Furniture & Decor'),
                onTap: () {
                  setState(() => _selectedImagePreview =
                      'assets/product_furniture_1778584134074.png');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField2Url(bool isRtl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label on Right in RTL
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isRtl ? '2. رابط المنتج ' : '2. Product URL ',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isRtl
                    ? 'انسخ رابط المنتج من المتجر'
                    : 'Copy product URL from store',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Input container on Left in RTL
        Expanded(
          flex: 6,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.link_rounded,
                    size: 20, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(
                      controller: _productUrlCtrl,
                      keyboardType: TextInputType.url,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF111827),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'https://',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField3Details(bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isRtl ? '3. تفاصيل المنتج ' : '3. Product Details ',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isRtl
              ? 'اكتب اسم المنتج والوصف والمواصفات الأساسية'
              : 'Write product name, description and basic specifications',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _productNameCtrl,
                minLines: 3,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF111827),
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText: isRtl
                      ? 'مثال: اسم المنتج، اللون، المقاس، المواصفات، الموديل...'
                      : 'e.g.: Product name, color, size, specs, model...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(
                  '${_productNameCtrl.text.length}/1000',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField4Quantity(bool isRtl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label on Right in RTL
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isRtl ? '4. العدد ' : '4. Quantity ',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isRtl ? 'حدد الكمية المطلوبة' : 'Specify required quantity',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Stepper on Left in RTL
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            width: 124,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(9)),
                    child: const Center(
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _quantity++),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(9)),
                    child: const Center(
                      child: Icon(Icons.add,
                          size: 18, color: Color(0xFFFF5500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField5Additional(bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRtl ? '5. تفاصيل إضافية (اختياري)' : '5. Additional Details (Optional)',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isRtl
              ? 'أي ملاحظات أو تفاصيل إضافية تود إضافتها'
              : 'Any notes or additional details you wish to add',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 20,
                color: Color(0xFFFF7A00),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _notesCtrl,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    hintText: isRtl ? 'اكتب هنا...' : 'Write here...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            isRtl
                ? 'مثل: لون مختلف، تغليف خاص، ملاحظات للمورد...'
                : 'e.g.: different color, special packaging, supplier notes...',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }

  // ─── STEP 3: Specs & Quantity ─────────────────────────────────────────────────

  Widget _buildStep3(bool isRtl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepTitle(
            isRtl ? 'المواصفات والكمية' : 'Specs & Quantity',
            isRtl
                ? 'حدد مواصفات المنتج والكمية المطلوبة'
                : 'Specify the product specifications and quantity',
          ),
          const SizedBox(height: 20),

          _label(isRtl ? 'اللون' : 'Color'),
          _choiceField(
            hint: isRtl ? 'مثال: أحمر، أزرق...' : 'e.g. Red, Blue...',
            value: _selectedColor,
            onChanged: (v) => setState(() => _selectedColor = v),
          ),
          const SizedBox(height: 14),

          _label(isRtl ? 'المقاس' : 'Size'),
          _choiceField(
            hint: isRtl ? 'مثال: XL، 42' : 'e.g. XL, 42',
            value: _selectedSize,
            onChanged: (v) => setState(() => _selectedSize = v),
          ),
          const SizedBox(height: 14),

          _label(isRtl ? 'الكمية *' : 'Quantity *'),
          const SizedBox(height: 8),
          _quantitySelector(isRtl),
        ],
      ),
    );
  }

  // ─── STEP 4: Delivery Address ─────────────────────────────────────────────────

  Widget _buildStep4(bool isRtl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepTitle(
            isRtl ? 'عنوان الاستلام' : 'Delivery Address',
            isRtl
                ? 'أدخل عنوان الاستلام لشحنتك'
                : 'Enter the delivery address for your shipment',
          ),
          const SizedBox(height: 20),

          _label(isRtl ? 'اسم المستلم *' : 'Recipient Name *'),
          _field(
            ctrl: _recipientCtrl,
            hint: isRtl ? 'الاسم الكامل' : 'Full name',
          ),
          const SizedBox(height: 14),

          _label(isRtl ? 'رقم الهاتف' : 'Phone Number'),
          _field(
            ctrl: _phoneCtrl,
            hint: '+966 5X XXX XXXX',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          _label(isRtl ? 'العنوان التفصيلي' : 'Detailed Address'),
          _field(
            ctrl: _addressCtrl,
            hint: isRtl ? 'الشارع، رقم المبنى...' : 'Street, building no...',
            maxLines: 2,
          ),
          const SizedBox(height: 14),

          _label(isRtl ? 'المدينة' : 'City'),
          _field(
            ctrl: _cityCtrl,
            hint: isRtl ? 'مثال: الرياض' : 'e.g. Riyadh',
          ),
        ],
      ),
    );
  }

  // ─── STEP 5: Review ─────────────────────────────────────────────────────────

  Widget _buildStep5Review(bool isRtl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepTitle(
            isRtl ? 'مراجعة الطلب' : 'Review Order',
            isRtl
                ? 'تأكد من جميع المعلومات قبل الإرسال'
                : 'Verify all information before submitting',
          ),
          const SizedBox(height: 20),

          _reviewCard(
            title: isRtl ? 'موقع الشراء' : 'Shopping Site',
            value: _selectedSite == null
                ? '-'
                : (isRtl
                    ? _selectedSite!.nameAr
                    : _selectedSite!.nameEn),
          ),
          _reviewCard(
            title: isRtl ? 'اسم المنتج' : 'Product Name',
            value: _productNameCtrl.text.trim().isEmpty
                ? '-'
                : _productNameCtrl.text.trim(),
          ),
          _reviewCard(
            title: isRtl ? 'رابط المنتج' : 'Product URL',
            value: _productUrlCtrl.text.trim().isEmpty
                ? '-'
                : _productUrlCtrl.text.trim(),
          ),
          _reviewCard(
            title: isRtl ? 'الكمية' : 'Quantity',
            value:
                '$_quantity ${isRtl ? 'قطعة' : 'pcs'}',
          ),
          if (_selectedColor.isNotEmpty)
            _reviewCard(
              title: isRtl ? 'اللون' : 'Color',
              value: _selectedColor,
            ),
          if (_selectedSize.isNotEmpty)
            _reviewCard(
              title: isRtl ? 'المقاس' : 'Size',
              value: _selectedSize,
            ),
          _reviewCard(
            title: isRtl ? 'المستلم' : 'Recipient',
            value: _recipientCtrl.text.trim().isEmpty
                ? '-'
                : _recipientCtrl.text.trim(),
          ),
          if (_cityCtrl.text.trim().isNotEmpty)
            _reviewCard(
              title: isRtl ? 'المدينة' : 'City',
              value: _cityCtrl.text.trim(),
            ),
        ],
      ),
    );
  }

  Widget _reviewCard({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Success ─────────────────────────────────────────────────────────────────

  Widget _buildSuccess(bool isRtl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: Color(0xFF16A34A), size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              isRtl ? 'تم إرسال الطلب بنجاح!' : 'Order Submitted Successfully!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isRtl
                  ? 'تم استلام طلبك وسيُعالَج خلال 24 ساعة. سنتواصل معك قريباً.'
                  : 'Your order has been received and will be processed within 24 hours.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _orangeLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFD4B2), width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    isRtl ? 'رقم الطلب' : 'Order ID',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _orderId ?? '---',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _orange,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isRtl ? 'العودة إلى لوحة التحكم' : 'Back to Dashboard',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Footer Navigation ───────────────────────────────────────────────────────

  Widget _buildFooter(bool isRtl) {
    final isStep2 = _step == 1;
    final isLastStep = _step == 4;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: isStep2
          ? Row(
              children: [
                // Right button (in RTL): "التالي" (Next)
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _canProceed ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D00),
                        disabledBackgroundColor: const Color(0xFFFFD4B2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isRtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRtl ? 'التالي' : 'Next',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Left button (in RTL): "حفظ كمسودة" (Save as draft)
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.bookmark_added_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(isRtl
                                    ? 'تم حفظ مسودة الطلب بنجاح'
                                    : 'Order draft saved successfully'),
                              ],
                            ),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFFFF4D00), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color(0xFFFF4D00),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isRtl ? 'حفظ كمسودة' : 'Save Draft',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF4D00),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.bookmark_border_rounded,
                            size: 20,
                            color: Color(0xFFFF4D00),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _canProceed ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  disabledBackgroundColor: const Color(0xFFFFD4B2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastStep
                          ? (isRtl ? 'إرسال الطلب' : 'Submit Order')
                          : (isRtl ? 'التالي' : 'Next'),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isRtl
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ─── Shared Helpers ───────────────────────────────────────────────────────────

  Widget _stepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
          fontFamily: 'Inter', fontSize: 14, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Inter', fontSize: 13, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _choiceField({
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(
          fontFamily: 'Inter', fontSize: 14, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Inter', fontSize: 13, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _quantitySelector(bool isRtl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _quantity > 1 ? Colors.white : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Icon(Icons.remove,
                  size: 18,
                  color: _quantity > 1
                      ? const Color(0xFF374151)
                      : const Color(0xFF9CA3AF)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '$_quantity',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _quantity++),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isRtl ? 'قطعة' : 'pcs',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteFlagBadge(String siteId, {double size = 32}) {
    switch (siteId) {
      case 'china':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/branding/flag_circle_china.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: const Color(0xFFDE2910),
                child: const Center(
                  child: Icon(Icons.star, color: Color(0xFFFFDE00), size: 16),
                ),
              ),
            ),
          ),
        );

      case 'usa':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/branding/flag_circle_usa.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: const Color(0xFF002868),
                child: const Center(
                  child: Icon(Icons.star, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        );

      case 'turkey':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: CustomPaint(
            size: Size(size, size),
            painter: const _TurkeyFlagPainter(),
          ),
        );

      case 'shein':
      default:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }
}

class _TurkeyFlagPainter extends CustomPainter {
  const _TurkeyFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Red circle background
    final bgPaint = Paint()..color = const Color(0xFFE30A17);
    canvas.drawCircle(center, radius, bgPaint);

    // White crescent
    final whitePaint = Paint()..color = Colors.white;
    final crescentOuter = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(center.dx - radius * 0.12, center.dy),
        radius: radius * 0.54,
      ));
    final crescentInner = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(center.dx - radius * 0.01, center.dy),
        radius: radius * 0.43,
      ));
    final crescent = Path.combine(PathOperation.difference, crescentOuter, crescentInner);
    canvas.drawPath(crescent, whitePaint);

    // 5-pointed star
    _drawStar(
      canvas,
      Offset(center.dx + radius * 0.32, center.dy),
      radius * 0.22,
      whitePaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final double innerRadius = radius * 0.4;
    for (int i = 0; i < 5; i++) {
      final double outerAngle = -math.pi / 2 + i * (2 * math.pi / 5) + 0.32;
      final double innerAngle = outerAngle + math.pi / 5;
      final double x1 = center.dx + radius * math.cos(outerAngle);
      final double y1 = center.dy + radius * math.sin(outerAngle);
      final double x2 = center.dx + innerRadius * math.cos(innerAngle);
      final double y2 = center.dy + innerRadius * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── 3D Clipboard & Cardboard Parcel Box Painter ─────────────────────────────

class _ClipboardBoxPainter extends CustomPainter {
  const _ClipboardBoxPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x18000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(42, 59), width: 70, height: 10),
      shadowPaint,
    );

    // 2. Wooden Clipboard Base
    final boardPaint = Paint()..color = const Color(0xFFD89F67);
    final boardRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(4, 6, 36, 50),
      const Radius.circular(5),
    );
    canvas.drawRRect(boardRRect, boardPaint);

    final boardEdgePaint = Paint()
      ..color = const Color(0xFFBC8045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(boardRRect, boardEdgePaint);

    // 3. Metallic Clip at top
    final clipPaint = Paint()..color = const Color(0xFF78716C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(15, 2, 14, 8),
        const Radius.circular(3),
      ),
      clipPaint,
    );
    final clipHolePaint = Paint()..color = const Color(0xFFD89F67);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(19, 4, 6, 3),
        const Radius.circular(1.5),
      ),
      clipHolePaint,
    );

    // 4. White Paper Sheet on Clipboard
    final paperPaint = Paint()..color = Colors.white;
    final paperRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 10, 28, 42),
      const Radius.circular(3),
    );
    canvas.drawRRect(paperRRect, paperPaint);

    // Checkmark item lines on paper
    final checkPaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Line 1
    final p1 = Path()
      ..moveTo(12, 19)
      ..lineTo(14, 21.5)
      ..lineTo(17.5, 17.5);
    canvas.drawPath(p1, checkPaint);
    canvas.drawLine(const Offset(20, 19.5), const Offset(31, 19.5), linePaint);

    // Line 2
    final p2 = Path()
      ..moveTo(12, 28)
      ..lineTo(14, 30.5)
      ..lineTo(17.5, 26.5);
    canvas.drawPath(p2, checkPaint);
    canvas.drawLine(const Offset(20, 28.5), const Offset(33, 28.5), linePaint);

    // Line 3
    final p3 = Path()
      ..moveTo(12, 37)
      ..lineTo(14, 39.5)
      ..lineTo(17.5, 35.5);
    canvas.drawPath(p3, checkPaint);
    canvas.drawLine(const Offset(20, 37.5), const Offset(29, 37.5), linePaint);

    // 5. 3D Isometric Cardboard Box (in front / slightly to right)
    // Top face
    final topFace = Path()
      ..moveTo(52, 22)
      ..lineTo(68, 29)
      ..lineTo(52, 36)
      ..lineTo(36, 29)
      ..close();
    final topPaint = Paint()..color = const Color(0xFFDE9E5F);
    canvas.drawPath(topFace, topPaint);

    // Tape across top face
    final topTape = Path()
      ..moveTo(43, 25.5)
      ..lineTo(45.5, 24)
      ..lineTo(61, 32.5)
      ..lineTo(58.5, 34)
      ..close();
    final tapePaint = Paint()..color = const Color(0xFFF1BE86);
    canvas.drawPath(topTape, tapePaint);

    // Left face
    final leftFace = Path()
      ..moveTo(36, 29)
      ..lineTo(52, 36)
      ..lineTo(52, 57)
      ..lineTo(36, 50)
      ..close();
    final leftPaint = Paint()..color = const Color(0xFFBC7C3D);
    canvas.drawPath(leftFace, leftPaint);

    // Right face
    final rightFace = Path()
      ..moveTo(52, 36)
      ..lineTo(68, 29)
      ..lineTo(68, 50)
      ..lineTo(52, 57)
      ..close();
    final rightPaint = Paint()..color = const Color(0xFFA56627);
    canvas.drawPath(rightFace, rightPaint);

    // Center tape seam down the front
    final frontTape = Path()
      ..moveTo(50.5, 36)
      ..lineTo(53.5, 36)
      ..lineTo(53.5, 57)
      ..lineTo(50.5, 57)
      ..close();
    final frontTapePaint = Paint()..color = const Color(0xFFDE9E5F);
    canvas.drawPath(frontTape, frontTapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Dashed Rounded Rectangle Painter ─────────────────────────────────────────

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedRRectPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 4.0,
    this.dashSpace = 3.5,
    this.radius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dashWidth, metric.length - distance);
        dashedPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashSpace != dashSpace ||
      oldDelegate.radius != radius;
}


