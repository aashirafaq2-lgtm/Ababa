import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class FactoryConsole extends StatelessWidget {
  const FactoryConsole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Factory Console', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildRevenueCard(),
            _buildStatusGrid(),
            _buildActiveBidsPreview(),
            _buildFactoryUpdateStream(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AhmedBabaTokens.primary, const Color(0xFFFF8E42)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Settlement Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('\$84,210.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _revenueSubItem('Locked in Escrow', '\$12,400'),
              const Spacer(),
              _revenueSubItem('Ready for Payout', '\$71,810'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _revenueSubItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatusGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _statusCard('Pending RFQs', '24', Icons.assignment_outlined, Colors.blue),
          _statusCard('Active Shipments', '08', Icons.local_shipping_outlined, Colors.orange),
          _statusCard('Disputed Tasks', '01', Icons.warning_amber_rounded, Colors.red),
          _statusCard('Catalog Views', '1.2k', Icons.remove_red_eye_outlined, Colors.green),
        ],
      ),
    );
  }

  Widget _statusCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActiveBidsPreview() {
    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active RFQ Bids', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('View All', style: TextStyle(color: Colors.blue, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            _bidItem('Industrial Cables', '500 units', 'Target: \$12.00'),
            _bidItem('Solar Inverters', '50 units', 'Target: \$450.00'),
          ],
        ));
  }

  Widget _bidItem(String title, String qty, String target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 4, height: 32, color: AhmedBabaTokens.primary, margin: const EdgeInsets.only(right: 12)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(qty, style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 12)),
            ]),
          ),
          Text(target, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildFactoryUpdateStream() {
    return Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live Factory Floor Updates', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _factoryClip('Quality Check', 'https://img.alicdn.com/factory1.jpg'),
                  _factoryClip('Packaging', 'https://img.alicdn.com/factory2.jpg'),
                  _factoryClip('Loading', 'https://img.alicdn.com/factory3.jpg'),
                ],
              ),
            )
          ],
        ));
  }

  Widget _factoryClip(String label, String url) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/100x120'), fit: BoxFit.cover),
      ),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8))),
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10)),
          )),
    );
  }
}
