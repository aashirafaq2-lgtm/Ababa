import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ProductReviewsViewport extends StatelessWidget {
  final String productId;
  const ProductReviewsViewport({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(title: const Text('Product Reviews'), backgroundColor: Colors.white, foregroundColor: AhmedBabaTokens.textPrimary),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Mock for live feel
        itemBuilder: (context, index) => _buildReviewCard(),
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.grey, radius: 16, child: Icon(Icons.person, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Text('Global Buyer', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(children: List.generate(5, (_) => const Icon(Icons.star, color: Colors.orange, size: 14))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Excellent product quality and very fast shipping via Trade Assurance. Highly recommended!',
            style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(width: 60, height: 60, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
              Container(width: 60, height: 60, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
            ],
          )
        ],
      ),
    );
  }
}
