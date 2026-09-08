import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';
import 'package:ahmed_baba/features/auth/data/repositories/otp_repository.dart';
import 'package:ahmed_baba/features/auth/presentation/pages/otp_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _role = 'Buyer';
  bool _isLoading = false;
  final _repo = OTPRepository();

  Future<void> _sendOTP() async {
    if (_phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isLoading = true);
    final success = await _repo.sendOTP(_phoneCtrl.text.trim());
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => OTPVerificationPage(phoneNumber: _phoneCtrl.text.trim()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Create Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Role Selector
            Row(
              children: ['Buyer', 'Supplier'].map((role) {
                final selected = _role == role;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _role = role),
                    child: Container(
                      margin: EdgeInsets.only(right: role == 'Buyer' ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? AhmedBabaTokens.primary : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(role, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Colors.white : Colors.black54)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _field('Full Name', 'Your full name', _nameCtrl),
            const SizedBox(height: 20),
            _field('Email Address', 'your@email.com', _emailCtrl, type: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _field('Phone Number (Iraq)', '+964 7XX XXX XXXX', _phoneCtrl, type: TextInputType.phone),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text('OTP will be sent via WhatsApp or SMS', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AhmedBabaTokens.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Text('Send Verification Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text.rich(TextSpan(
                text: 'Already have an account? ',
                style: const TextStyle(color: Colors.grey),
                children: [
                  WidgetSpan(child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text('Sign In', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold)),
                  )),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl, {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AhmedBabaTokens.primary, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
