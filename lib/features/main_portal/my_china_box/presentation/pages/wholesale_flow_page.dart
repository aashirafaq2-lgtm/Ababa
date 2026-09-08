import 'package:flutter/material.dart';
import '../../domain/models/china_box_localization.dart';
import '../../domain/models/china_box_models.dart';
import 'consolidation_flow_page.dart';
import 'shipping_method_page.dart';
import 'shipment_tracking_page.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/customer_account_profile_page.dart';

class WholesaleFlowPage extends StatefulWidget {
  const WholesaleFlowPage({super.key});

  @override
  State<WholesaleFlowPage> createState() => _WholesaleFlowPageState();
}

class _WholesaleFlowPageState extends State<WholesaleFlowPage> {
  final _loc = ChinaBoxLocalization();

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _blue = Color(0xFF0284C7);

  final List<WholesaleBatchItem> _batches = [
    WholesaleBatchItem(
      id: 'wb_001',
      boxNumber: 'Box #001',
      trackingNumber: 'AB240522001CN',
      isAirAvailable: true,
      isSeaAvailable: true,
      volumeCbm: 1.25,
      cartonCount: 25,
      receiptDateAr: '22 مايو 2024',
      receiptDateEn: '22 May 2024',
      imagePath: 'assets/branding/warehouse_boxes.jpg',
      isSelected: false,
    ),
    WholesaleBatchItem(
      id: 'wb_002',
      boxNumber: 'Box #002',
      trackingNumber: 'AB240522002CN',
      isAirAvailable: true,
      isSeaAvailable: false,
      volumeCbm: 2.10,
      cartonCount: 40,
      receiptDateAr: '22 مايو 2024',
      receiptDateEn: '22 May 2024',
      imagePath: 'assets/branding/warehouse_boxes.jpg',
      isSelected: false,
    ),
    WholesaleBatchItem(
      id: 'wb_003',
      boxNumber: 'Box #003',
      trackingNumber: 'AB240522003CN',
      isAirAvailable: false,
      isSeaAvailable: true,
      volumeCbm: 0.85,
      cartonCount: 18,
      receiptDateAr: '21 مايو 2024',
      receiptDateEn: '21 May 2024',
      imagePath: 'assets/branding/warehouse_boxes.jpg',
      isSelected: false,
    ),
    WholesaleBatchItem(
      id: 'wb_004',
      boxNumber: 'Box #004',
      trackingNumber: 'AB240522004CN',
      isAirAvailable: true,
      isSeaAvailable: true,
      volumeCbm: 3.20,
      cartonCount: 60,
      receiptDateAr: '21 مايو 2024',
      receiptDateEn: '21 May 2024',
      imagePath: 'assets/branding/warehouse_boxes.jpg',
      isSelected: false,
    ),
  ];

  int get _selectedCount => _batches.where((b) => b.isSelected).length;

  void _toggleSelect(WholesaleBatchItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
  }

