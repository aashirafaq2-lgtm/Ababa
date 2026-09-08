import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';
import 'package:ahmed_baba/features/auth/data/repositories/otp_repository.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  const OTPVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _repo = OTPRepository();
  String _otp = '';
  bool _isLoading = false;
  bool _isResending = false;
  int _resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_otp.length < 6) return;
    setState(() => _isLoading = true);
    final success = await _repo.verifyOTP(widget.phoneNumber, _otp);
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code. Please try again.'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _resendOTP() async {
    setState(() { _isResending = true; _resendSeconds = 60; });
    await _repo.sendOTP(widget.phoneNumber);
    setState(() => _isResending = false);
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.black), onPressed: () => Navigator.pop(context))),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Verify your number', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: -1)),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                children: [
                  const TextSpan(text: 'We sent a 6-digit code via WhatsApp/SMS to\n'),
                  TextSpan(text: widget.phoneNumber, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 48),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (val) => _otp = val,
              onCompleted: (val) { _otp = val; _verifyOTP(); },
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 56,
                fieldWidth: 48,
                activeFillColor: Colors.white,
                inactiveFillColor: const Color(0xFFF5F5F5),
                selectedFillColor: Colors.white,
                activeColor: AhmedBabaTokens.primary,
                inactiveColor: Colors.grey[200]!,
                selectedColor: AhmedBabaTokens.primary,
              ),
              enableActiveFill: true,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AhmedBabaTokens.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Text('Verify & Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: _resendSeconds > 0
                  ? Text('Resend code in $_resendSeconds seconds', style: TextStyle(color: Colors.grey[500]))
                  : TextButton(
                      onPressed: _isResending ? null : _resendOTP,
                      child: Text('Resend Code', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
