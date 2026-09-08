import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Shopping Cart (RFQ Build)', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Edit', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
        ],
      ),
      body: ListView.builder(
        itemCount: 2, // 2 different suppliers
        itemBuilder: (ctx, i) => _buildSupplierCartGroup(i == 0 ? 'Shenzhen Precision' : 'Guangzhou Textiles'),
      ),
      bottomNavigationBar: _buildCartSummaryBar(),
    );
  }

  Widget _buildSupplierCartGroup(String name) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(value: true, onChanged: (v) {}, activeColor: AhmedBabaTokens.primary),
                const Icon(Icons.business, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildCartItem(),
          const Divider(height: 1),
          _buildCartItem(),
        ],
      ),
    );
  }

  Widget _buildCartItem() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: true, onChanged: (v) {}, activeColor: AhmedBabaTokens.primary),
          Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Custom Precision Parts...', maxLines: 2, style: TextStyle(fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$4.85', style: TextStyle(fontWeight: AhmedBabaTokens.priceStyle.fontWeight, color: AhmedBabaTokens.primary)),
                    _quantityCounter(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _quantityCounter() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          _countBtn(Icons.remove),
          Container(width: 40, alignment: Alignment.center, child: const Text('1000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          _countBtn(Icons.add),
        ],
      ),
    );
  }

  Widget _countBtn(IconData i) {
    return InkWell(
      onTap: () {},
      child: Container(padding: const EdgeInsets.all(4), child: Icon(i, size: 16, color: Colors.grey[600])),
    );
  }

  Widget _buildCartSummaryBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AhmedBabaTokens.border, width: 0.5))),
      child: Row(
        children: [
          Checkbox(value: true, onChanged: (v) {}, activeColor: AhmedBabaTokens.primary),
          const Text('All', style: TextStyle(fontSize: 12)),
          const Spacer(),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Inquiry Total: \$9,700.00', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('Excl. Shipping', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: StadiumBorder(), elevation: 0),
            child: const Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
