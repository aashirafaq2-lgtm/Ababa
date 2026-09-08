import 'package:flutter/material.dart';
import '../../domain/models/china_box_localization.dart';
import '../../domain/models/china_box_models.dart';
import 'shipment_tracking_page.dart';

enum SelectedShippingMethod { air, sea }

class ShippingMethodPage extends StatefulWidget {
  final List<WarehousePackageItem> packages;

  const ShippingMethodPage({super.key, required this.packages});

  @override
  State<ShippingMethodPage> createState() => _ShippingMethodPageState();
}

class _ShippingMethodPageState extends State<ShippingMethodPage> {
  final _loc = ChinaBoxLocalization();
  SelectedShippingMethod _selectedMethod = SelectedShippingMethod.air;

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _blue = Color(0xFF0284C7);

  int get _packageCount => widget.packages.isEmpty ? 25 : widget.packages.length;
  double get _totalWeightKg => widget.packages.isEmpty
      ? 180.0
      : widget.packages.fold(0.0, (sum, p) => sum + p.weightKg);
  double get _totalVolumeCbm => 1.25;

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
                  // ─── 1. Header (Back button, Title, Notification Bell) ───────
                  _buildHeader(isRtl),

                  // ─── 2. Subtitle ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 12),
                    child: Text(
                      _loc.tr('choose_shipping_method_sub'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  // ─── 3. Scrollable Content ───────────────────────────────────
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Summary Metric Card
                        _buildSummaryMetricsCard(isRtl),

                        const SizedBox(height: 16),

                        // Card 1: Air Shipping (الشحن الجوي)
                        _buildAirShippingCard(isRtl),

                        const SizedBox(height: 16),

                        // Card 2: Sea Shipping (الشحن البحري)
                        _buildSeaShippingCard(isRtl),

                        const SizedBox(height: 16),

                        // Disclaimer Pill
                        _buildDisclaimerPill(isRtl),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // ─── 4. Bottom Continue CTA Button ───────────────────────────
                  _buildBottomButton(isRtl),
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
              width: 40,
              height: 40,
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

          // Title: اختيار طريقة الشحن
          Text(
            _loc.tr('select_shipping_method'),
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

  // ─── 2. Summary Metric Card ────────────────────────────────────────────────

  Widget _buildSummaryMetricsCard(bool isRtl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Pallet Warehouse Boxes Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/branding/warehouse_boxes.jpg',
              width: 74,
              height: 74,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 74,
                height: 74,
                color: const Color(0xFFFFF3EC),
                child: const Icon(Icons.inventory_2_rounded,
                    color: _orange, size: 34),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Stat 1: Carton Count (عدد الكراتين)
          Expanded(
            child: _buildMetricCol(
              icon: Icons.inventory_2_outlined,
              label: _loc.tr('carton_count'),
              value: '$_packageCount',
              unit: _loc.tr('carton_unit'),
            ),
          ),

          Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),

          // Stat 2: Total Volume (الحجم الكلي)
          Expanded(
            child: _buildMetricCol(
              icon: Icons.view_in_ar_outlined,
              label: _loc.tr('total_volume'),
              value: '$_totalVolumeCbm',
              unit: _loc.tr('cbm_unit'),
            ),
          ),

          Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),

          // Stat 3: Total Weight (الوزن الإجمالي)
          Expanded(
            child: _buildMetricCol(
              icon: Icons.shopping_bag_outlined,
              label: _loc.tr('total_weight'),
              value: '${_totalWeightKg.toInt()}',
              unit: _loc.tr('kg_unit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: _orange),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // ─── 3. Card 1: Air Shipping (الشحن الجوي) ─────────────────────────────────

  Widget _buildAirShippingCard(bool isRtl) {
    final isSelected = _selectedMethod == SelectedShippingMethod.air;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = SelectedShippingMethod.air),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? _orange : const Color(0xFFE5E7EB),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x18FF6B00)
                  : const Color(0x04000000),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Top Row: Title + Badge + Icon (Start) & Selection Checkbox (End)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Group: Icon, Title, Fast Badge (At Start)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.flight_takeoff_rounded,
                            color: _orange,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _loc.tr('air_freight'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBFDF2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFBBF7D0), width: 1),
                              ),
                              child: Text(
                                _loc.tr('air_fast_badge'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Radio Circle (At End)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? _orange : Colors.white,
                    border: Border.all(
                      color: isSelected ? _orange : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Content Row: Airplane visual & specs table
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Airplane 3D Visual (Compact fixed width)
                SizedBox(
                  width: 96,
                  height: 102,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const RadialGradient(
                            colors: [Color(0x14FF6B00), Colors.transparent],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/branding/ababa_airplane.jpg',
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            height: 100,
                            color: const Color(0xFFFFF8F3),
                            child: const Center(
                              child: Icon(Icons.flight_rounded,
                                  color: _orange, size: 44),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Specs Table (Takes all remaining width)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFFF1F5F9), width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildTableRow(
                          label: _loc.tr('total_weight'),
                          icon: Icons.shopping_bag_outlined,
                          value: '${_totalWeightKg.toInt()} ${_loc.tr('kg_unit')}',
                        ),
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                        _buildTableRow(
                          label: _loc.tr('carton_count'),
                          icon: Icons.inventory_2_outlined,
                          value: '$_packageCount ${_loc.tr('carton_unit')}',
                        ),
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                        _buildTableRow(
                          label: _loc.tr('price_per_kg'),
                          icon: Icons.monetization_on_outlined,
                          value: '\$ 6.80 / ${_loc.tr('kg_unit')}',
                        ),
                        // Highlight Bottom Row (Total Shipping)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 7),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF3EC),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _loc.tr('total_shipping'),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '\$ 1,224.00',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: _orange,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── 4. Card 2: Sea Shipping (الشحن البحري) ─────────────────────────────────

  Widget _buildSeaShippingCard(bool isRtl) {
    final isSelected = _selectedMethod == SelectedShippingMethod.sea;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = SelectedShippingMethod.sea),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? _blue : const Color(0xFFE5E7EB),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x180284C7)
                  : const Color(0x04000000),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Top Row: Title + Badge + Icon (Start) & Selection Circle (End)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Group: Icon, Title, Economical Badge (At Start)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_boat_rounded,
                            color: _blue,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _loc.tr('sea_freight'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFBFDBFE), width: 1),
                              ),
                              child: Text(
                                _loc.tr('sea_eco_badge'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0369A1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Radio Circle (At End)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? _blue : Colors.white,
                    border: Border.all(
                      color: isSelected ? _blue : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Content Row: Cargo Ship visual & specs table
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cargo Ship Visual (Compact fixed width)
                SizedBox(
                  width: 96,
                  height: 118,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/branding/ababa_cargo_ship.jpg',
                      height: 118,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 118,
                        color: const Color(0xFFF0F7FF),
                        child: const Center(
                          child: Icon(Icons.directions_boat_filled_rounded,
                              color: _blue, size: 44),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Specs Table (Takes all remaining width)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFFF1F5F9), width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildTableRow(
                          label: _loc.tr('total_volume'),
                          icon: Icons.view_in_ar_outlined,
                          value: '1.25 CBM',
                          valueColor: _blue,
                        ),
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                        _buildTableRow(
                          label: _loc.tr('carton_count'),
                          icon: Icons.inventory_2_outlined,
                          value: '$_packageCount ${_loc.tr('carton_unit')}',
                        ),
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                        _buildTableRow(
                          label: _loc.tr('price_per_cbm'),
                          icon: Icons.monetization_on_outlined,
                          value: '\$ 95.00 / CBM',
                        ),
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                        _buildTableRow(
                          label: _loc.tr('total_weight'),
                          icon: Icons.shopping_bag_outlined,
                          value: '${_totalWeightKg.toInt()} ${_loc.tr('kg_unit')}',
                        ),
                        // Highlight Bottom Row (Total Shipping)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 7),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _loc.tr('total_shipping'),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '\$ 118.75',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: _blue,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String label,
    required IconData icon,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 13, color: const Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. Disclaimer Pill ────────────────────────────────────────────────────

  Widget _buildDisclaimerPill(bool isRtl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFEDD5), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _loc.tr('shipping_disclaimer'),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7C2D12),
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: _orange,
          ),
        ],
      ),
    );
  }

  // ─── 6. Bottom Continue Button ─────────────────────────────────────────────

  Widget _buildBottomButton(bool isRtl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            final trackingNo = _selectedMethod == SelectedShippingMethod.air
                ? 'ABCB24052201'
                : 'ABCB24052202';
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShipmentTrackingPage(
                  trackingNumber: trackingNo,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _orange,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _loc.tr('continue_btn'),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    isRtl
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
