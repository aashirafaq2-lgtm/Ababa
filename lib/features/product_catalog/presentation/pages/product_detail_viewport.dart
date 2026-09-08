import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ProductDetailViewport extends StatefulWidget {
  final String productId;
  const ProductDetailViewport({super.key, required this.productId});

  @override
  State<ProductDetailViewport> createState() => _ProductDetailViewportState();
}

class _ProductDetailViewportState extends State<ProductDetailViewport> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOpacity = 0.0;
  bool _showFloatingActions = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOpacity = (_scrollController.offset / 200).clamp(0.0, 1.0);
        _showFloatingActions = _scrollController.offset > 600;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildCinematicHeader(),
              SliverToBoxAdapter(child: _buildPriceSection()),
              SliverToBoxAdapter(child: _buildShippingSelector()),
              SliverToBoxAdapter(child: _buildCustomizationModule()),
              SliverToBoxAdapter(child: _buildSampleOrderModule()),
              SliverToBoxAdapter(child: _buildTitleSection()),
              SliverToBoxAdapter(child: _buildVerifiedSupplierBanner()),
              SliverToBoxAdapter(child: _buildVideoTourModule()),
              SliverToBoxAdapter(child: _buildSpecifications()),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildFloatingTopBar(),
          if (_showFloatingActions) _buildFloatingBottomActions(),
        ],
      ),
      bottomNavigationBar: _buildStickyActionFooter(),
    );
  }

  Widget _buildFloatingTopBar() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Opacity(
        opacity: _scrollOpacity,
        child: Container(
          color: Colors.white,
          height: 90,
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              const Icon(Icons.share_outlined, size: 22),
              const SizedBox(width: 16),
              const Icon(Icons.shopping_cart_outlined, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCinematicHeader() {
    return SliverAppBar(
      expandedHeight: 400,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'prod_${widget.productId}',
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (ctx, i) => Image.network('https://via.placeholder.com/600x600?text=Industrial+Item+${i+1}', fit: BoxFit.cover),
          ),
        ),
      ),
      leading: _scrollOpacity < 0.5 ? _circBtn(Icons.arrow_back_ios_new_rounded, isBack: true) : null,
      actions: [if (_scrollOpacity < 0.3) ...[_circBtn(Icons.share_rounded), _circBtn(Icons.shopping_cart_rounded), const SizedBox(width: 8)]],
    );
  }

  Widget _circBtn(IconData i, {bool isBack = false}) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
      child: IconButton(icon: Icon(i, color: Colors.white, size: 18), onPressed: isBack ? () => Navigator.pop(context) : () {}),
    );
  }

  Widget _buildShippingSelector() {
    return _moduleWrapper(
      child: Row(
        children: [
          const Text('Shipping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 16),
          const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
          const SizedBox(width: 4),
          const Expanded(child: Text('Shipping to Iraq via Sea Freight', style: TextStyle(fontSize: 12))),
          const Text('\$320.30', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCustomizationModule() {
    return _moduleWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          _customRow('Customized logo', 'Min. order: 500 pieces'),
          _customRow('Customized packaging', 'Min. order: 1000 pieces'),
          _customRow('Graphic customization', 'Min. order: 500 pieces'),
        ],
      ),
    );
  }

  Widget _customRow(String label, String moq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 14), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 12))]),
          Text(moq, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSampleOrderModule() {
    return _moduleWrapper(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Samples', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('\$15.00 / piece | 1 piece (Min. order)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(side: BorderSide(color: AhmedBabaTokens.primary), shape: const StadiumBorder()),
            child: Text('Get Samples', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _moduleWrapper({required Widget child}) {
    return Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(20), color: Colors.white, child: child);
  }

  // --- REUSING PREVIOUS ELEMENTS WITH ALIBABA POLISH ---
  Widget _buildPriceSection() => Container(color: Colors.white, padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('\$', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.w900, fontSize: 18)), Text('4.50 - 5.20', style: AhmedBabaTokens.priceStyle.copyWith(fontSize: 32)), const SizedBox(width: 8), Text('/ piece', style: AhmedBabaTokens.bodySmall)])]));
  Widget _buildTitleSection() => Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: const Text('Heavy Duty 6061 Aluminum Alloy CNC Machining Parts for Global Export', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, height: 1.3)));
  Widget _buildVerifiedSupplierBanner() => Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(20), color: Colors.white, child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))), const SizedBox(width: 16), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Shenzhen Precision Industry Ltd', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), Row(children: [Icon(Icons.verified_rounded, color: Colors.blue, size: 14), SizedBox(width: 4), Text('Verified Manufacturer • 12 Years', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 10))])])), const Icon(Icons.chevron_right_rounded, color: Colors.grey)]));
  Widget _buildVideoTourModule() => Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(20), color: Colors.white, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Live Factory Tour', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 12), Container(height: 180, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/800x400?text=Live+Factory'), fit: BoxFit.cover)), child: Center(child: Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40))))]));
  Widget _buildSpecifications() => Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(20), color: Colors.white, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Product Specifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 16), _specItem('Material', 'Aluminum 6061-T6'), _specItem('Tolerance', '+/- 0.005mm')]));
  Widget _specItem(String l, String v) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [SizedBox(width: 120, child: Text(l, style: const TextStyle(color: Colors.grey, fontSize: 14))), Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]));

  Widget _buildStickyActionFooter() {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
      child: Row(
        children: [
          _footIcon(Icons.storefront_rounded, 'Store'),
          const SizedBox(width: 20),
          _footIcon(Icons.chat_bubble_outline_rounded, 'Chat Now'),
          const SizedBox(width: 24),
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), elevation: 0), child: const Text('Send Inquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))))
        ],
      ),
    );
  }

  Widget _footIcon(IconData i, String t) => Column(children: [Icon(i, size: 22), const SizedBox(height: 4), Text(t, style: const TextStyle(fontSize: 9))]);

  Widget _buildFloatingBottomActions() {
    return Positioned(
      bottom: 100, right: 16,
      child: Column(
        children: [
          _floatingCircleBtn(Icons.support_agent_rounded),
          const SizedBox(height: 12),
          _floatingCircleBtn(Icons.vertical_align_top_rounded, onTap: () => _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut)),
        ],
      ),
    );
  }

  Widget _floatingCircleBtn(IconData i, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))]),
        child: Icon(i, color: Colors.black87, size: 24),
      ),
    );
  }
}
