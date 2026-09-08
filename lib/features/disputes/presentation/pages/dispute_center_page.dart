import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class DisputeCenterPage extends StatefulWidget {
  const DisputeCenterPage({super.key});

  @override
  State<DisputeCenterPage> createState() => _DisputeCenterPageState();
}

class _DisputeCenterPageState extends State<DisputeCenterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Dispute Center', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AhmedBabaTokens.primary,
          indicatorColor: AhmedBabaTokens.primary,
          tabs: const [
            Tab(text: 'My Disputes'),
            Tab(text: 'Open New Dispute'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyDisputes(),
          _buildOpenDisputeForm(),
        ],
      ),
    );
  }

  Widget _buildMyDisputes() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDisputeCard('Item not as described', 'ORDER-8829', 'Under Review', Colors.orange),
        _buildDisputeCard('Product not received', 'ORDER-7741', 'Resolved', Colors.green),
      ],
    );
  }

  Widget _buildDisputeCard(String reason, String orderId, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId, style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(reason, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: BorderSide(color: AhmedBabaTokens.primary)),
                  child: Text('View Details', style: TextStyle(color: AhmedBabaTokens.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary),
                  child: const Text('Chat Support', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpenDisputeForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFD600)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF856404)),
                SizedBox(width: 12),
                Expanded(child: Text('Disputes are reviewed within 72 hours. Escrow funds remain locked until resolution.', style: TextStyle(color: Color(0xFF856404), fontSize: 13))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const TextField(decoration: InputDecoration(labelText: 'Order ID', hintText: '#ORDER-XXXX', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Reason for Dispute', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: '1', child: Text('Item not as described')),
              DropdownMenuItem(value: '2', child: Text('Item not received')),
              DropdownMenuItem(value: '3', child: Text('Wrong item sent')),
              DropdownMenuItem(value: '4', child: Text('Damaged during shipping')),
            ],
            onChanged: (v) {},
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Describe the issue',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
            label: const Text('Attach Evidence Photos'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              side: BorderSide(color: AhmedBabaTokens.primary),
              foregroundColor: AhmedBabaTokens.primary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('SUBMIT DISPUTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
