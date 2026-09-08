import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ProfessionalRFQPage extends StatefulWidget {
  const ProfessionalRFQPage({super.key});

  @override
  State<ProfessionalRFQPage> createState() => _ProfessionalRFQPageState();
}

class _ProfessionalRFQPageState extends State<ProfessionalRFQPage> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Post Sourcing Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildProgressStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
            ),
          ),
          _buildFooterActions(),
        ],
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: const Color(0xFFF8F8F8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepCircle(1, 'Product Info'),
          _stepLine(),
          _stepCircle(2, 'Trade Terms'),
        ],
      ),
    );
  }

  Widget _stepCircle(int n, String l) {
    bool active = _currentStep >= n;
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: active ? AhmedBabaTokens.primary : Colors.grey[300], shape: BoxShape.circle),
          child: Center(child: Text('$n', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 8),
        Text(l, style: TextStyle(fontSize: 11, color: active ? Colors.black : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepLine() => Container(width: 60, height: 2, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10));

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formLabel('What are you looking for?'),
        _formInput('e.g. 6061 Aluminum Machining Parts', maxLines: 1),
        const SizedBox(height: 24),
        _formLabel('Quantity Needed'),
        Row(
          children: [
            Expanded(child: _formInput('Quantity', kbType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _formInput('Unit (e.g. Pieces)')),
          ],
        ),
        const SizedBox(height: 24),
        _formLabel('Product Specifications / Tech Pack'),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid), borderRadius: BorderRadius.circular(8), color: const Color(0xFFFAFAFA)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, color: AhmedBabaTokens.primary, size: 32),
              const SizedBox(height: 8),
              const Text('Add images or PDF Tech-Packs', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formLabel('Preferred Trade Terms'),
        _formInput('FOB, EXW, DDP...'),
        const SizedBox(height: 24),
        _formLabel('Destination Port / City'),
        _formInput('e.g. Umm Qasr Port, Iraq'),
        const SizedBox(height: 24),
        _formLabel('Sourcing Urgency'),
        Row(
          children: [
            _urgentChip('Emergency', Colors.red),
            _urgentChip('Within 1 Month', Colors.orange),
            _urgentChip('Just Exploring', Colors.grey),
          ],
        )
      ],
    );
  }

  Widget _urgentChip(String l, Color c) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
      child: Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _formLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));

  Widget _formInput(String h, {int maxLines = 1, TextInputType kbType = TextInputType.text}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: kbType,
      decoration: InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AhmedBabaTokens.primary), borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_currentStep == 1) setState(() => _currentStep = 2);
            else Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), elevation: 0),
          child: Text(_currentStep == 1 ? 'Next Step' : 'Broadcast RFQ to Suppliers', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
