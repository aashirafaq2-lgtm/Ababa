import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SettlementProtectionOverlay extends StatelessWidget {
  const SettlementProtectionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_rounded, color: AhmedBabaTokens.primary, size: 28),
              const SizedBox(width: 12),
              const Text('Trade Assurance Protection', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          _featureRow(Icons.security_update_good_rounded, 'Secure Payments', 'Your payment is encrypted and held in a secure escrow account until you confirm delivery.'),
          _featureRow(Icons.local_shipping_outlined, 'Shipping Guarantee', 'Full refund if the shipment is delayed beyond the agreed period.'),
          _featureRow(Icons.assignment_turned_in_outlined, 'Product Quality', 'Dispute resolution available if the product does not match the agreed specifications.'),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF0066CC), size: 20),
                SizedBox(width: 12),
                Expanded(child: Text('AhmedBaba handles millions of dollars in escrow to protect Iraqi importers.', style: TextStyle(color: Color(0xFF0066CC), fontSize: 12, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const StadiumBorder()),
              child: const Text('Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
