import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SupplierPerformanceWidget extends StatelessWidget {
  const SupplierPerformanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supplier Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _perfRow('Response Speed', 0.95, 'Under 1 hour'),
          _perfRow('On-time Delivery', 0.88, 'Average 12 days'),
          _perfRow('Product Quality', 0.98, 'ISO Certified'),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text('Top 5% in Factory Direct Industry', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _perfRow(String label, double value, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 12)), Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey))]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: value, backgroundColor: const Color(0xFFF0F0F0), color: AhmedBabaTokens.primary, minHeight: 4),
          ),
        ],
      ),
    );
  }
}
