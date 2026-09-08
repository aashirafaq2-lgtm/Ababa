import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class TradeCheckoutPage extends StatefulWidget {
  const TradeCheckoutPage({super.key});

  @override
  State<TradeCheckoutPage> createState() => _TradeCheckoutPageState();
}

class _TradeCheckoutPageState extends State<TradeCheckoutPage> {
  String _selectedIncoterm = 'FOB - Free On Board';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildShippingAddressCard(),
            const SizedBox(height: 8),
            _buildTradeTermsCard(),
            const SizedBox(height: 8),
            _buildProductConsolidationCard(),
            const SizedBox(height: 8),
            _buildOrderTotalCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildPaymentActionSheet(),
    );
  }

  Widget _buildShippingAddressCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black87),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ahmad Baba (Warehouse)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('+92 300 1234567', style: TextStyle(fontSize: 13, color: Colors.black54)),
                SizedBox(height: 4),
                Text('Plot 123, Industrial Area, Sector G-10, Islamabad, Pakistan', style: TextStyle(fontSize: 13), maxLines: 2),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTradeTermsCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trade Terms (Incoterms)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showIncotermPicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: AhmedBabaTokens.border), borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedIncoterm, style: const TextStyle(fontSize: 14)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Shipping Method: Sea Freight (Standard B2B)', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductConsolidationCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.business_outlined, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text('Shenzhen Precision Mfg Ltd', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('High-Precision Custom CNC Machining Parts For Industrial Equipment', style: TextStyle(fontSize: 13, height: 1.2), maxLines: 2),
                    SizedBox(height: 8),
                    Text('Variation: 6061 Aluminum, Anodized Blue', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$4.85 / piece', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('x 1000', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderTotalCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _totalRow('Subtotal', '\$4,850.00'),
          _totalRow('Shipping (Port to Port)', '\$320.00'),
          _totalRow('Service Fee', '\$15.00'),
          const Divider(height: 32),
          _totalRow('Total Amount', '\$5,185.00', isBold: true, isPrimary: true),
        ],
      ),
    );
  }

  Widget _totalRow(String l, String v, {bool isBold = false, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(v, style: TextStyle(
            fontSize: isBold ? 18 : 14, 
            fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
            color: isPrimary ? AhmedBabaTokens.primary : Colors.black87,
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentActionSheet() {
    return Container(
      height: 85,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AhmedBabaTokens.border, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Payable', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('\$5,185.00', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          SizedBox(
            width: 180,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: StadiumBorder(), elevation: 0),
              child: const Text('Pay Secured (Ali-Escrow)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }

  void _showIncotermPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Incoterms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _incotermOption('FOB - Free On Board (Port to Port)'),
            _incotermOption('EXW - Ex Works (Factory Pickup)'),
            _incotermOption('DDP - Delivered Duty Paid (Door to Door)'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _incotermOption(String label) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: _selectedIncoterm == label ? Icon(Icons.check_circle, color: AhmedBabaTokens.primary) : null,
      onTap: () {
        setState(() => _selectedIncoterm = label);
        Navigator.pop(context);
      },
    );
  }
}
