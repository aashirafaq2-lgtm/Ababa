import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/splash/presentation/pages/splash_screen_viewport.dart';
import 'package:ahmed_baba/features/main_portal/domain/models/location_models.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/location_selector_modal.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/stories_tray.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/promotional_carousel.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/service_3d_icons.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/service_card_tile.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_dashboard_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/add_new_order_flow_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/presentation/pages/china_box_previous_orders_page.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/data/repositories/api_china_box_repository.dart';
import 'package:ahmed_baba/core/services/auth_token_service.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_account_profile_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/notification_center_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';
import 'container_shipping_page.dart';
import 'customs_clearance_page.dart';
import 'product_sourcing_page.dart';
import 'china_travel_residency_page.dart';
import 'dispute_resolution_page.dart';
import 'trusted_seller_page.dart';
import 'all_services_directory_page.dart';
import 'service_coming_soon_page.dart';
import '../widgets/home_modals.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  int _unreadNotifications = 0;
  String _customerName = 'Ahmed';

  void _fetchUserData() async {
    try {
      final name = await AuthTokenService.instance.getFullName();
      if (name != null && name.isNotEmpty && mounted) {
        setState(() => _customerName = name);
      }
    } catch (_) {}
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
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchNotifications();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    ));

    _contentFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
    ));

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void _openChineseAlibaba() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SplashViewport(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  void _showComingSoonSnackBar(String serviceName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$serviceName — Coming in the next phase',
          style: const TextStyle(
              fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = ChinaBoxLocalization();
    return AnimatedBuilder(
      animation: loc,
      builder: (context, _) {
        return Directionality(
          textDirection: loc.textDirection,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Header with Global Language Switcher
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildHeader(loc),
                      ),
                    ),
                  ),

                  // ── Location + Greeting
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildLocationAndGreeting(loc),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // ── Stories tray
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _contentSlide,
                      child: FadeTransition(
                        opacity: _contentFade,
                        child: StoriesTray(
                          onStoryTap: (id) {
                            if (id == 1) {
                              HomeModals.showMarketNewsModal(context);
                            } else if (id == 2) {
                              HomeModals.showOffersModal(context);
                            } else if (id == 3) {
                              HomeModals.showShippingEstimatorModal(context);
                            } else if (id == 4) {
                              HomeModals.showChinaGuideModal(context);
                            } else if (id == 5) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ChinaBoxPreviousOrdersPage(),
                                ),
                              );
                            } else if (id == 6) {
                              HomeModals.showLoyaltyPointsModal(context);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AllServicesDirectoryPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // ── Promotional Carousel
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _contentSlide,
                      child: FadeTransition(
                        opacity: _contentFade,
                        child: PromotionalCarousel(
                          onExploreOffers: () =>
                              HomeModals.showOffersModal(context),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // ── Services heading
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _contentSlide,
                      child: FadeTransition(
                        opacity: _contentFade,
                        child: _buildServicesHeading(loc),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 10)),

                  // ── 10 service cards — 5 per row
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: SlideTransition(
                        position: _contentSlide,
                        child: FadeTransition(
                          opacity: _contentFade,
                          child: _buildServiceGrid(loc),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(ChinaBoxLocalization loc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // A.BABA Gold Logo
          Image.asset(
            'assets/branding/ababa_gold_logo.png',
            height: 38,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),

          const Spacer(),

          // Notifications icon + badge + label
          _buildIconWithBadge(
            icon: Icons.notifications_none_rounded,
            badge: _unreadNotifications,
            label: loc.tr('notifications'),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationCenterPage(),
                ),
              );
              _fetchNotifications();
            },
          ),

          const SizedBox(width: 12),

          // Messages icon + badge + label
          _buildIconWithBadge(
            icon: Icons.chat_bubble_outline_rounded,
            badge: 0,
            label: loc.tr('messages'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CustomerChatbotPage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Account pill button
          _buildAccountButton(loc),
        ],
      ),
    );
  }


  Widget _buildIconWithBadge({
    required IconData icon,
    required int badge,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 21, color: const Color(0xFF1E293B)),
                if (badge > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF7A00), Color(0xFFFF4500)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x35FF6B00),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$badge',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
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
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountButton(ChinaBoxLocalization loc) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CustomerAccountProfilePage(),
          ),
        );
        _fetchUserData();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF6EE), Color(0xFFFFEFE3)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD4B2), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10FF6B00),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_rounded,
                    size: 17, color: Color(0xFFFF6B00)),
                const SizedBox(width: 4),
                Text(
                  loc.tr('account'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF6B00),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            loc.tr('profile'),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Location + Greeting ─────────────────────────────────────────────────

  Widget _buildLocationAndGreeting(ChinaBoxLocalization loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location selector pill
          GestureDetector(
            onTap: () => LocationSelectorModal.show(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on_rounded,
                          size: 13, color: Color(0xFFFF6B00)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedBuilder(
                    animation: LocationState(),
                    builder: (context, _) {
                      return Text(
                        loc.isRtl
                            ? LocationState().displayTextAr
                            : LocationState().displayTextEn,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: Color(0xFFFF6B00)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Welcome greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('👋', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    loc.isRtl ? 'مرحباً $_customerName' : 'Welcome $_customerName',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),

              // 🌐 Global Language Switcher Pill
              GestureDetector(
                onTap: () => loc.toggleLanguage(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF6EE), Color(0xFFFFEFE3)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFFFD4B2), width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12FF6B00),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language_rounded,
                          size: 14, color: Color(0xFFFF6B00)),
                      const SizedBox(width: 5),
                      Text(
                        loc.isRtl ? 'English' : 'العربية',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF6B00),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          Text(
            loc.tr('serve_you'),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Services Header ─────────────────────────────────────────────────────

  Widget _buildServicesHeading(ChinaBoxLocalization loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "View All"
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AllServicesDirectoryPage(),
              ),
            ),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  loc.isRtl
                      ? Icons.chevron_right_rounded
                      : Icons.chevron_left_rounded,
                  size: 20,
                  color: const Color(0xFFFF8C00),
                ),
                Text(
                  loc.tr('view_all'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF8C00),
                  ),
                ),
              ],
            ),
          ),

          // "Our Services  |"
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                loc.tr('our_services'),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Service Grid ─────────────────────────────────────────────────────────

  Widget _buildServiceGrid(ChinaBoxLocalization loc) {
    final services = <Map<String, dynamic>>[
      {
        'num': 1,
        'title': loc.tr('svc_1'),
        'icon': const Service3DIcon(id: 1),
        'onTap': _openChineseAlibaba,
      },
      {
        'num': 2,
        'title': loc.tr('svc_2'),
        'icon': const Service3DIcon(id: 2),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChinaBoxDashboardPage(),
          ),
        ),
      },
      {
        'num': 3,
        'title': loc.tr('svc_3'),
        'icon': const Service3DIcon(id: 3),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 3),
          ),
        ),
      },
      {
        'num': 4,
        'title': loc.tr('svc_4'),
        'icon': const Service3DIcon(id: 4),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 4),
          ),
        ),
      },
      {
        'num': 5,
        'title': loc.tr('svc_5'),
        'icon': const Service3DIcon(id: 5),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddNewOrderFlowPage(),
          ),
        ),
      },
      {
        'num': 6,
        'title': loc.tr('svc_6'),
        'icon': const Service3DIcon(id: 6),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 6),
          ),
        ),
      },
      {
        'num': 7,
        'title': loc.tr('svc_7'),
        'icon': const Service3DIcon(id: 7),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 7),
          ),
        ),
      },
      {
        'num': 8,
        'title': loc.tr('svc_8'),
        'icon': const Service3DIcon(id: 8),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 8),
          ),
        ),
      },
      {
        'num': 9,
        'title': loc.tr('svc_9'),
        'icon': const Service3DIcon(id: 9),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChinaBoxPreviousOrdersPage(),
          ),
        ),
      },
      {
        'num': 10,
        'title': loc.tr('svc_10'),
        'icon': const Service3DIcon(id: 10),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ServiceComingSoonPage(serviceId: 10),
          ),
        ),
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildServiceRow(services.sublist(0, 5)),
        const SizedBox(height: 8),
        _buildServiceRow(services.sublist(5, 10)),
      ],
    );
  }

  Widget _buildServiceRow(List<Map<String, dynamic>> items) {
    return Row(
      children: items.map((item) {
        final isLast = item == items.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 5),
            child: AspectRatio(
              aspectRatio: 158 / 270,
              child: ServiceCardTile(
                number: item['num'] as int,
                title: item['title'] as String,
                iconWidget: item['icon'] as Widget,
                onTap: item['onTap'] as VoidCallback,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
