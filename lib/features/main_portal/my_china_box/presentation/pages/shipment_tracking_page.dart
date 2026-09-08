import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/api_china_box_repository.dart';
import '../../domain/models/china_box_localization.dart';
import '../../domain/models/china_box_models.dart';
import '../../data/repositories/china_box_repository.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_chatbot_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/notification_center_page.dart';
import 'china_box_previous_orders_page.dart';

class ShipmentTrackingPage extends StatefulWidget {
  final String trackingNumber;
  final ChinaBoxRepository? repository;

  const ShipmentTrackingPage({
    super.key,
    required this.trackingNumber,
    this.repository,
  });

  @override
  State<ShipmentTrackingPage> createState() => _ShipmentTrackingPageState();
}

class _ShipmentTrackingPageState extends State<ShipmentTrackingPage>
    with SingleTickerProviderStateMixin {
  final _loc = ChinaBoxLocalization();
  late final ChinaBoxRepository _repo = widget.repository ?? ApiChinaBoxRepository.instance;

  ShipmentTrackingRecord? _record;
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _orangeLight = Color(0xFFFFF3EC);


  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _loadTracking();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadTracking() async {
    final record = await _repo.getTracking(widget.trackingNumber);
    if (mounted) {
      setState(() {
        _record = record;
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  void _copyTracking(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(_loc.isRtl ? 'تم نسخ رقم التتبع' : 'Tracking number copied!'),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
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
            backgroundColor: const Color(0xFFF7F9FC),
            body: SafeArea(
              child: Column(
                children: [
                  // ── Top Bar
                  _buildTopBar(isRtl),

                  // ── Body
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: _orange, strokeWidth: 2.5))
                        : FadeTransition(
                            opacity: _fadeAnim,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              children: [
                                // ── 1. Shipment Hero Card
                                _buildHeroCard(isRtl),

                                const SizedBox(height: 14),

                                // ── 2. 4-Column Info Row
                                _buildInfoColumns(isRtl),

                                const SizedBox(height: 14),

                                // ── 3. Shipment Status Timeline
                                _buildStatusTimeline(isRtl),

                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                  ),

                  // ── Bottom CTA: Contact Support
                  _buildSupportButton(isRtl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── 1. Top Bar ────────────────────────────────────────────────────────────

  Widget _buildTopBar(bool isRtl) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/main_home');
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Icon(
                isRtl
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: const Color(0xFF111827),
              ),
            ),
          ),

          // Title
          Expanded(
            child: Text(
              isRtl ? 'متابعة الشحنة' : 'Track Shipment',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
                letterSpacing: -0.3,
              ),
            ),
          ),

          // Notification Bell with Badge
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationCenterPage(),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: Color(0xFF374151),
                  ),
                ),
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 17,
                    height: 17,
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
                          fontSize: 9,
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

  // ─── 2. Hero Card (Container Image + Tracking Number + Status Badge) ───────

  Widget _buildHeroCard(bool isRtl) {
    final record = _record!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: A.BABA Orange Container 3D Illustration
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background glow
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0x25FF6B00), Colors.transparent],
                      ),
                    ),
                  ),
                  // Container box illustration using icons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Crane hook
                      const Icon(Icons.sailing_rounded,
                          color: Color(0xFF9CA3AF), size: 22),
                      const SizedBox(height: 2),
                      // Orange shipping container
                      Container(
                        width: 72,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF8C00), Color(0xFFE55A00)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x30FF6B00),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Horizontal container stripes
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    color:
                                        Colors.white.withValues(alpha: 0.25)),
                                Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    color:
                                        Colors.white.withValues(alpha: 0.25)),
                              ],
                            ),
                            // A.BABA Logo text
                            const Center(
                              child: Text(
                                'A.BABA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // ── Right: Tracking info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Order ID label
                  Text(
                    isRtl ? 'رقم الشحنة' : 'Shipment ID',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tracking Number + Copy button
                  GestureDetector(
                    onTap: () => _copyTracking(
                      record.orderId.isNotEmpty
                          ? record.orderId
                          : (record.trackingNumber.isNotEmpty
                              ? record.trackingNumber
                              : widget.trackingNumber),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          record.orderId.isNotEmpty
                              ? record.orderId
                              : (record.trackingNumber.isNotEmpty
                                  ? record.trackingNumber
                                  : widget.trackingNumber),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Icon(
                            Icons.copy_rounded,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Status Badge: في الطريق (In Transit) — green pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFBBF7D0), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isRtl ? 'في الطريق' : 'In Transit',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
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
    );
  }

  // ─── 3. 4-Column Info Row ──────────────────────────────────────────────────

  Widget _buildInfoColumns(bool isRtl) {
    final record = _record!;

    final cols = [
      {
        'label': isRtl ? 'الكلفة' : 'Cost',
        'value': '\$ ${record.totalCostUsd.toStringAsFixed(2)}',
        'icon': Icons.monetization_on_outlined,
        'color': const Color(0xFF0EA5E9),
        'bg': const Color(0xFFE0F2FE),
      },
      {
        'label': isRtl ? 'عدد الصناديق' : 'Boxes',
        'value': isRtl
            ? '${record.packageCount} صناديق'
            : '${record.packageCount} boxes',
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFF8B5CF6),
        'bg': const Color(0xFFEDE9FE),
      },
      {
        'label': isRtl ? 'تاريخ الشحن' : 'Ship Date',
        'value': isRtl ? '22 مايو 2024' : '22 May 2024',
        'icon': Icons.calendar_month_outlined,
        'color': _orange,
        'bg': _orangeLight,
      },
      {
        'label': isRtl ? 'طريقة الشحن' : 'Method',
        'value': isRtl ? 'شحن جوي' : 'Air Freight',
        'icon': Icons.flight_takeoff_rounded,
        'color': _orange,
        'bg': _orangeLight,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: cols.map((col) {
          final color = col['color'] as Color;
          final bg = col['bg'] as Color;
          final icon = col['icon'] as IconData;
          return Expanded(
            child: Column(
              children: [
                // Icon Pod
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 7),
                // Value
                Text(
                  col['value'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: col['label'] == (isRtl ? 'الكلفة' : 'Cost')
                        ? 13
                        : 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                // Label
                Text(
                  col['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── 4. Status Timeline ────────────────────────────────────────────────────

  Widget _buildStatusTimeline(bool isRtl) {
    // 4 steps matching reference screenshot exactly
    final steps = [
      {
        'labelAr': 'في الطريق',
        'labelEn': 'In Transit',
        'subAr': '23 مايو 2024',
        'subEn': '23 May 2024',
        'icon': Icons.flight_takeoff_rounded,
        'state': 'current', // active orange
      },
      {
        'labelAr': 'جاري التوصيل',
        'labelEn': 'Delivery',
        'subAr': 'قيد الانتظار',
        'subEn': 'Pending',
        'icon': Icons.local_shipping_outlined,
        'state': 'pending',
      },
      {
        'labelAr': 'في الجمارك',
        'labelEn': 'Customs',
        'subAr': 'قيد الانتظار',
        'subEn': 'Pending',
        'icon': Icons.domain_outlined,
        'state': 'pending',
      },
      {
        'labelAr': 'تم الاستلام',
        'labelEn': 'Received',
        'subAr': 'قيد الانتظار',
        'subEn': 'Pending',
        'icon': Icons.inventory_2_outlined,
        'state': 'pending',
      },
    ];

    // Section heading
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Section Title: حالة الشحنة
          Text(
            isRtl ? 'حالة الشحنة' : 'Shipment Status',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 20),

          // Steps Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (i) {
              final step = steps[i];
              final isCurrent = step['state'] == 'current';
              final isPending = step['state'] == 'pending';
              final isLast = i == steps.length - 1;

              return Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Column
                    Expanded(
                      child: Column(
                        children: [
                          // Circle Icon
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring for current step
                              if (isCurrent)
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _orange.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              Container(
                                width: isCurrent ? 40 : 38,
                                height: isCurrent ? 40 : 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCurrent
                                      ? _orange
                                      : isPending
                                          ? Colors.white
                                          : const Color(0xFF16A34A),
                                  border: isPending
                                      ? Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 1.5)
                                      : null,
                                  boxShadow: isCurrent
                                      ? [
                                          BoxShadow(
                                            color:
                                                _orange.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  step['icon'] as IconData,
                                  size: isCurrent ? 20 : 18,
                                  color: isCurrent
                                      ? Colors.white
                                      : isPending
                                          ? const Color(0xFFD1D5DB)
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Label
                          Text(
                            isRtl
                                ? step['labelAr'] as String
                                : step['labelEn'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.5,
                              fontWeight: isCurrent
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isCurrent
                                  ? _orange
                                  : const Color(0xFF6B7280),
                            ),
                          ),

                          const SizedBox(height: 2),

                          // Sub-label (date or pending)
                          Text(
                            isRtl
                                ? step['subAr'] as String
                                : step['subEn'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: isCurrent
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Connector Line between steps
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.only(top: 19),
                        child: SizedBox(
                          width: 16,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              gradient: i == 0
                                  ? const LinearGradient(
                                      colors: [_orange, Color(0xFFE5E7EB)],
                                    )
                                  : null,
                              color: i > 0 ? const Color(0xFFE5E7EB) : null,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── 5. Bottom Support & Navigation Actions ───────────────────────────────

  Widget _buildSupportButton(bool isRtl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CustomerChatbotPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: const Color(0x40FF6B00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent_outlined,
                      size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    isRtl ? 'تواصل مع الدعم' : 'Contact Support',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChinaBoxPreviousOrdersPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: const Color(0xFF374151),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_rounded,
                            size: 17, color: Color(0xFF4B5563)),
                        const SizedBox(width: 6),
                        Text(
                          isRtl ? 'شحناتي وطلباتي' : 'My Orders',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFD4B2), width: 1.2),
                      backgroundColor: const Color(0xFFFFF7ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: _orange,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_rounded, size: 17, color: _orange),
                        const SizedBox(width: 6),
                        Text(
                          isRtl ? 'الرئيسية' : 'Home',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

