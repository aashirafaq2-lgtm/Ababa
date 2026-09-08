import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class CheckoutViewport extends StatefulWidget {
  final String productId;
  final double unitPrice;
  final int quantity;

  const CheckoutViewport({
    super.key,
    required this.productId,
    required this.unitPrice,
    required this.quantity,
  });

  @override
  State<CheckoutViewport> createState() => _CheckoutViewportState();
}

class _CheckoutViewportState extends State<CheckoutViewport> {
  @override
  Widget build(BuildContext context) {
    final double totalAmount = widget.unitPrice * widget.quantity;

    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Secure Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTradeAssuranceBanner(),
            const SizedBox(height: 24),
            _buildOrderSummary(totalAmount),
            const SizedBox(height: 24),
            _buildPaymentMethodSection(),
            const SizedBox(height: 40),
            _buildActionButtons(totalAmount),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeAssuranceBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AhmedBabaTokens.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AhmedBabaTokens.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user, color: AhmedBabaTokens.secondary, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trade Assurance Protected', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Funds held in escrow until delivery is confirmed.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _summaryRow('Unit Price', '\$${widget.unitPrice.toStringAsFixed(2)}'),
              const Divider(height: 24),
              _summaryRow('Quantity', '${widget.quantity} units'),
              const Divider(height: 24),
              _summaryRow('Subtotal', '\$${total.toStringAsFixed(2)}', isBold: true),
              _summaryRow('Shipping (DDP)', '\$0.00'), // Placeholder
              const Divider(height: 32, thickness: 2),
              _summaryRow('Total in Escrow', '\$${total.toStringAsFixed(2)}', isBold: true, color: AhmedBabaTokens.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AhmedBabaTokens.textSecondary)),
        Text(value, style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBold ? 16 : 14,
          color: color ?? AhmedBabaTokens.textPrimary,
        )),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.account_balance, color: Colors.blueGrey),
              const SizedBox(width: 12),
              Text('Wire Transfer / TT', style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(double total) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Trigger Order Service API call
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AhmedBabaTokens.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirm & Pay \$${total.toStringAsFixed(2)}', 
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        const Text('By clicking, you agree to AhmedBaba Sourcing Term & Agreements.', 
          textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
