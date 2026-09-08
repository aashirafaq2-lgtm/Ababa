import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SupplierStorefrontPage extends StatefulWidget {
  final String supplierId;
  const SupplierStorefrontPage({super.key, required this.supplierId});

  @override
  State<SupplierStorefrontPage> createState() => _SupplierStorefrontPageState();
}

class _SupplierStorefrontPageState extends State<SupplierStorefrontPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildStoreHeader(),
          _buildStoreStats(),
          _buildStoreTabs(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductsGrid(),
            _buildProductsGrid(), // Placeholder for categories
            _buildSupplierProfile(),
          ],
        ),
      ),
      bottomNavigationBar: _buildStoreBottomBar(),
    );
  }

  Widget _buildStoreHeader() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A1A),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network('https://via.placeholder.com/800x400?text=Factory+Banner', fit: BoxFit.cover),
            Container(color: Colors.black38),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Row(
                children: [
                  Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Shenzhen Precision Mfg Ltd', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.verified, color: Colors.blue, size: 14),
                            SizedBox(width: 4),
                            Text('12 Years • Gold Supplier', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _followBtn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _followBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AhmedBabaTokens.primary, borderRadius: BorderRadius.circular(20)),
      child: const Text('Follow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildStoreStats() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('4.9/5', 'Rating'),
            _statItem('98.5%', 'Response'),
            _statItem('\$5M+', 'Transaction'),
            _statItem('150+', 'Employees'),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String v, String l) {
    return Column(
      children: [
        Text(v, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 2),
        Text(l, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildStoreTabs() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: AhmedBabaTokens.primary,
          unselectedLabelColor: Colors.black54,
          indicatorColor: AhmedBabaTokens.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [Tab(text: 'Home'), Tab(text: 'Products'), Tab(text: 'Profile')],
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.65),
      itemCount: 8,
      itemBuilder: (ctx, i) => _buildProductCard(),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(color: Colors.grey[100])),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Precision CNC Part...', maxLines: 2, style: TextStyle(fontSize: 12)),
                SizedBox(height: 8),
                Text('\$4.85', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFFF6600))),
                Text('MOQ: 100 pcs', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSupplierProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Factory Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _infoRow('Main Products', 'Machinery Parts, Aluminum Components'),
          _infoRow('Year Established', '2012'),
          _infoRow('Total Workers', '101 - 200 People'),
          const SizedBox(height: 20),
          const Text('Certifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _certChip('ISO 9001'),
              _certChip('CE Certified'),
              _certChip('TUV Verified'),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [SizedBox(width: 120, child: Text(k, style: const TextStyle(color: Colors.grey, fontSize: 13))), Expanded(child: Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)))]),
    );
  }

  Widget _certChip(String l) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFCCE4FF))), child: Text(l, style: const TextStyle(color: Color(0xFF0066CC), fontSize: 11, fontWeight: FontWeight.bold)));
  }

  Widget _buildStoreBottomBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(
        children: [
          _barIcon(Icons.category_outlined, 'Categories'),
          const SizedBox(width: 24),
          _barIcon(Icons.chat_bubble_outline, 'Contact'),
          const SizedBox(width: 24),
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: const StadiumBorder(), elevation: 0), child: const Text('Send Inquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
        ],
      ),
    );
  }

  Widget _barIcon(IconData i, String t) => Column(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 22), const SizedBox(height: 4), Text(t, style: const TextStyle(fontSize: 9))]);
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override double get minExtent => _tabBar.preferredSize.height;
  @override double get maxExtent => _tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(color: Colors.white, child: _tabBar);
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
