import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class MultiSkuGridPicker extends StatefulWidget {
  const MultiSkuGridPicker({super.key});

  @override
  State<MultiSkuGridPicker> createState() => _MultiSkuGridPickerState();
}

class _MultiSkuGridPickerState extends State<MultiSkuGridPicker> {
  // Mocking 1688 SKU Mesh: Colors vs Sizes
  final List<String> _colors = ['Anodized Blue', 'Space Grey', 'Natural Silver', 'Jet Black'];
  final List<String> _sizes = ['Small (20mm)', 'Medium (40mm)', 'Large (60mm)'];
  final Map<String, int> _quantities = {}; // key: "color-size"

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Purchase Variations', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('In Stock: 50,000+', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          ..._colors.map((color) => _buildColorRow(color)).toList(),
          const Divider(height: 40),
          _buildSummaryBar(),
        ],
      ),
    );
  }

  Widget _buildColorRow(String color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(color, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _sizes.map((size) => _sizeInputField(color, size)).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _sizeInputField(String color, String size) {
    String key = "$color-$size";
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(size, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('\$4.85', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFFF6600))),
              _qtyEditor(key),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyEditor(String key) {
    int qty = _quantities[key] ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        onTap: () => _showManualEntry(key),
        child: Text(qty > 0 ? '$qty' : '0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: qty > 0 ? Colors.black : Colors.grey[400])),
      ),
    );
  }

  void _showManualEntry(String key) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(child: TextField(autofocus: true, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Enter quantity'))),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    int totalQty = _quantities.values.fold(0, (sum, val) => sum + val);
    double totalPrice = totalQty * 4.85;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Qty: $totalQty pieces', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Total Amount: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        ElevatedButton(
          onPressed: totalQty > 0 ? () {} : null,
          style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
          child: const Text('Add to Batch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
