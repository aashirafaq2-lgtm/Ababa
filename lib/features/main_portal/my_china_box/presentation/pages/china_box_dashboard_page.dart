import 'package:flutter/material.dart';
import 'consolidation_flow_page.dart';
import 'wholesale_flow_page.dart';
import 'add_new_order_flow_page.dart';
import 'order_details_tracking_page.dart';
import '../../data/repositories/api_china_box_repository.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/notification_center_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_account_profile_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/categories_catalog_page.dart';

class ChinaBoxDashboardPage extends StatefulWidget {
  const ChinaBoxDashboardPage({super.key});

  @override
  State<ChinaBoxDashboardPage> createState() => _ChinaBoxDashboardPageState();
}

class _ChinaBoxDashboardPageState extends State<ChinaBoxDashboardPage>
    with SingleTickerProviderStateMixin {
  int _activeNavIndex = 2; // My China Box active tab

  static const Color _blueColor = Color(0xFF0052FF);
  static const Color _orangeColor = Color(0xFFFF5500);

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Interactive hover/press states for cards
  bool _wholesalePressed = false;
  bool _consolidationPressed = false;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _fetchNotifications() async {
    try {
      final count =
          await ApiChinaBoxRepository.instance.getUnreadNotificationCount();
      if (mounted) {
        setState(() => _unreadNotifications = count);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFD),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildWarehouseHeroBanner(),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              _buildSideBySideCards(),
                              const SizedBox(height: 14),
                              _buildCreamWarehouseBanner(),
                              const SizedBox(height: 14),
                              _buildActiveOrderBanner(),
                              const SizedBox(height: 14),
                              _buildTrustBenefitsBar(),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  // ─── 1. TOP APP BAR ────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F7), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back button with soft tactile shadow
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFEDEDED), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF1D1D1F),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title and Subtitle (Fitted, crisp typography)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'My China Box',
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Manage your shipments in our warehouse in China',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6E6E73),
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Notification Bell with gloss badge
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationCenterPage()),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFEDEDED), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 23,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  if (_unreadNotifications > 0)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6D1A), Color(0xFFFF4500)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40FF5500),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$_unreadNotifications',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
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

  // ─── 2. WAREHOUSE HERO BANNER (Flush Edge-to-Edge) ────────────────────────
  Widget _buildWarehouseHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/china_box/warehouse_hero.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        errorBuilder: (_, __, ___) => Container(
          height: 140,
          color: const Color(0xFFF3F7FF),
          child: const Center(
            child: Text(
              'Choose Your Storage Type',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  // ─── 3. SIDE BY SIDE CARDS (Wholesale & Consolidation) ─────────────────────
  Widget _buildSideBySideCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Wholesale
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setState(() => _wholesalePressed = true),
            onTapUp: (_) => setState(() => _wholesalePressed = false),
            onTapCancel: () => setState(() => _wholesalePressed = false),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WholesaleFlowPage()),
            ),
            child: AnimatedScale(
              scale: _wholesalePressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeInOut,
              child: _buildStorageCard(
                isWholesale: true,
                title: 'Wholesale',
                titleIcon: Icons.warehouse_outlined,
                topGradientColors: const [Color(0xFFF5F9FF), Colors.white],
                cardBorderColor: const Color(0xFFCCE0FF),
                pillGradientColors: const [Color(0xFF0066FF), Color(0xFF0044EE)],
                pillShadowColor: const Color(0x400052FF),
                pillColor: _blueColor,
                subtitle:
                    'Buy large quantities of the same product\nfrom one supplier',
                imageAsset: 'assets/images/china_box/wholesale_forklift.png',
                pills: const [
                  'Better Price',
                  'Commercial\nQuantities',
                  'Direct Shipping\nand Larger Volume',
                  'From One Supplier',
                ],
                btnText: 'Enter Wholesale Section',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WholesaleFlowPage()),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Right: Consolidation
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setState(() => _consolidationPressed = true),
            onTapUp: (_) => setState(() => _consolidationPressed = false),
            onTapCancel: () => setState(() => _consolidationPressed = false),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ConsolidationFlowPage()),
            ),
            child: AnimatedScale(
              scale: _consolidationPressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeInOut,
              child: _buildStorageCard(
                isWholesale: false,
                title: 'Consolidation',
                titleIcon: Icons.inventory_2_outlined,
                topGradientColors: const [Color(0xFFFFF8F2), Colors.white],
                cardBorderColor: const Color(0xFFFFDAC2),
                pillGradientColors: const [Color(0xFFFF6600), Color(0xFFFF4500)],
                pillShadowColor: const Color(0x40FF5500),
                pillColor: _orangeColor,
                subtitle:
                    'Buy multiple products from different\nsuppliers and consolidate them\ninto one shipment',
                imageAsset: 'assets/images/china_box/consolidation_box.png',
                pills: const [
                  'Multiple Suppliers',
                  'Multiple Products',
                  'Consolidate into\nOne Shipment',
                  'One Shipment\nin One Package',
                ],
                btnText: 'Enter Consolidation Section',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ConsolidationFlowPage()),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageCard({
    required bool isWholesale,
    required String title,
    required IconData titleIcon,
    required List<Color> topGradientColors,
    required Color cardBorderColor,
    required List<Color> pillGradientColors,
    required Color pillShadowColor,
    required Color pillColor,
    required String subtitle,
    required String imageAsset,
    required List<String> pills,
    required String btnText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: topGradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: pillColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
      child: Column(
        children: [
          // Header Pill with subtle gradient and glow shadow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: pillGradientColors,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: pillShadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(titleIcon, color: Colors.white, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle (fixed height to keep cards aligned)
          SizedBox(
            height: 38,
            child: Center(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9.3,
                  color: Color(0xFF3A3A3C),
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
                maxLines: 3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // 3D Illustration
          Image.asset(
            imageAsset,
            height: 108,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              height: 108,
              color: pillColor.withOpacity(0.06),
            ),
          ),
          const SizedBox(height: 6),
          // 2x2 Feature Pills (Clean fitted styling)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFeaturePill(pills[0], pillColor),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildFeaturePill(pills[1], pillColor),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildFeaturePill(pills[2], pillColor),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildFeaturePill(pills[3], pillColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 9),
          // Action Button (Gradient, shadow, fitted)
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: pillGradientColors,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: pillColor.withOpacity(0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            btnText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(String text, Color pillColor) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: pillColor.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 8.2,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                  height: 1.1,
                ),
                maxLines: 2,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: pillColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check, size: 8.5, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. CREAM WAREHOUSE BANNER (VIP Passport Finish) ───────────────────────
  Widget _buildCreamWarehouseBanner() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddNewOrderFlowPage()),
      ),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBF7), Color(0xFFFFF4E9)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDFC6), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08FF5500),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Orange pin circle with subtle gradient
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFEEDB), Color(0xFFFFDFCA)],
              ),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10FF5500),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: _orangeColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Title: Your Warehouse in China',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1C1C1E),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.warehouse_outlined,
                        color: _orangeColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'You will find every section inside after registering your request',
                  style: TextStyle(
                    fontSize: 9.8,
                    color: Color(0xFF6E6E73),
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // China Flag on flagpole
          Image.asset(
            'assets/images/china_box/china_flag_pole.png',
            width: 44,
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Text(
              '🇨🇳',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
      ),
    );
  }

  // ─── 4.5 ACTIVE ORDER TRACKING BANNER ─────────────────────────────────────
  Widget _buildActiveOrderBanner() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const OrderDetailsTrackingPage(),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFDFC6), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08FF5500),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _orangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'جاري مراجعة المنتج • #AB-2505237',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'الصين',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ClipOval(
                        child: Image.asset(
                          'assets/branding/flag_circle_china.jpg',
                          width: 14,
                          height: 14,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Text(
                            '🇨🇳',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سماعة بلوتوث لاسلكية (العدد: 2)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'تفاصيل ومراحل الطلب',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _orangeColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: _orangeColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── 5. 4-ITEM TRUST & BENEFITS BAR (Polished Icon Pods) ───────────────────
  Widget _buildTrustBenefitsBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECECEC), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: _buildTrustItem(
              icon: Icons.verified_user_outlined,
              iconColor: const Color(0xFF0F9D58),
              title: 'Secure',
              subtitle: 'Your goods\nare in safe hands',
            ),
          ),
          _vDivider(),
          Expanded(
            child: _buildTrustItem(
              icon: Icons.photo_camera_outlined,
              iconColor: const Color(0xFF0052FF),
              title: 'Photos & Inspection',
              subtitle: 'When your products\narrive',
            ),
          ),
          _vDivider(),
          Expanded(
            child: _buildTrustItem(
              icon: Icons.warehouse_outlined,
              iconColor: const Color(0xFFFF5500),
              title: 'Private Warehouse\nin China',
              subtitle: 'Just for you',
            ),
          ),
          _vDivider(),
          Expanded(
            child: _buildTrustItem(
              icon: Icons.headset_mic_outlined,
              iconColor: const Color(0xFF7B1FA2),
              title: 'Customer Support',
              subtitle: 'Until you receive\nyour order',
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      width: 1,
      height: 38,
      color: const Color(0xFFEDEDED),
    );
  }

  Widget _buildTrustItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
            height: 1.15,
            letterSpacing: -0.1,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 8.5,
            color: Color(0xFF86868B),
            height: 1.15,
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  // ─── 6. 5-TAB BOTTOM NAVIGATION BAR ────────────────────────────────────────
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.grid_view_outlined,
                label: 'Categories',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.warehouse_rounded,
                label: 'My China Box',
                isActive: true,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Messages',
                badgeCount: 3,
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    bool isActive = false,
    int? badgeCount,
  }) {
    final color = isActive ? _orangeColor : const Color(0xFF8E8E93);

    return GestureDetector(
      onTap: () {
        setState(() => _activeNavIndex = index);
        if (index == 0) {
          Navigator.of(context).pop();
        } else if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CategoriesCatalogPage()),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CustomerChatbotPage()),
          );
        } else if (index == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CustomerAccountProfilePage()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 24),
              if (badgeCount != null)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6D1A), Color(0xFFFF4500)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x35FF5500),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: color,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
