import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';
import 'package:ahmed_baba/core/widgets/glass_search_bar.dart';

class MasterCatalogFeed extends StatefulWidget {
  const MasterCatalogFeed({super.key});

  @override
  State<MasterCatalogFeed> createState() => _MasterCatalogFeedState();
}

class _MasterCatalogFeedState extends State<MasterCatalogFeed> with SingleTickerProviderStateMixin {
  late AnimationController _gridController;

  final List<Map<String, dynamic>> _quickLinks = [
    {'icon': Icons.bolt_rounded, 'title': 'Ready to Ship', 'color': Color(0xFFFFB800)},
    {'icon': Icons.precision_manufacturing_rounded, 'title': 'Factories', 'color': Color(0xFF0066FF)},
    {'icon': Icons.security_rounded, 'title': 'Trade Assurance', 'color': Color(0xFF22C55E)},
    {'icon': Icons.local_offer_rounded, 'title': 'Top Picks', 'color': Color(0xFFEF4444)},
    {'icon': Icons.public_rounded, 'title': 'Global Logi', 'color': Color(0xFF0088CC)},
    {'icon': Icons.group_rounded, 'title': 'Join Group', 'color': Color(0xFFF97316)},
    {'icon': Icons.star_rounded, 'title': 'Premium', 'color': Color(0xFF8B5CF6)},
    {'icon': Icons.apps_rounded, 'title': 'All Categories', 'color': Color(0xFF64748B)},
  ];

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _gridController.forward();
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAlibabaAppBar(),
          SliverToBoxAdapter(child: _buildMainBanner()),
          SliverToBoxAdapter(child: _buildQuickActionGrid()),
          SliverToBoxAdapter(child: _buildTopRankingSection()),
          _buildFeedFilters(),
          _buildStaggeredProductGrid(),
        ],
      ),
    );
  }

  Widget _buildAlibabaAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 110,
      backgroundColor: AhmedBabaTokens.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6600), Color(0xFFFF8833)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/branding/ababa_gold_emblem.png',
            height: 28,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 8),
          Text(
            'Ababa',
            style: AhmedBabaTokens.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: -0.8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Hero(
            tag: 'search_bar',
            child: Material(
              color: Colors.transparent,
              child: GlassSearchBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainBanner() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/800x400?text=B2B+Expo+2026'), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [Colors.black54, Colors.transparent])),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TRADE EXPO 2026', style: AhmedBabaTokens.headlineMedium.copyWith(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 4),
              const Text('Source directly from GZ factories', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 20, crossAxisSpacing: 10, childAspectRatio: 0.8),
        itemCount: 8,
        itemBuilder: (ctx, i) {
          final item = _quickLinks[i];
          return FadeTransition(
            opacity: _gridController,
            child: Column(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(item['title'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopRankingSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top-ranking factories', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) => _factoryCard(index)),
            ),
          )
        ],
      ),
    );
  }

  Widget _factoryCard(int i) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 80, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 8),
          const Text('Shenzhen Precision', maxLines: 1, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Verified • 10Y', style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildFeedFilters() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _filterPill('For You', active: true),
            _filterPill('Premium OEM'),
            _filterPill('Top Sales'),
            _filterPill('New Arrivals'),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String t, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: active ? AhmedBabaTokens.primary : Colors.white, borderRadius: BorderRadius.circular(20), border: active ? null : Border.all(color: Colors.grey[300]!)),
      child: Center(child: Text(t, style: TextStyle(color: active ? Colors.white : Colors.black87, fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal))),
    );
  }

  Widget _buildStaggeredProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.65),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _productItemGrid(index),
          childCount: 16,
        ),
      ),
    );
  }

  Widget _productItemGrid(int i) {
    return Hero(
      tag: 'prod_$i',
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: AhmedBabaTokens.cardShadow),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))))),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Custom Precision Parts Machine Milling Service', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Ready to Ship', style: TextStyle(color: Color(0xFFE65100), fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text('\$4.85 - \$5.50', style: AhmedBabaTokens.priceSubStyle.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('MOQ: 100 pcs', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: Colors.blue, size: 12),
                        const SizedBox(width: 4),
                        const Text('Verified Supplier', style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