  void _showActionToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  void _shipSelected() {
    final selected = _batches.where((b) => b.isSelected).toList();
    if (selected.isEmpty) {
      _showActionToast(_loc.isRtl
          ? 'الرجاء اختيار صندوق واحد على الأقل'
          : 'Please select at least one box');
      return;
    }

    final packages = selected
        .map(
          (b) => WarehousePackageItem(
            id: b.id,
            boxNumber: b.boxNumber,
            trackingNumber: b.trackingNumber,
            dimensions: '60 x 40 x 40 cm',
            weightKg: b.cartonCount * 7.2,
            arrivalDate: b.receiptDateEn,
            status: PackageStatus.inWarehouse,
            isSelected: true,
          ),
        )
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShippingMethodPage(packages: packages),
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
            backgroundColor: const Color(0xFFF9FAFB),
            body: SafeArea(
              child: Column(
                children: [
                  // ── Top Header
                  _buildHeader(isRtl),

                  // ── Subtitle
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 12),
                    child: Text(
                      _loc.tr('wholesale_subtitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  // ── Batch Cards List
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: _batches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildBatchCard(_batches[index], isRtl);
                      },
                    ),
                  ),

                  // ── Bottom Ship Action Bar
                  _buildBottomShipBar(isRtl),

                  // ── Bottom Navigation Bar (5 tabs)
                  _buildBottomNav(isRtl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── 1. Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (<)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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

          // Title: جملة (Wholesale)
          Text(
            _loc.tr('wholesale_title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),

          // Notification Bell with Badge (3)
          Stack(
            clipBehavior: Clip.none,
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
        ],
      ),
    );
  }

  // ─── 2. Batch Card ─────────────────────────────────────────────────────────

  Widget _buildBatchCard(WholesaleBatchItem item, bool isRtl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected ? _orange : const Color(0xFFE5E7EB),
          width: item.isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: item.isSelected
                ? const Color(0x12FF6B00)
                : const Color(0x05000000),
            blurRadius: item.isSelected ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Top Row: Checkbox, Thumbnail, Middle Info, Trailing Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => _toggleSelect(item),
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: item.isSelected ? _orange : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: item.isSelected ? _orange : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: item.isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              // Pallet Box Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.imagePath,
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 66,
                    height: 66,
                    color: const Color(0xFFFFF3EC),
                    child: const Icon(Icons.inventory_2_rounded,
                        color: _orange, size: 28),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Center Details: Title, Tracking, Suitability Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.boxNumber,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tracking: ${item.trackingNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Air & Sea suitability pills (Wrap prevents overflow)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Air suitability
                        _buildTransportBadge(
                          icon: Icons.flight_takeoff_rounded,
                          label: _loc.tr('air_short'),
                          iconColor: _orange,
                          isAvailable: item.isAirAvailable,
                        ),
                        // Sea suitability
                        _buildTransportBadge(
                          icon: Icons.directions_boat_rounded,
                          label: _loc.tr('sea_short'),
                          iconColor: _blue,
                          isAvailable: item.isSeaAvailable,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Trailing Column: Status Pill & 2 Action Outline Buttons (fixed 108px width)
              SizedBox(
                width: 108,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Pill (في المخزن / In Warehouse)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0xFFBBF7D0), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.5,
                          height: 5.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _loc.isRtl ? 'في المخزن' : 'In Warehouse',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Button 1: Request Photo (طلب صورة)
                  GestureDetector(
                    onTap: () => _showActionToast(
                        '${_loc.tr('request_photo')} - ${item.boxNumber}'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFFFD4B2), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt_outlined,
                              size: 12, color: Color(0xFFEA580C)),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              _loc.tr('request_photo'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Button 2: Request Carton Count (طلب عدد الكراتين)
                  GestureDetector(
                    onTap: () => _showActionToast(
                        '${_loc.tr('request_carton_count')} - ${item.boxNumber}'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFDDD6FE), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              size: 12, color: Color(0xFF7C3AED)),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              _loc.tr('request_carton_count'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ), // SizedBox close
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1),
          const SizedBox(height: 8),

          // Bottom 3 Metrics Row: Volume, Carton Count, Receipt Date
          Row(
            children: [
              // Metric 1: Volume
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.view_in_ar_outlined,
                  label: _loc.tr('total_volume_cbm'),
                  value: '${item.volumeCbm.toStringAsFixed(2)} CBM',
                ),
              ),

              Container(width: 1, height: 28, color: const Color(0xFFF1F5F9)),

              // Metric 2: Carton Count
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.inventory_2_outlined,
                  label: _loc.tr('received_carton_count'),
                  value: '${item.cartonCount} ${_loc.tr('carton_unit')}',
                ),
              ),

              Container(width: 1, height: 28, color: const Color(0xFFF1F5F9)),

              // Metric 3: Receipt Date
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.calendar_month_outlined,
                  label: _loc.tr('receipt_date'),
                  value: isRtl ? item.receiptDateAr : item.receiptDateEn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransportBadge({
    required IconData icon,
    required String label,
    required Color iconColor,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isAvailable
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 13,
            color: isAvailable
                ? const Color(0xFF16A34A)
                : const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: _orange),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  // ─── 3. Bottom Ship Action Bar ─────────────────────────────────────────────

  Widget _buildBottomShipBar(bool isRtl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selected count
          Text(
            '$_selectedCount ${_selectedCount == 1 ? _loc.tr('box_selected_unit') : _loc.tr('boxes_selected_unit')}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),

          // Big Orange Button: Ship Selected Boxes (شحن الصناديق المحددة)
          ElevatedButton(
            onPressed: _shipSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _loc.tr('ship_selected_boxes'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.inventory_2_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. Bottom Navigation Bar (5 Tabs) ─────────────────────────────────────

  Widget _buildBottomNav(bool isRtl) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            label: _loc.tr('nav_home'),
            isActive: false,
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          _buildNavItem(
            icon: Icons.inbox_outlined,
            label: _loc.tr('nav_consolidation'),
            isActive: false,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ConsolidationFlowPage(),
                ),
              );
            },
          ),
          _buildNavItem(
            icon: Icons.inventory_2_rounded,
            label: _loc.tr('nav_wholesale'),
            isActive: true,
            onTap: () {},
          ),
          _buildNavItem(
            icon: Icons.local_shipping_outlined,
            label: _loc.tr('nav_tracking'),
            isActive: false,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ShipmentTrackingPage(
                    trackingNumber: 'ABCB24052201',
                  ),
                ),
              );
            },
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: _loc.tr('nav_account'),
            isActive: false,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CustomerAccountProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? _orange : const Color(0xFF6B7280),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              color: isActive ? _orange : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
