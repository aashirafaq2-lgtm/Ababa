import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/china_box_localization.dart';
import 'china_box_previous_orders_page.dart';
import '../../../domain/models/futian_models.dart';
import '../../../data/repositories/api_futian_repository.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class _OrderMilestone {
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final IconData icon;
  final String? dateAr;
  final String? dateEn;
  final String? timeAr;
  final String? timeEn;
  final bool isCompleted;
  final bool isActive;
  final bool hasSoonBadge;

  const _OrderMilestone({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.icon,
    this.dateAr,
    this.dateEn,
    this.timeAr,
    this.timeEn,
    this.isCompleted = false,
    this.isActive = false,
    this.hasSoonBadge = false,
  });
}

const _kMilestones = [
  _OrderMilestone(
    titleAr: 'تم استلام الطلب',
    titleEn: 'Order Received',
    subtitleAr: 'تم استلام طلبك بنجاح',
    subtitleEn: 'Your order was received successfully',
    icon: Icons.all_inbox_rounded,
    dateAr: '23 مايو 2025',
    dateEn: '23 May 2025',
    timeAr: '09:30 ص',
    timeEn: '09:30 AM',
    isCompleted: true,
  ),
  _OrderMilestone(
    titleAr: 'جاري مراجعة المنتج',
    titleEn: 'Reviewing Product',
    subtitleAr: 'نقوم بمراجعة المنتج والتأكد من توفره وسعره',
    subtitleEn: 'We are reviewing the product, availability and price',
    icon: Icons.search_rounded,
    dateAr: '23 مايو 2025',
    dateEn: '23 May 2025',
    timeAr: '10:15 ص',
    timeEn: '10:15 AM',
    isCompleted: true,
  ),
  _OrderMilestone(
    titleAr: 'تم تحديد السعر',
    titleEn: 'Price Determined',
    subtitleAr: 'سيتم إرسال السعر الإجمالي لك قريباً',
    subtitleEn: 'Total price will be sent to you shortly',
    icon: Icons.account_balance_wallet_outlined,
    isActive: true,
    hasSoonBadge: true,
  ),
  _OrderMilestone(
    titleAr: 'بانتظار موافقتك',
    titleEn: 'Awaiting Your Approval',
    subtitleAr: 'ننتظر موافقتك للمتابعة والدفع',
    subtitleEn: 'Waiting for your approval to proceed and pay',
    icon: Icons.access_time_rounded,
  ),
  _OrderMilestone(
    titleAr: 'الدفع',
    titleEn: 'Payment',
    subtitleAr: 'سيتم تأكيد الطلب بعد الدفع',
    subtitleEn: 'Order will be confirmed after payment',
    icon: Icons.credit_card_rounded,
  ),
  _OrderMilestone(
    titleAr: 'تم شراء المنتج',
    titleEn: 'Product Purchased',
    subtitleAr: 'تم شراء المنتج من الموقع',
    subtitleEn: 'Product was purchased from the website',
    icon: Icons.shopping_cart_outlined,
  ),
  _OrderMilestone(
    titleAr: 'تم الشحن إلى مخزن A.BABA',
    titleEn: 'Shipped to A.BABA Warehouse',
    subtitleAr: 'تم شحن المنتج ووصل إلى مخزننا في البلد المختار',
    subtitleEn: 'Product shipped and reached our warehouse in chosen country',
    icon: Icons.local_shipping_outlined,
  ),
  _OrderMilestone(
    titleAr: 'وصل إلى المخزن',
    titleEn: 'Arrived at Warehouse',
    subtitleAr: 'وصل المنتج إلى مخزننا وهو جاهز للشحن إليك',
    subtitleEn: 'Product arrived at warehouse and is ready for dispatch',
    icon: Icons.inventory_2_outlined,
  ),
];

// ─── Main Page ────────────────────────────────────────────────────────────────

class OrderDetailsTrackingPage extends StatefulWidget {
  final String orderId;
  final String siteNameAr;
  final String siteNameEn;
  final String statusAr;
  final String statusEn;
  final String orderDateAr;
  final String orderDateEn;
  final String productNameAr;
  final String productNameEn;
  final String productUrl;
  final int quantity;

  const OrderDetailsTrackingPage({
    super.key,
    this.orderId = '#AB-2505237',
    this.siteNameAr = 'الصين',
    this.siteNameEn = 'China',
    this.statusAr = 'جاري مراجعة المنتج',
    this.statusEn = 'Reviewing Product',
    this.orderDateAr = '23 مايو 2025, 09:30 ص',
    this.orderDateEn = '23 May 2025, 09:30 AM',
    this.productNameAr = 'سماعة بلوتوث لاسلكية',
    this.productNameEn = 'Wireless Bluetooth Headphones',
    this.productUrl = 'https://item.taobao.com/1234567890',
    this.quantity = 2,
  });

