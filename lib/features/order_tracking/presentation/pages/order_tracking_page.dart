import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class AnimatedLogisticsPage extends StatelessWidget {
  const AnimatedLogisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Logistics Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderInfoCard(),
            const SizedBox(height: 8),
            _buildTrackingTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #AB-99210-99', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('Carrier: Maersk Line • Sea Freight', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.copy_all_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _timelineItem(Icons.home_outlined, 'Package Delivered', 'Your container reached Umm Qasr Port and was delivered to warehouse.', 'May 12, 10:30 AM', isLatest: true),
          _timelineItem(Icons.gavel_outlined, 'Customs Cleared', 'Iraqi customs clearance completed at Port Umm Qasr.', 'May 10, 04:20 PM'),
          _timelineItem(Icons.directions_boat_outlined, 'In Transit (Sea)', 'Vessel departed from Shenzhen Port, China.', 'April 28, 08:00 AM'),
          _timelineItem(Icons.inventory_2_outlined, 'Factory Pickup', 'Supplier handed over goods to logistics carrier.', 'April 25, 11:30 AM'),
        ],
      ),
    );
  }

  Widget _timelineItem(IconData icon, String title, String desc, String time, {bool isLatest = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isLatest ? AhmedBabaTokens.primary : Colors.grey[200], shape: BoxShape.circle),
              child: Icon(icon, color: isLatest ? Colors.white : Colors.grey, size: 18),
            ),
            Container(width: 2, height: 80, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isLatest ? Colors.black : Colors.grey[600])),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 12, color: isLatest ? Colors.black87 : Colors.grey[500], height: 1.4)),
              const SizedBox(height: 8),
              Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
            ],
          ),
        )
      ],
    );
  }
}
