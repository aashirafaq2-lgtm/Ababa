import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 38,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.query, style: const TextStyle(fontSize: 13, color: Colors.black87))),
              const Icon(Icons.cancel, size: 16, color: Colors.grey),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          )
        ],
      ),
      body: Column(
        children: [
          _buildFilterStrip(),
          Expanded(child: _isGridView ? _buildGridView() : _buildListView()),
        ],
      ),
    );
  }

  Widget _buildFilterStrip() {
    return Container(
      height: 44,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('Sort by: Best Match', hasArrow: true),
          _filterChip('Verified Supplier', isVerified: true),
          _filterChip('Trade Assurance', isPrimary: true),
          _filterChip('Min Order: < 10 pcs'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool hasArrow = false, bool isVerified = false, bool isPrimary = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AhmedBabaTokens.border),
      ),
      child: Row(
        children: [
          if (isVerified) Icon(Icons.verified, size: 12, color: Colors.blue),
          if (isPrimary) Icon(Icons.shield, size: 12, color: AhmedBabaTokens.primary),
          if (isVerified || isPrimary) const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          if (hasArrow) const Icon(Icons.keyboard_arrow_down, size: 12),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.65,
      ),
      itemCount: 10,
      itemBuilder: (ctx, i) => _buildProductGridCard(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (ctx, i) => _buildProductListCard(),
    );
  }

  Widget _buildProductGridCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(decoration: const BoxDecoration(color: Color(0xFFE0E0E0), borderRadius: BorderRadius.vertical(top: Radius.circular(8))))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Precision Metal Stamping Parts...', maxLines: 2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                const SizedBox(height: 8),
                Text('\$0.50 - \$2.00', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AhmedBabaTokens.primary)),
                const SizedBox(height: 4),
                const Text('Min. Order: 500 pcs', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    const Text('Verified', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const Spacer(),
                    Text('8 yrs', style: AhmedBabaTokens.bodySmall),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductListCard() {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(width: 110, height: 110, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Custom CNC Machining Hardened Steel Fasteners B2B Bulk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2),
                const Spacer(),
                Text('\$1.20 - \$1.85', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AhmedBabaTokens.primary)),
                const SizedBox(height: 4),
                const Text('MOQ: 1000 pieces', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.shield, size: 14, color: AhmedBabaTokens.primary),
                    const SizedBox(width: 4),
                    Text('Trade Assurance', style: TextStyle(color: AhmedBabaTokens.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
