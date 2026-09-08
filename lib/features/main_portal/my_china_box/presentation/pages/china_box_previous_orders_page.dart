import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/china_box_localization.dart';
import 'order_details_tracking_page.dart';
import 'add_new_order_flow_page.dart';
import '../../../domain/models/futian_models.dart';
import '../../../data/repositories/api_futian_repository.dart';

// ─── Status Filter Enum ─────────────────────────────────────────────────────

enum OrderListStatus {
  all,
  underReview,
  pricePending,
  approvalPending,
  purchased,
  shipped,
  arrived,
  cancelled,
}

// ─── Order Item Model ───────────────────────────────────────────────────────

class _OrderRecord {
  final String orderId;
  final String productNameAr;
  final String productNameEn;
  final String siteNameAr;
  final String siteNameEn;
  final String siteType; // 'china', 'usa', 'turkey', 'shein'
  final int quantity;
  final String dateAr;
  final String dateEn;
  final OrderListStatus status;
  final String statusAr;
  final String statusEn;
  final Color statusColor;
  final Color statusBg;
  final IconData statusIcon;
  final String? imageAsset;
  final String visualType;

  const _OrderRecord({
    required this.orderId,
    required this.productNameAr,
    required this.productNameEn,
    required this.siteNameAr,
    required this.siteNameEn,
    required this.siteType,
    required this.quantity,
    required this.dateAr,
    required this.dateEn,
    required this.status,
    required this.statusAr,
    required this.statusEn,
    required this.statusColor,
    required this.statusBg,
    required this.statusIcon,
    this.imageAsset,
    required this.visualType,
  });
}

// ─── Reference Mock Data (Matching Screenshots 100%) ────────────────────────

const _kOrdersData = [
  // 1. Earbuds
  _OrderRecord(
    orderId: '#AB-2505237',
    productNameAr: 'سماعة بلوتوث لاسلكية',
    productNameEn: 'Wireless Bluetooth Headphones',
    siteNameAr: 'الصين',
    siteNameEn: 'China',
    siteType: 'china',
    quantity: 2,
    dateAr: '23 مايو 2025 - 09:30 ص',
    dateEn: '23 May 2025 - 09:30 AM',
    status: OrderListStatus.underReview,
    statusAr: 'بانتظار المراجعة',
    statusEn: 'Awaiting Review',
    statusColor: Color(0xFFFF5500),
    statusBg: Color(0xFFFFF1EB),
    statusIcon: Icons.access_time_rounded,
    visualType: 'earbuds',
  ),
  // 2. Smart Watch
  _OrderRecord(
    orderId: '#AB-2505219',
    productNameAr: 'ساعة ذكية',
    productNameEn: 'Smart Watch',
    siteNameAr: 'أمريكا',
    siteNameEn: 'America',
    siteType: 'usa',
    quantity: 1,
    dateAr: '22 مايو 2025 - 04:15 م',
    dateEn: '22 May 2025 - 04:15 PM',
    status: OrderListStatus.pricePending,
    statusAr: 'بانتظار التسعير',
    statusEn: 'Awaiting Pricing',
    statusColor: Color(0xFFD97706),
    statusBg: Color(0xFFFEFCE8),
    statusIcon: Icons.local_offer_outlined,
    imageAsset: 'assets/branding/smartwatch_thumb.jpg',
    visualType: 'smartwatch',
  ),
  // 3. Handbag
  _OrderRecord(
    orderId: '#AB-2505188',
    productNameAr: 'شنطة يد نسائية',
    productNameEn: 'Women Handbag',
    siteNameAr: 'تركيا',
    siteNameEn: 'Turkey',
    siteType: 'turkey',
    quantity: 1,
    dateAr: '21 مايو 2025 - 11:20 ص',
    dateEn: '21 May 2025 - 11:20 AM',
    status: OrderListStatus.approvalPending,
    statusAr: 'بانتظار الموافقة',
    statusEn: 'Awaiting Approval',
    statusColor: Color(0xFF9333EA),
    statusBg: Color(0xFFFAF5FF),
    statusIcon: Icons.hourglass_empty_rounded,
    imageAsset: 'assets/branding/handbag_thumb.jpg',
    visualType: 'handbag',
  ),
  // 4. Sneakers
  _OrderRecord(
    orderId: '#AB-2505150',
    productNameAr: 'حذاء رياضي',
    productNameEn: 'Sports Shoes',
    siteNameAr: 'الصين',
    siteNameEn: 'China',
    siteType: 'china',
    quantity: 1,
    dateAr: '20 مايو 2025 - 02:45 م',
    dateEn: '20 May 2025 - 02:45 PM',
    status: OrderListStatus.purchased,
    statusAr: 'تم الشراء',
    statusEn: 'Purchased',
    statusColor: Color(0xFF2563EB),
    statusBg: Color(0xFFEFF6FF),
    statusIcon: Icons.shopping_cart_outlined,
    imageAsset: 'assets/branding/sneakers_thumb.jpg',
    visualType: 'sneakers',
  ),
  // 5. Power Bank
  _OrderRecord(
    orderId: '#AB-2505122',
    productNameAr: 'باور بانك 20000mAh',
    productNameEn: '20000mAh Power Bank',
    siteNameAr: 'SHEIN',
    siteNameEn: 'SHEIN',
    siteType: 'shein',
    quantity: 1,
    dateAr: '19 مايو 2025 - 10:10 ص',
    dateEn: '19 May 2025 - 10:10 AM',
    status: OrderListStatus.shipped,
    statusAr: 'تم الشحن',
    statusEn: 'Shipped',
    statusColor: Color(0xFF0D9488),
    statusBg: Color(0xFFF0FDFA),
    statusIcon: Icons.local_shipping_outlined,
    visualType: 'powerbank',
  ),
  // 6. Sunglasses
  _OrderRecord(
    orderId: '#AB-2505099',
    productNameAr: 'نظارة شمسية',
    productNameEn: 'Sunglasses',
    siteNameAr: 'أمريكا',
    siteNameEn: 'America',
    siteType: 'usa',
    quantity: 1,
    dateAr: '18 مايو 2025 - 01:30 م',
    dateEn: '18 May 2025 - 01:30 PM',
    status: OrderListStatus.arrived,
    statusAr: 'وصل إلى المخزن',
    statusEn: 'Arrived at Warehouse',
    statusColor: Color(0xFF16A34A),
    statusBg: Color(0xFFF0FDF4),
    statusIcon: Icons.inventory_2_outlined,
    visualType: 'sunglasses',
  ),
];

