import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class PaymentGatewayPage extends StatefulWidget {
  final double amount;
  final String orderId;
  const PaymentGatewayPage({super.key, required this.amount, required this.orderId});

  @override
  State<PaymentGatewayPage> createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'Credit / Debit Card (Stripe)', 'icon': Icons.credit_card, 'description': 'Visa, Mastercard, Amex'},
    {'label': 'Wire Transfer (TT)', 'icon': Icons.account_balance, 'description': 'Bank-to-Bank transfer'},
    {'label': 'Alipay', 'icon': Icons.account_balance_wallet, 'description': 'For Chinese suppliers'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Secure Payment', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildEscrowBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountCard(),
                  const SizedBox(height: 24),
                  const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ..._paymentMethods.asMap().entries.map((e) => _buildPaymentOption(e.key, e.value)),
                  if (_selectedMethod == 0) _buildCardForm(),
                ],
              ),
            ),
          ),
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildEscrowBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: const Color(0xFFE8F4FF),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Color(0xFF0066CC), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your payment is protected by AhmedBaba Trade Assurance. Funds released only after delivery.',
              style: const TextStyle(fontSize: 12, color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AhmedBabaTokens.primary, const Color(0xFFFF8040)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Amount', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              Text('\$${widget.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Order ID', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text('#${widget.orderId.substring(0, 8).toUpperCase()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, Map<String, dynamic> method) {
    final selected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AhmedBabaTokens.primary : AhmedBabaTokens.border, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(method['icon'] as IconData, color: selected ? AhmedBabaTokens.primary : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method['label'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(method['description'], style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: AhmedBabaTokens.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Card Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.credit_card))),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: TextField(decoration: InputDecoration(labelText: 'MM / YY', border: OutlineInputBorder()))),
              const SizedBox(width: 12),
              const Expanded(child: TextField(decoration: InputDecoration(labelText: 'CVV', border: OutlineInputBorder()))),
            ],
          ),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Cardholder Name', border: OutlineInputBorder())),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AhmedBabaTokens.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text('Pay & Lock in Escrow \$${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  void _processPayment() {
    setState(() => _isProcessing = true);
    // Real integration: POST to /v1/orders/orderId/confirm-payment via DioClient
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful! Funds locked in escrow.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    });
  }
}
