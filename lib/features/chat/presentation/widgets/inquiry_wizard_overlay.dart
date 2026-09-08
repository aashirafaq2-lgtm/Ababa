import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class InquiryWizardOverlay extends StatefulWidget {
  const InquiryWizardOverlay({super.key});

  @override
  State<InquiryWizardOverlay> createState() => _InquiryWizardOverlayState();
}

class _InquiryWizardOverlayState extends State<InquiryWizardOverlay> {
  final List<String> _templates = [
    'What is your best FOB price for 1 container?',
    'Can you provide a sample before bulk order?',
    'What is your production lead time for 5000 pcs?',
    'Do you support custom OEM packaging?'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Professional Inquiry', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your sourcing requirements...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Quick Templates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _templates.map((t) => _templateChip(t)).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: const StadiumBorder()),
              child: const Text('Send to Supplier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _templateChip(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4)),
      child: Text(t, style: const TextStyle(fontSize: 11)),
    );
  }
}
