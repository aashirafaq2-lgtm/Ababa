import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/api_china_box_repository.dart';
import '../../domain/models/china_box_localization.dart';
import '../../domain/models/china_box_models.dart';
import 'shipping_method_page.dart';
import 'wholesale_flow_page.dart';
import 'china_box_previous_orders_page.dart';
import '../../data/repositories/china_box_repository.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/notification_center_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_account_profile_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/categories_catalog_page.dart';

class ConsolidationFlowPage extends StatefulWidget {
  final ChinaBoxRepository? repository;
  const ConsolidationFlowPage({super.key, this.repository});

  @override
  State<ConsolidationFlowPage> createState() => _ConsolidationFlowPageState();
}

class _ConsolidationFlowPageState extends State<ConsolidationFlowPage>
    with SingleTickerProviderStateMixin {
  final _loc = ChinaBoxLocalization();
  late final ChinaBoxRepository _repo = widget.repository ?? ApiChinaBoxRepository.instance;

  List<WarehousePackageItem> _packages = [];
  bool _isLoading = true;
  late TabController _tabController;
  int _selectedBottomNavIndex = 2; // "My Orders / طلباتي" is active

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _surfaceBg = Color(0xFFF9FAFB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadPackages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPackages() async {
    final pkgs = await _repo.getPackages();
    if (mounted) {
      setState(() {
        _packages = pkgs;
        _isLoading = false;
      });
    }
  }

  List<WarehousePackageItem> get _selected =>
      _packages.where((p) => p.isSelected).toList();

  void _toggleSelect(String id) {
    setState(() {
      final idx = _packages.indexWhere((p) => p.id == id);
      if (idx >= 0) {
        _packages[idx] = _packages[idx].copyWith(
          isSelected: !_packages[idx].isSelected,
        );
      }
    });
  }

  void _selectAll() {
    setState(() {
      final allSelected = _packages.every((p) => p.isSelected);
      _packages = _packages
          .map((p) => p.copyWith(isSelected: !allSelected))
          .toList();
    });
  }

  void _copyToClipboard(String text, String successMsg) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMsg,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  void _showSearchDialog(bool isRtl) {
    showDialog(
      context: context,
      builder: (ctx) {
        String query = '';
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isRtl ? 'بحث في الصناديق' : 'Search Packages',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: isRtl ? 'أدخل رقم التتبع أو اسم المنتج' : 'Enter tracking # or item name',
              prefixIcon: const Icon(Icons.search_rounded, color: _orange),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _orange, width: 2),
              ),
            ),
            onChanged: (val) => query = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isRtl ? 'إلغاء' : 'Cancel', style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      query.isEmpty
                          ? (isRtl ? 'عرض جميع الصناديق' : 'Showing all packages')
                          : (isRtl ? 'نتائج البحث عن: $query' : 'Search results for: $query'),
                    ),
                    backgroundColor: const Color(0xFF1E293B),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(isRtl ? 'بحث' : 'Search'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterSheet(bool isRtl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final filters = isRtl
            ? ['الكل', 'المستلمة بالمستودع', 'قيد الفحص والتصوير', 'جاهزة للتجميع والشحن', 'شحن سريع']
            : ['All Packages', 'Received in Warehouse', 'In Inspection & Photos', 'Ready to Consolidate', 'Express Air Cargo'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  isRtl ? 'تصفية الصناديق' : 'Filter Packages',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                ...filters.map((f) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline_rounded, color: _orange),
                      title: Text(f, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isRtl ? 'تم تطبيق الفلتر: $f' : 'Filter applied: $f'),
                            backgroundColor: const Color(0xFF1E293B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
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
            backgroundColor: _surfaceBg,
            body: SafeArea(
              child: Column(
                children: [
                  // 1. Top Bar (Back, Title, Translate Button, Notification Bell)
                  _buildTopBar(isRtl),

                  // 2. Sub-Tabs: Consolidation (تجميع) vs Wholesale (جملة)
                  _buildSubNavigationTabs(isRtl),

                  // 3. Scrollable Content Area
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 12),
                      children: [
                        const SizedBox(height: 8),

                        // Warehouse in China Address Card (100% zero-overflow)
                        _buildWarehouseAddressCard(isRtl),

                        const SizedBox(height: 10),

                        // Section Header: "Your Boxes for Consolidation" + Search & Filter
                        _buildSectionHeader(isRtl),

                        const SizedBox(height: 8),

                        // 5 Status Filter Tabs (Horizontal Scrollable)
                        _buildTabFilters(isRtl),

                        const SizedBox(height: 8),

                        // Select All & Bulk Action Bar
                        if (_packages.isNotEmpty) _buildSelectionActions(isRtl),

                        const SizedBox(height: 6),

                        // Package Cards List
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: CircularProgressIndicator(color: _orange),
                            ),
                          )
                        else
                          ...List.generate(
                            _packages.length,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4.5,
                              ),
                              child: _buildPackageCard(_packages[i], i, isRtl),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 4. Floating Consolidation Action Footer (Balanced flex, no text wrapping)
                  _buildConsolidateFooter(isRtl),

                  // 5. Bottom Navigation Bar (5 Tabs)
                  _buildBottomNavBar(isRtl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── 1. Top Bar ─────────────────────────────────────────────────────────────

  Widget _buildTopBar(bool isRtl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      color: Colors.white,
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                isRtl
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Title
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _loc.tr('my_china_box'),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // TRANSLATE TOGGLE BUTTON (English <-> Arabic)
          GestureDetector(
            onTap: () => _loc.toggleLanguage(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6EE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD4B2), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0CFF6B00),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate_rounded, size: 13, color: _orange),
                  const SizedBox(width: 4),
                  Text(
                    _loc.isRtl ? 'EN' : 'عربي',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: _orange,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Notification Bell
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationCenterPage()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 19,
                    color: Color(0xFF1E293B),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF7A00), Color(0xFFFF4500)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. Sub-Tabs: Consolidation vs Wholesale ───────────────────────────────

  Widget _buildSubNavigationTabs(bool isRtl) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Consolidation Tab (Active)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _orange, width: 2.8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_rounded,
                      size: 19, color: _orange),
                  const SizedBox(width: 6),
                  Text(
                    _loc.tr('consolidation'),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: _orange,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Wholesale Tab (Inactive -> opens Wholesale flow)
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WholesaleFlowPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warehouse_rounded,
                        size: 19, color: Color(0xFF6B7280)),
                    const SizedBox(width: 6),
                    Text(
                      _loc.tr('wholesale'),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
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

  // ─── 3. Warehouse Address Card (100% Zero-Overflow) ─────────────────────────

  Widget _buildWarehouseAddressCard(bool isRtl) {
    const addressArabic =
        'المستودع 3، رقم 23، طريق بانيوان\nمدينة ييوو، مقاطعة تشجيانغ، الصين\nYiwu, Zhejiang, China 322000';
    const addressEnglish =
        'Warehouse 3, No. 23, Banyuan Road\nYiwu City, Zhejiang Province, China\nYiwu, Zhejiang, China 322000';

    final fullAddress = isRtl ? addressArabic : addressEnglish;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text & Action Buttons Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.location_on_rounded,
                            size: 13, color: _orange),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: isRtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          _loc.tr('warehouse_in_china'),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Address Text
                Text(
                  fullAddress,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons Row: View on Map & Copy Address
                Row(
                  children: [
                    // View on Map (Solid Orange)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _copyToClipboard(
                            'https://maps.google.com/?q=29.3068,120.0754',
                            isRtl ? 'تم فتح الخريطة' : 'Map link copied',
                          );
                        },
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _orange,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x28FF6B00),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.menu_book_rounded,
                                      size: 13, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    _loc.tr('view_on_map'),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Copy Address (White with Orange Border)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _copyToClipboard(
                            fullAddress,
                            isRtl ? 'تم نسخ العنوان بنجاح' : 'Address copied!',
                          );
                        },
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: _orange, width: 1.2),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.copy_rounded,
                                      size: 13, color: _orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    _loc.tr('copy_address'),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: _orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // High-Res 3D A.BABA Warehouse Building Illustration
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/china_box/warehouse_building.png',
              width: 90,
              height: 100,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 90,
                height: 100,
                child: Icon(Icons.storefront_rounded, size: 36, color: _orange),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. Section Header ─────────────────────────────────────────────────────

  Widget _buildSectionHeader(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _loc.tr('your_boxes_to_consolidate'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _loc.tr('all_boxes_waiting'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Search & Filter Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderActionButton(
                icon: Icons.search_rounded,
                label: _loc.tr('search'),
                onTap: () => _showSearchDialog(isRtl),
              ),
              const SizedBox(width: 6),
              _buildHeaderActionButton(
                icon: Icons.tune_rounded,
                label: _loc.tr('filter'),
                onTap: () => _showFilterSheet(isRtl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: const Color(0xFF374151)),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 5. Status Filter Tabs ─────────────────────────────────────────────────

  Widget _buildTabFilters(bool isRtl) {
    final tabs = [
      {'key': 'shipped_tab', 'count': 8},
      {'key': 'in_warehouse', 'count': 5},
      {'key': 'ready_to_pack', 'count': 3},
      {'key': 'under_review', 'count': 0},
      {'key': 'rejected', 'count': 0},
    ];

    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: _orange,
        unselectedLabelColor: const Color(0xFF6B7280),
        indicatorColor: _orange,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: tabs.map((tab) {
          final title = _loc.tr(tab['key'] as String);
          final count = tab['count'] as int;
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: count > 0
                        ? const Color(0xFFFFF1E6)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: count > 0 ? _orange : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── 6. Bulk Action Bar ────────────────────────────────────────────────────

  Widget _buildSelectionActions(bool isRtl) {
    final numSelected = _selected.length;
    final allSelected =
        _packages.isNotEmpty && _packages.every((p) => p.isSelected);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Select All Checkbox
          GestureDetector(
            onTap: _selectAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 19,
                  height: 19,
                  decoration: BoxDecoration(
                    color: allSelected ? _orange : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: allSelected ? _orange : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: allSelected
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 5),
                Text(
                  _loc.tr('select_all'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Transfer Button
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload_rounded,
                    size: 15, color: Color(0xFF4B5563)),
                const SizedBox(width: 3),
                Text(
                  _loc.tr('transfer'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Delete Button
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline_rounded,
                    size: 15, color: Color(0xFFEF4444)),
                const SizedBox(width: 3),
                Text(
                  _loc.tr('delete'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Number Selected Indicator
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$numSelected ',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _orange,
                  ),
                ),
                TextSpan(
                  text: _loc.tr('boxes_selected'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 7. Package Card (Responsive Columns, No Truncation) ───────────────────

  Widget _buildPackageCard(WarehousePackageItem pkg, int index, bool isRtl) {
    final statusLabel = _loc.tr('in_warehouse');

    return GestureDetector(
      onTap: () => _toggleSelect(pkg.id),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: pkg.isSelected ? _orange : const Color(0xFFEEEEEE),
            width: pkg.isSelected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: pkg.isSelected
                  ? const Color(0x18FF6B00)
                  : const Color(0x06000000),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Checkbox
            GestureDetector(
              onTap: () => _toggleSelect(pkg.id),
              child: Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pkg.isSelected ? _orange : Colors.white,
                  border: Border.all(
                    color: pkg.isSelected ? _orange : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
                child: pkg.isSelected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 8),

            // Package Box 3D Image with Index Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/images/china_box/box_package.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.inventory_2_rounded,
                          color: Color(0xFFD97706), size: 32),
                    ),
                  ),
                ),
                Positioned(
                  top: 3,
                  left: isRtl ? null : 3,
                  right: isRtl ? 3 : null,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      '${index + 1}'.padLeft(2, '0'),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 9),

            // Package Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: Box Number, Status Pill, 3-dots
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            pkg.boxNumber,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          statusLabel,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.more_vert_rounded,
                          size: 17, color: Color(0xFF9CA3AF)),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Row 2: Tracking Number + Copy
                  Row(
                    children: [
                      Text(
                        '${_loc.tr('tracking_number')} ',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        pkg.trackingNumber,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: _orange,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _copyToClipboard(
                          pkg.trackingNumber,
                          isRtl
                              ? 'تم نسخ رقم التتبع'
                              : 'Tracking number copied!',
                        ),
                        child: const Icon(Icons.copy_rounded,
                            size: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Row 3: 3 Metadata Columns with Icons (Dimensions, Weight, Arrival Date)
                  Row(
                    children: [
                      // Dimensions
                      Expanded(
                        child: _buildMetaColumn(
                          icon: Icons.straighten_rounded,
                          label: _loc.tr('dimensions'),
                          value: pkg.dimensions,
                          isRtl: isRtl,
                        ),
                      ),
                      // Divider
                      Container(
                          width: 1, height: 18, color: const Color(0xFFF0F0F0)),
                      const SizedBox(width: 4),
                      // Weight
                      Expanded(
                        child: _buildMetaColumn(
                          icon: Icons.shopping_bag_outlined,
                          label: _loc.tr('weight'),
                          value: '${pkg.weightKg.toStringAsFixed(2)} kg',
                          isRtl: isRtl,
                        ),
                      ),
                      // Divider
                      Container(
                          width: 1, height: 18, color: const Color(0xFFF0F0F0)),
                      const SizedBox(width: 4),
                      // Arrival Date
                      Expanded(
                        child: _buildMetaColumn(
                          icon: Icons.calendar_today_rounded,
                          label: _loc.tr('arrival_date'),
                          value: pkg.arrivalDate,
                          isRtl: isRtl,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaColumn({
    required IconData icon,
    required String label,
    required String value,
    required bool isRtl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10.5, color: const Color(0xFFF97316)),
            const SizedBox(width: 2.5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  // ─── 8. Floating Consolidation Action Footer (No Vertical Wrapping) ────────

  Widget _buildConsolidateFooter(bool isRtl) {
    final numSelected = _selected.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Orange 3D Box Icon Pod
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.inventory_2_rounded, color: _orange, size: 21),
            ),
          ),

          const SizedBox(width: 8),

          // Count & Status text (wrapped in FittedBox so it never wraps words awkwardly)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$numSelected ',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: _orange,
                          ),
                        ),
                        TextSpan(
                          text: _loc.tr('boxes_selected'),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    _loc.tr('ready_for_consolidation_and_shipping'),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Big Solid Orange Button: "Consolidate & Ship"
          GestureDetector(
            onTap: numSelected == 0
                ? null
                : () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ShippingMethodPage(packages: _selected),
                    ));
                  },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: numSelected == 0 ? const Color(0xFFD1D5DB) : _orange,
                borderRadius: BorderRadius.circular(10),
                boxShadow: numSelected == 0
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x35FF6B00),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.inventory_2_rounded,
                          size: 15, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        _loc.isRtl
                            ? 'تجميع وشحن الصناديق المحددة'
                            : 'Consolidate & Ship',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isRtl
                            ? Icons.chevron_left_rounded
                            : Icons.chevron_right_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 9. Bottom Navigation Bar (5 Tabs) ─────────────────────────────────────

  Widget _buildBottomNavBar(bool isRtl) {
    final navItems = [
      {'label': _loc.tr('nav_home'), 'icon': Icons.home_outlined},
      {'label': _loc.tr('nav_categories'), 'icon': Icons.grid_view_rounded},
      {
        'label': _loc.tr('nav_my_orders'),
        'icon': Icons.assignment_outlined,
        'badge': 2
      },
      {
        'label': _loc.tr('nav_messages'),
        'icon': Icons.chat_bubble_outline_rounded,
        'badge': 3
      },
      {'label': _loc.tr('nav_account'), 'icon': Icons.person_outline_rounded},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (idx) {
          final item = navItems[idx];
          final isActive = idx == _selectedBottomNavIndex;
          final badge = item['badge'] as int?;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedBottomNavIndex = idx);
              if (idx == 0) {
                // Navigate back to Dashboard or Home
                Navigator.of(context).pop();
              } else if (idx == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CategoriesCatalogPage()),
                );
              } else if (idx == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChinaBoxPreviousOrdersPage()),
                );
              } else if (idx == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CustomerChatbotPage()),
                );
              } else if (idx == 4) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CustomerAccountProfilePage()),
                );
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 58,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 21,
                        color: isActive ? _orange : const Color(0xFF64748B),
                      ),
                      if (badge != null && badge > 0)
                        Positioned(
                          top: -3,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              color: _orange,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$badge',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.5,
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                      color: isActive ? _orange : const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
