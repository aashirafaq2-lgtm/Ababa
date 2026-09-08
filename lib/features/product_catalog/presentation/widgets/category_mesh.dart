import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class CategoryMesh extends StatefulWidget {
  const CategoryMesh({super.key});

  @override
  State<CategoryMesh> createState() => _CategoryMeshState();
}

class _CategoryMeshState extends State<CategoryMesh> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Construction', 'icon': Icons.architecture_rounded},
    {'name': 'Machinery', 'icon': Icons.settings_suggest_rounded},
    {'name': 'Apparel', 'icon': Icons.checkroom_rounded},
    {'name': 'Electronics', 'icon': Icons.memory_rounded},
    {'name': 'Furniture', 'icon': Icons.chair_rounded},
    {'name': 'Packaging', 'icon': Icons.inventory_2_rounded},
    {'name': 'Beauty', 'icon': Icons.face_retouching_natural_rounded},
    {'name': 'Metals', 'icon': Icons.precision_manufacturing_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Source by Category', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('See All', style: TextStyle(color: AhmedBabaTokens.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 16, crossAxisSpacing: 12, childAspectRatio: 0.8,
            ),
            itemCount: _categories.length,
            itemBuilder: (ctx, i) {
              return _CategoryMeshItem(category: _categories[i]);
            },
          )
        ],
      ),
    );
  }
}

class _CategoryMeshItem extends StatefulWidget {
  final Map<String, dynamic> category;
  const _CategoryMeshItem({required this.category});

  @override
  State<_CategoryMeshItem> createState() => _CategoryMeshItemState();
}

class _CategoryMeshItemState extends State<_CategoryMeshItem> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(16)),
              child: Icon(widget.category['icon'], color: Colors.black87, size: 26),
            ),
            const SizedBox(height: 8),
            Text(widget.category['name'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
