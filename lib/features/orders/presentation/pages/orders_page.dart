import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, color: AhmedBabaTokens.textPrimary)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AhmedBabaTokens.primary,
          unselectedLabelColor: AhmedBabaTokens.textSecondary,
          indicatorColor: AhmedBabaTokens.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'In Escrow'),
            Tab(text: 'Shipped'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('all'),
          _buildOrderList('escrow'),
          _buildOrderList('shipped'),
          _buildOrderList('completed'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (ctx, i) => _buildOrderCard(i, status),
    );
  }

  Widget _buildOrderCard(int index, String status) {
    final statuses = {
      'all': ['IN_ESCROW', 'SHIPPED', 'COMPLETED'],
      'escrow': ['IN_ESCROW'],
      'shipped': ['SHIPPED'],
      'completed': ['COMPLETED'],
    };
    final statusList = statuses[status]!;
    final orderStatus = statusList[index % statusList.length];
    
    final colors = {
      'IN_ESCROW': const Color(0xFF1D4ED8),
      'SHIPPED': const Color(0xFFD97706),
      'COMPLETED': const Color(0xFF059669),
    };
    final bgColors = {
      'IN_ESCROW': const Color(0xFFEFF6FF),
      'SHIPPED': const Color(0xFFFFFBEB),
      'COMPLETED': const Color(0xFFECFDF5),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Order Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ORDER #AB-${100 + index * 11}', style: TextStyle(
                      color: AhmedBabaTokens.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('May ${10 + index}, 2026', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColors[orderStatus],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(orderStatus.replaceAll('_', ' '), style: TextStyle(
                    color: colors[orderStatus], fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Product Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Industrial Grade Ball Bearings (500 Units)',
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Shenzhen Parts Co. Ltd', style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text('\$2,450.00', style: TextStyle(
                        color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AhmedBabaTokens.border),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Track Order', style: TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AhmedBabaTokens.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text('Details', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