  @override
  State<OrderDetailsTrackingPage> createState() =>
      _OrderDetailsTrackingPageState();
}

class _OrderDetailsTrackingPageState extends State<OrderDetailsTrackingPage> {
  final _loc = ChinaBoxLocalization();
  bool _isProductDetailsExpanded = false;

  static const Color _orange = Color(0xFFFF5500);
  static const Color _orangeLight = Color(0xFFFFF8F4);
  static const Color _green = Color(0xFF10B981);
  static const Color _greenLight = Color(0xFFECFDF5);

  FutianOrderDetail? _liveDetail;
  bool _isLoading = true;
  bool _isApproving = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    setState(() => _isLoading = true);
    try {
      final detail = await ApiFutianRepository.instance.getOrderDetail(widget.orderId);
      if (mounted) {
        setState(() {
          _liveDetail = detail;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleApprovePrice() async {
    setState(() => _isApproving = true);
    try {
      final success = await ApiFutianRepository.instance.approvePrice(widget.orderId);
      if (mounted) {
        setState(() => _isApproving = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_loc.isRtl
                  ? 'تمت الموافقة على السعر بنجاح! تم تحويل الطلب إلى الشراء.'
                  : 'Price approved successfully! Order advanced to Purchased.'),
              backgroundColor: _green,
            ),
          );
          _fetchOrderDetail();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_loc.isRtl
                  ? 'تعذر تأكيد الموافقة، يرجى المحاولة لاحقاً.'
                  : 'Could not approve pricing, please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isApproving = false);
      }
    }
  }

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: widget.orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(_loc.isRtl ? 'تم نسخ رقم الطلب' : 'Order ID copied!'),
          ],
        ),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openSupportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Directionality(
        textDirection: _loc.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: _orangeLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.headset_mic_outlined,
                          color: _orange, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _loc.isRtl ? 'فريق الدعم والمساعدة' : 'Support Team',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _loc.isRtl
                            ? 'نحن هنا لمساعدتك على مدار الساعة'
                            : 'We are here to assist you 24/7',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline_rounded,
                    color: _orange),
                title: Text(_loc.isRtl ? 'محادثة فورية' : 'Live Chat'),
                subtitle: Text(_loc.isRtl
                    ? 'تحدث مع أحد ممثلي الخدمة'
                    : 'Chat with our customer service'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_loc.isRtl
                          ? 'جاري فتح المحادثة الفورية...'
                          : 'Opening live chat...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: _green),
                title: Text(_loc.isRtl ? 'الاتصال الهاتفي' : 'Phone Call'),
                subtitle: const Text('+966 800 123 4567'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
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
            backgroundColor: const Color(0xFFF7F8FA),
            body: SafeArea(
              child: Column(
                children: [
                  // ─── Header
                  _buildHeader(isRtl),

                  // ─── Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Status Announcement Banner
                          _buildAnnouncementBanner(isRtl),

                          const SizedBox(height: 14),

                          // 2. Order Information Card
                          _buildOrderInfoCard(isRtl),

                          const SizedBox(height: 18),

                          // 3. Section Title: "مراحل الطلب"
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              isRtl ? 'مراحل الطلب' : 'Order Stages',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 4. Vertical Timeline Card
                          _buildTimelineCard(isRtl),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  // ─── Fixed Footer Bar
                  _buildFooter(isRtl),
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
            _loc.isRtl ? 'تفاصيل الطلب' : 'Order Details',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),

          // Support Button
          GestureDetector(
            onTap: _openSupportSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _loc.isRtl ? 'مساعدة' : 'Help',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.headset_mic_outlined,
                  size: 20,
                  color: Color(0xFF111827),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 1. Announcement Banner ──────────────────────────────────────────────────

  Widget _buildAnnouncementBanner(bool isRtl) {
    return Container(
      decoration: BoxDecoration(
        color: _orangeLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE8D6), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Orange Clock Icon (on Right in RTL)
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1EB),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.access_time_rounded,
                size: 20,
                color: _orange,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Announcement Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRtl
                      ? 'حالة طلبك يتم تحديثها بشكل مستمر'
                      : 'Your order status is updated continuously',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isRtl
                      ? 'ستصلك إشعارات بكل مرحلة من مراحل الطلب'
                      : 'You will receive notifications for each order stage',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 3D Clipboard & Parcel Illustration (on Left in RTL)
          const SizedBox(
            width: 62,
            height: 50,
            child: CustomPaint(
              painter: _ClipboardBoxSmallPainter(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. Order Information Card ───────────────────────────────────────────────

  Widget _buildOrderInfoCard(bool isRtl) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: موقع الشراء & رقم الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // موقع الشراء
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRtl ? 'موقع الشراء' : 'Shopping Site',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isRtl ? widget.siteNameAr : widget.siteNameEn,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ClipOval(
                        child: Image.asset(
                          'assets/branding/flag_circle_china.jpg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDE2910),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('🇨🇳', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // رقم الطلب
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isRtl ? 'رقم الطلب' : 'Order ID',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.orderId,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _copyOrderId,
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: _orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: الحالة الحالية & تاريخ الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الحالة الحالية
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRtl ? 'الحالة الحالية' : 'Current Status',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: _orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isRtl ? widget.statusAr : widget.statusEn,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: _orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // تاريخ الطلب
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isRtl ? 'تاريخ الطلب' : 'Order Date',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRtl ? widget.orderDateAr : widget.orderDateEn,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Embedded Product Card ──
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDEDF0), width: 1),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Thumbnail (on Left in RTL)
                const SizedBox(
                  width: 84,
                  height: 84,
                  child: _Earbuds3DThumbnail(),
                ),

                const SizedBox(width: 12),

                // Product Details Info (on Right in RTL)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRtl ? widget.productNameAr : widget.productNameEn,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isRtl ? 'رابط المنتج' : 'Product Link',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: widget.productUrl));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRtl
                                  ? 'تم نسخ رابط المنتج'
                                  : 'Product URL copied!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Text(
                          widget.productUrl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4F46E5),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${isRtl ? 'العدد' : 'Qty'}: ${widget.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Dropdown: "عرض التفاصيل"
                      GestureDetector(
                        onTap: () => setState(() =>
                            _isProductDetailsExpanded = !_isProductDetailsExpanded),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isProductDetailsExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: const Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isRtl ? 'عرض التفاصيل' : 'View Details',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expanded Details Section
          if (_isProductDetailsExpanded) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRtl
                        ? 'المواصفات: اللون أبيض، بلوتوث 5.3، بطارية 30 ساعة، شحن تايب سي'
                        : 'Specs: Color White, BT 5.3, 30h battery, Type-C charging',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: Color(0xFF4B5563),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── 3. Vertical Timeline Card ───────────────────────────────────────────────

  Widget _buildTimelineCard(bool isRtl) {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        children: List.generate(_kMilestones.length, (i) {
          final m = _kMilestones[i];
          final isLast = i == _kMilestones.length - 1;
          return _buildMilestoneRow(m, isLast: isLast, isRtl: isRtl);
        }),
      ),
    );
  }

  Widget _buildMilestoneRow(_OrderMilestone m,
      {required bool isLast, required bool isRtl}) {
    return Container(
      decoration: BoxDecoration(
        color: m.isActive ? _orangeLight : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: m.isActive ? 8 : 4,
        vertical: m.isActive ? 8 : 6,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Date & Time or "الحالي" (in RTL)
            SizedBox(
              width: 66,
              child: m.isActive
                  ? Text(
                      isRtl ? 'الحالي' : 'Current',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: _orange,
                      ),
                    )
                  : m.dateAr != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRtl ? m.dateAr! : m.dateEn!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isRtl ? m.timeAr! : m.timeEn!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.5,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
            ),

            const SizedBox(width: 8),

            // Node indicator & vertical line
            Column(
              children: [
                // Node circle
                if (m.isCompleted)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 13, color: Colors.white),
                    ),
                  )
                else if (m.isActive)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _orange, width: 2.2),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFD1D5DB), width: 1.6),
                    ),
                  ),

                // Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: m.isCompleted
                          ? _green
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Icon Box
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: m.isCompleted
                    ? _greenLight
                    : m.isActive
                        ? const Color(0xFFFFF1EB)
                        : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  m.icon,
                  size: 20,
                  color: m.isCompleted
                      ? _green
                      : m.isActive
                          ? _orange
                          : const Color(0xFF6B7280),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Text Info: Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        isRtl ? m.titleAr : m.titleEn,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: m.isActive || m.isCompleted
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: m.isActive || m.isCompleted
                              ? const Color(0xFF111827)
                              : const Color(0xFF374151),
                        ),
                      ),
                      if (m.hasSoonBadge) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBDD),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            isRtl ? 'قريباً' : 'Soon',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _orange,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isRtl ? m.subtitleAr : m.subtitleEn,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: m.isActive
                          ? const Color(0xFF4B5563)
                          : const Color(0xFF6B7280),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 4. Fixed Footer ─────────────────────────────────────────────────────────

  Widget _buildFooter(bool isRtl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        children: [
          // Right Button in RTL: "الطلبات السابقة" (Previous Orders)
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChinaBoxPreviousOrdersPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      isRtl ? 'الطلبات السابقة' : 'Previous Orders',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Left Button in RTL: "تحتاج مساعدة؟" (Need Help?)
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: _openSupportSheet,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFFE8D6), width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRtl ? 'تحتاج مساعدة؟' : 'Need Help?',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            isRtl
                                ? 'فريق الدعم جاهز لمساعدتك'
                                : 'Support ready to help',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                      color: _orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 3D Earbuds Thumbnail Widget ──────────────────────────────────────────────

class _Earbuds3DThumbnail extends StatelessWidget {
  const _Earbuds3DThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft ambient drop shadow
          Positioned(
            bottom: 12,
            child: Container(
              width: 52,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0x14000000),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // White Wireless Earbuds Case
          Container(
            width: 58,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFE5E7EB)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Earbud tips inside
                Positioned(
                  top: 8,
                  left: 14,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1D5DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 14,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1D5DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Seam line
                Positioned(
                  top: 24,
                  left: 6,
                  right: 6,
                  child: Container(
                    height: 1,
                    color: const Color(0xFFD1D5DB),
                  ),
                ),
                // Tiny power LED
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: 3.5,
                    height: 3.5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9CA3AF),
                      shape: BoxShape.circle,
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
}

// ─── Small 3D Clipboard & Parcel Painter ─────────────────────────────────────

class _ClipboardBoxSmallPainter extends CustomPainter {
  const _ClipboardBoxSmallPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x14000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(32, 44), width: 54, height: 8),
      shadowPaint,
    );

    // 2. Clipboard Base
    final boardPaint = Paint()..color = const Color(0xFFD89F67);
    final boardRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 4, 28, 38),
      const Radius.circular(4),
    );
    canvas.drawRRect(boardRRect, boardPaint);

