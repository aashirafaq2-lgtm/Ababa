import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SearchSuggestionOverlay extends StatelessWidget {
  const SearchSuggestionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              const Expanded(child: TextField(autofocus: true, decoration: InputDecoration(hintText: 'Search 1688 products...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 13)))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.black))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Search History', trailing: const Icon(Icons.delete_outline, size: 18)),
            _buildTagCloud(['CNC Parts', 'Aluminum 6061', 'Textile Bulk', 'iPhone 15 Case']),
            const Divider(height: 32),
            _sectionHeader('Trending Searches', trailing: const Text('New', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))),
            _buildTrendingList([
              'Smart Watches for Export',
              'Eco-friendly Packaging',
              'Industrial Bearings',
              'Cotton Yarn Wholesalers',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildTagCloud(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4)),
          child: Text(t, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        )).toList(),
      ),
    );
  }

  Widget _buildTrendingList(List<String> trends) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trends.length,
      itemBuilder: (ctx, i) => ListTile(
        leading: Text('${i+1}', style: TextStyle(color: i < 3 ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold)),
        title: Text(trends[i], style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.north_west_rounded, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
