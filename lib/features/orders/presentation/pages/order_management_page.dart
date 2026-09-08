import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AhmedBabaTokens.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AhmedBabaTokens.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unpaid'),
            Tab(text: 'Shipping'),
            Tab(text: 'Completed'),
            Tab(text: 'Disputed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('all'),
          _buildOrderList('unpaid'),
          _buildOrderList('shipping'),
          _buildOrderList('completed'),
          _buildOrderList('disputed'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      itemBuilder: (ctx, i) => _buildOrderCard(type),
    );
  }

  Widget _buildOrderCard(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.business, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Shenzhen Precision Mfg Ltd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Text(type.toUpperCase(), style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('High-Precision Custom CNC Machining Parts...', style: TextStyle(fontSize: 13, height: 1.2)),
                      SizedBox(height: 8),
                      Text('Variant: 6061 Aluminum', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$4,850.00', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('x 1000', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)), child: const Text('Contact Supplier', style: TextStyle(color: Colors.black87, fontSize: 12))),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, elevation: 0), child: const Text('Track Order', style: TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