    // Metal Clip
    final clipPaint = Paint()..color = const Color(0xFF78716C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(12, 1, 10, 6),
        const Radius.circular(2),
      ),
      clipPaint,
    );

    // Paper Sheet
    final paperPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6, 7, 22, 32),
        const Radius.circular(2),
      ),
      paperPaint,
    );

    // Checkmarks
    final checkPaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Line 1
    final p1 = Path()
      ..moveTo(9, 14)
      ..lineTo(10.5, 16)
      ..lineTo(13.5, 13);
    canvas.drawPath(p1, checkPaint);
    canvas.drawLine(const Offset(15, 14.5), const Offset(24, 14.5), linePaint);

    // Line 2
    final p2 = Path()
      ..moveTo(9, 21)
      ..lineTo(10.5, 23)
      ..lineTo(13.5, 20);
    canvas.drawPath(p2, checkPaint);
    canvas.drawLine(const Offset(15, 21.5), const Offset(25, 21.5), linePaint);

    // Line 3
    final p3 = Path()
      ..moveTo(9, 28)
      ..lineTo(10.5, 30)
      ..lineTo(13.5, 27);
    canvas.drawPath(p3, checkPaint);
    canvas.drawLine(const Offset(15, 28.5), const Offset(22, 28.5), linePaint);

    // 3. Cardboard Parcel Box
    // Top face
    final topFace = Path()
      ..moveTo(42, 16)
      ..lineTo(54, 21)
      ..lineTo(42, 26)
      ..lineTo(30, 21)
      ..close();
    canvas.drawPath(topFace, Paint()..color = const Color(0xFFDE9E5F));

    // Left face
    final leftFace = Path()
      ..moveTo(30, 21)
      ..lineTo(42, 26)
      ..lineTo(42, 42)
      ..lineTo(30, 37)
      ..close();
    canvas.drawPath(leftFace, Paint()..color = const Color(0xFFBC7C3D));

    // Right face
    final rightFace = Path()
      ..moveTo(42, 26)
      ..lineTo(54, 21)
      ..lineTo(54, 37)
      ..lineTo(42, 42)
      ..close();
    canvas.drawPath(rightFace, Paint()..color = const Color(0xFFA56627));

    // Tape Seam
    final tapeSeam = Path()
      ..moveTo(40.5, 26)
      ..lineTo(43.5, 26)
      ..lineTo(43.5, 42)
      ..lineTo(40.5, 42)
      ..close();
    canvas.drawPath(tapeSeam, Paint()..color = const Color(0xFFDE9E5F));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
