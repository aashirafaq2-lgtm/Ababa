import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ProductShareCard extends StatelessWidget {
  final String productName;
  final String price;
  const ProductShareCard({super.key, required this.productName, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 16),
          Text(productName, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text(price, style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Scan to Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Source on AhmedBaba', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ],
              ),
              Container(
                width: 60, height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.qr_code_2_rounded, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: AhmedBabaTokens.primary, borderRadius: BorderRadius.circular(30)),
            child: const Center(child: Text('Download Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }
}