// ─── Main Page ──────────────────────────────────────────────────────────────

class ChinaBoxPreviousOrdersPage extends StatefulWidget {
  const ChinaBoxPreviousOrdersPage({super.key});

  @override
  State<ChinaBoxPreviousOrdersPage> createState() =>
      _ChinaBoxPreviousOrdersPageState();
}

class _ChinaBoxPreviousOrdersPageState
    extends State<ChinaBoxPreviousOrdersPage> {
  final _loc = ChinaBoxLocalization();
  final _searchCtrl = TextEditingController();

  int _selectedTopTab = 0; // 0 = طلباتي (My Orders), 1 = طلبية جديدة (New Order)
  OrderListStatus _activeFilter = OrderListStatus.all;
  String _searchQuery = '';
  int _bottomNavIndex = 2; // Default on center (+ Add Order)

  static const Color _orange = Color(0xFFFF5500);

  List<_OrderRecord> _backendOrders = [];
  FutianOrderMetrics _metrics = const FutianOrderMetrics(
    all: 0,
    underReview: 0,
    pricePending: 0,
    approvalPending: 0,
    purchased: 0,
    shipped: 0,
    arrived: 0,
    cancelled: 0,
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveOrders();
  }

  Future<void> _fetchLiveOrders() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiFutianRepository.instance.getOrders();
      if (mounted) {
        setState(() {
          _metrics = res.metrics;
          if (res.orders.isNotEmpty) {
            _backendOrders = res.orders.map(_mapToRecord).toList();
          } else {
            _backendOrders = [];
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  _OrderRecord _mapToRecord(FutianOrderItem item) {
    final status = _mapBackendStatus(item.status);
    final color = _parseColor(item.statusColorHex, const Color(0xFFFF5500));
    final bg = _parseColor(item.statusBgHex, const Color(0xFFFFF1EB));
    return _OrderRecord(
      orderId: item.orderId,
      productNameAr: item.productNameAr,
      productNameEn: item.productNameEn,
      siteNameAr: item.siteNameAr,
      siteNameEn: item.siteNameEn,
      siteType: item.siteType,
      quantity: item.quantity,
      dateAr: item.createdAt,
      dateEn: item.createdAt,
      status: status,
      statusAr: item.statusAr,
      statusEn: item.statusEn,
      statusColor: color,
      statusBg: bg,
      statusIcon: _statusIconFor(status),
      imageAsset: item.imageAsset,
      visualType: item.visualType,
    );
  }

  Color _parseColor(String hex, Color fallback) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('0xFF$clean'));
    } catch (_) {
      return fallback;
    }
  }

  OrderListStatus _mapBackendStatus(FutianOrderStatus s) {
    switch (s) {
      case FutianOrderStatus.underReview:
        return OrderListStatus.underReview;
      case FutianOrderStatus.pricePending:
        return OrderListStatus.pricePending;
      case FutianOrderStatus.approvalPending:
        return OrderListStatus.approvalPending;
      case FutianOrderStatus.purchased:
        return OrderListStatus.purchased;
      case FutianOrderStatus.shipped:
        return OrderListStatus.shipped;
      case FutianOrderStatus.arrived:
        return OrderListStatus.arrived;
      case FutianOrderStatus.cancelled:
        return OrderListStatus.cancelled;
    }
  }

  IconData _statusIconFor(OrderListStatus s) {
    switch (s) {
      case OrderListStatus.underReview:
        return Icons.access_time_rounded;
      case OrderListStatus.pricePending:
        return Icons.local_offer_outlined;
      case OrderListStatus.approvalPending:
        return Icons.hourglass_empty_rounded;
      case OrderListStatus.purchased:
        return Icons.shopping_cart_outlined;
      case OrderListStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderListStatus.arrived:
        return Icons.inventory_2_outlined;
      case OrderListStatus.cancelled:
        return Icons.cancel_outlined;
      case OrderListStatus.all:
        return Icons.all_inbox_rounded;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _copyOrderId(String orderId) {
    Clipboard.setData(ClipboardData(text: orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(_loc.isRtl
                ? 'تم نسخ رقم الطلب $orderId'
                : 'Order ID $orderId copied'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<_OrderRecord> get _filteredList {
    final source = (_backendOrders.isNotEmpty || !_isLoading)
        ? _backendOrders
        : _kOrdersData;
    return source.where((item) {
      // Filter status
      if (_activeFilter != OrderListStatus.all &&
          item.status != _activeFilter) {
        return false;
      }
      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchId = item.orderId.toLowerCase().contains(q);
        final matchNameAr = item.productNameAr.toLowerCase().contains(q);
        final matchNameEn = item.productNameEn.toLowerCase().contains(q);
        return matchId || matchNameAr || matchNameEn;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (ctx, _) {
        final isRtl = _loc.isRtl;
        final list = _filteredList;

        return Directionality(
          textDirection: _loc.textDirection,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: SafeArea(
              child: Column(
                children: [
                  // ─── 1. Top App Bar: Back < | إضافة طلبية جديدة | مساعدة 🎧
                  _buildTopAppBar(isRtl),

                  // ─── 2. Dual Top Tabs: طلباتي 📋 vs طلبية جديدة (+)
                  _buildDualTabs(isRtl),

                  // ─── Scrollable Content: Metric Cards + Search + Order Cards
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _fetchLiveOrders,
                      color: _orange,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),

                          // ─── 3. Horizontal Status Metrics Grid
                          _buildStatusMetricsCarousel(isRtl),

                          const SizedBox(height: 14),

                          // ─── 4. Search & Filter Bar
                          _buildSearchAndFilterBar(isRtl),

                          const SizedBox(height: 10),

                          // ─── 5. Order Cards List
                          if (list.isEmpty)
                            _buildEmptyState(isRtl)
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (ctx, i) =>
                                  _buildOrderItemCard(list[i], isRtl),
                            ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                  // ─── 6. Bottom Navigation Bar with Center Floating (+)
                  _buildBottomNavigationBar(isRtl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── 1. Top App Bar ──────────────────────────────────────────────────────────

  Widget _buildTopAppBar(bool isRtl) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: Color(0xFF111827),
              ),
            ),
          ),

          // Title: "إضافة طلبية جديدة"
          Text(
            isRtl ? 'إضافة طلبية جديدة' : 'Add New Order',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),

          // Help icon + text: مساعدة 🎧
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isRtl
                      ? 'الدعم الفني جاهز لمساعدتك'
                      : 'Support team is ready to help'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.headset_mic_outlined,
                  size: 18,
                  color: Color(0xFF111827),
                ),
                const SizedBox(width: 4),
                Text(
                  isRtl ? 'مساعدة' : 'Help',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. Dual Top Tabs: طلباتي 📋 vs طلبية جديدة (+) ──────────────────────────

  Widget _buildDualTabs(bool isRtl) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // Tab 0: "طلباتي" (My Orders) with Clipboard Icon
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTopTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTopTab == 0 ? _orange : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 19,
                      color: _selectedTopTab == 0
                          ? _orange
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isRtl ? 'طلباتي' : 'My Orders',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: _selectedTopTab == 0
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: _selectedTopTab == 0
                            ? _orange
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab 1: "طلبية جديدة" (New Order) with (+)
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTopTab = 1);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddNewOrderFlowPage(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTopTab == 1 ? _orange : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 19,
                      color: _selectedTopTab == 1
                          ? _orange
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isRtl ? 'طلبية جديدة' : 'New Order',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: _selectedTopTab == 1
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: _selectedTopTab == 1
                            ? _orange
                            : const Color(0xFF6B7280),
                      ),
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

  // ─── 3. Horizontal Status Metrics Grid (Matching Screenshot 2) ─────────────

  Widget _buildStatusMetricsCarousel(bool isRtl) {
    final metrics = [
      // 1. ملغي
      _MetricPodData(
        status: OrderListStatus.cancelled,
        labelAr: 'ملغي',
        labelEn: 'Cancelled',
        count: _metrics.cancelled,
        icon: Icons.cancel_outlined,
        color: const Color(0xFFEF4444),
      ),
      // 2. وصل إلى المخزن
      _MetricPodData(
        status: OrderListStatus.arrived,
        labelAr: 'وصل إلى المخزن',
        labelEn: 'In Warehouse',
        count: _metrics.arrived,
        icon: Icons.inventory_2_outlined,
        color: const Color(0xFF16A34A),
      ),
      // 3. تم الشحن
      _MetricPodData(
        status: OrderListStatus.shipped,
        labelAr: 'تم الشحن',
        labelEn: 'Shipped',
        count: _metrics.shipped,
        icon: Icons.local_shipping_outlined,
        color: const Color(0xFF0D9488),
      ),
      // 4. تم الشراء
      _MetricPodData(
        status: OrderListStatus.purchased,
        labelAr: 'تم الشراء',
        labelEn: 'Purchased',
        count: _metrics.purchased,
        icon: Icons.shopping_cart_outlined,
        color: const Color(0xFF2563EB),
      ),
      // 5. بانتظار الموافقة
      _MetricPodData(
        status: OrderListStatus.approvalPending,
        labelAr: 'بانتظار الموافقة',
        labelEn: 'Pending Approval',
        count: _metrics.approvalPending,
        icon: Icons.hourglass_empty_rounded,
        color: const Color(0xFF9333EA),
      ),
      // 6. بانتظار التسعير
      _MetricPodData(
        status: OrderListStatus.pricePending,
        labelAr: 'بانتظار التسعير',
        labelEn: 'Pending Pricing',
        count: _metrics.pricePending,
        icon: Icons.local_offer_outlined,
        color: const Color(0xFFD97706),
      ),
      // 7. بانتظار المراجعة
      _MetricPodData(
        status: OrderListStatus.underReview,
        labelAr: 'بانتظار المراجعة',
        labelEn: 'Under Review',
        count: _metrics.underReview,
        icon: Icons.access_time_rounded,
        color: const Color(0xFFFF5500),
      ),
      // 8. الكل
      _MetricPodData(
        status: OrderListStatus.all,
        labelAr: 'الكل',
        labelEn: 'All',
        count: _metrics.all,
        icon: null,
        color: const Color(0xFF111827),
      ),
    ];

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: metrics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final m = metrics[i];
          final isSelected = _activeFilter == m.status;

          return GestureDetector(
            onTap: () => setState(() => _activeFilter = m.status),
            child: Container(
              width: 78,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF7F2) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _orange : const Color(0xFFE5E7EB),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Label on top
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isRtl ? m.labelAr : m.labelEn,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? _orange : const Color(0xFF4B5563),
                      ),
                    ),
                  ),

                  // Bottom row: count & icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${m.count}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? _orange : const Color(0xFF111827),
                        ),
                      ),
                      if (m.icon != null) ...[
                        const SizedBox(width: 4),
                        Icon(m.icon, size: 15, color: m.color),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── 4. Search & Filter Bar ─────────────────────────────────────────────────

  Widget _buildSearchAndFilterBar(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Filter button (فلترة with funnel icon)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isRtl
                      ? 'قائمة الفلاتر المتقدمة'
                      : 'Advanced Filters Menu'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.filter_list_rounded,
                    size: 18,
                    color: Color(0xFF4B5563),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isRtl ? 'فلترة' : 'Filter',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Search Input: ابحث برقم الطلب أو اسم المنتج...
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                decoration: InputDecoration(
                  hintText: isRtl
                      ? 'ابحث برقم الطلب أو اسم المنتج...'
                      : 'Search by order ID or product name...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                  suffixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. Order Item Card (Matching Screenshots 1, 2, 3) ─────────────────────

  Widget _buildOrderItemCard(_OrderRecord item, bool isRtl) {
    return GestureDetector(
      onTap: () {
        // Direct navigation to detailed 8-milestone tracking screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsTrackingPage(
              orderId: item.orderId,
              siteNameAr: item.siteNameAr,
              siteNameEn: item.siteNameEn,
              statusAr: item.statusAr,
              statusEn: item.statusEn,
              orderDateAr: item.dateAr,
              orderDateEn: item.dateEn,
              productNameAr: item.productNameAr,
              productNameEn: item.productNameEn,
              quantity: item.quantity,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F2F5), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Left: Product Visual Thumbnail (62x62)
            _buildProductThumbnail(item),

            const SizedBox(width: 10),

            // ─── Center: Product Info & Order ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    isRtl ? item.productNameAr : item.productNameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Site row: الموقع: الصين / أمريكا / تركيا / SHEIN
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          isRtl
                              ? 'الموقع: ${item.siteNameAr}'
                              : 'Site: ${item.siteNameEn}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildFlagBadge(item.siteType),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Quantity: العدد: 2
                  Text(
                    isRtl ? 'العدد: ${item.quantity}' : 'Qty: ${item.quantity}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Order ID row: رقم الطلب: #AB-2505237 📋
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            isRtl
                                ? 'رقم الطلب: ${item.orderId}'
                                : 'Order ID: ${item.orderId}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _copyOrderId(item.orderId),
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 13,
                          color: _orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // ─── Right: Status Pill & Timestamp & Chevron >
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 125),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Colored Status Pill
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: item.statusBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  isRtl ? item.statusAr : item.statusEn,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: item.statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Icon(
                                item.statusIcon,
                                size: 11,
                                color: item.statusColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Date & Time
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment:
                        isRtl ? Alignment.centerLeft : Alignment.centerRight,
                    child: Text(
                      isRtl ? item.dateAr : item.dateEn,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9.5,
                        color: Color(0xFF9CA3AF),
                      ),
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

  // ─── Visual Thumbnail Builder ───────────────────────────────────────────────

  Widget _buildProductThumbnail(_OrderRecord item) {
    const double size = 62;
    // If has custom generated asset image
    if (item.imageAsset != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            item.imageAsset!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallbackVisual(item.visualType),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
      ),
      child: Center(
        child: _buildFallbackVisual(item.visualType),
      ),
    );
  }

  Widget _buildFallbackVisual(String type) {
    Widget iconWidget;
    switch (type) {
      case 'earbuds':
        iconWidget = const _EarbudsThumbnail();
        break;
      case 'powerbank':
        iconWidget = const _PowerbankThumbnail();
        break;
      case 'sunglasses':
        iconWidget = const _SunglassesThumbnail();
        break;
      case 'smartwatch':
        iconWidget = const Icon(Icons.watch_rounded,
            size: 32, color: Color(0xFF4B5563));
        break;
      case 'handbag':
        iconWidget = const Icon(Icons.shopping_bag_outlined,
            size: 32, color: Color(0xFF8B5CF6));
        break;
      case 'sneakers':
        iconWidget = const Icon(Icons.directions_run_rounded,
            size: 32, color: Color(0xFF3B82F6));
        break;
      default:
        iconWidget = const Icon(Icons.inventory_2_outlined,
            size: 32, color: Color(0xFF9CA3AF));
        break;
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: iconWidget,
    );
  }

  // ─── Flag Badge ─────────────────────────────────────────────────────────────

  Widget _buildFlagBadge(String type) {
    if (type == 'china') {
      return ClipOval(
        child: Image.asset(
          'assets/branding/flag_circle_china.jpg',
          width: 15,
          height: 15,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color(0xFFDE2910),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🇨🇳', style: TextStyle(fontSize: 8)),
            ),
          ),
        ),
      );
    } else if (type == 'usa') {
      return ClipOval(
        child: Image.asset(
          'assets/branding/flag_circle_usa.jpg',
          width: 15,
          height: 15,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color(0xFF002868),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🇺🇸', style: TextStyle(fontSize: 8)),
            ),
          ),
        ),
      );
    } else if (type == 'turkey') {
      // High-res vector Turkish flag circle
      return Container(
        width: 15,
        height: 15,
        decoration: const BoxDecoration(
          color: Color(0xFFE30A17),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '🇹🇷',
            style: TextStyle(fontSize: 8),
          ),
        ),
      );
    }
    // SHEIN or generic
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'S',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Color(0xFFD1D5DB),
            ),
            const SizedBox(height: 12),
            Text(
              isRtl ? 'لا توجد طلبات مطابقة' : 'No matching orders found',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _activeFilter = OrderListStatus.all;
                  _searchQuery = '';
                  _searchCtrl.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isRtl ? 'عرض كل الطلبات' : 'Show All Orders',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 6. Bottom Navigation Bar with Center Floating (+) ─────────────────────

  Widget _buildBottomNavigationBar(bool isRtl) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. الرئيسية (Home)
          _buildNavItem(
            icon: Icons.home_outlined,
            labelAr: 'الرئيسية',
            labelEn: 'Home',
            index: 0,
            isRtl: isRtl,
          ),

          // 2. شحناتي (Shipments)
          _buildNavItem(
            icon: Icons.inventory_2_outlined,
            labelAr: 'شحناتي',
            labelEn: 'Shipments',
            index: 1,
            isRtl: isRtl,
          ),

          // 3. Center Elevated (+) Button: إضافة طلبية
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddNewOrderFlowPage(),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: _orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x30FF5500),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isRtl ? 'إضافة طلبية' : 'Add Order',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _orange,
                  ),
                ),
              ],
            ),
          ),

          // 4. المحفظة (Wallet)
          _buildNavItem(
            icon: Icons.account_balance_wallet_outlined,
            labelAr: 'المحفظة',
            labelEn: 'Wallet',
            index: 3,
            isRtl: isRtl,
          ),

          // 5. الحساب (Account)
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            labelAr: 'الحساب',
            labelEn: 'Account',
            index: 4,
            isRtl: isRtl,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String labelAr,
    required String labelEn,
    required int index,
    required bool isRtl,
  }) {
    final isSelected = _bottomNavIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pop();
        } else {
          setState(() => _bottomNavIndex = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? _orange : const Color(0xFF6B7280),
          ),
          const SizedBox(height: 2),
          Text(
            isRtl ? labelAr : labelEn,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? _orange : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Metric Data Holder ──────────────────────────────────────────────

class _MetricPodData {
  final OrderListStatus status;
  final String labelAr;
  final String labelEn;
  final int count;
  final IconData? icon;
  final Color color;

  const _MetricPodData({
    required this.status,
    required this.labelAr,
    required this.labelEn,
    required this.count,
    required this.icon,
    required this.color,
  });
}

// ─── Custom Vector Thumbnails ───────────────────────────────────────────────

class _EarbudsThumbnail extends StatelessWidget {
  const _EarbudsThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 8,
            left: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF9CA3AF),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerbankThumbnail extends StatelessWidget {
  const _PowerbankThumbnail();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.3,
      child: Container(
        width: 32,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SunglassesThumbnail extends StatelessWidget {
  const _SunglassesThumbnail();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 8,
          height: 2,
          color: const Color(0xFF1F2937),
        ),
        Container(
          width: 24,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
