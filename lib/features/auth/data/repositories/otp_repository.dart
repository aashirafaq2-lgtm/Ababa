import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPRepository {
  static const String _base = 'http://localhost:8083';

  /// Sends OTP to an Iraqi phone number via OTPIQ (WhatsApp + SMS fallback)
  Future<bool> sendOTP(String phoneNumber) async {
    final resp = await http.post(
      Uri.parse('$_base/api/v1/auth/otp/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );
    return resp.statusCode == 200;
  }

  /// Verifies the 6-digit code entered by the user
  Future<bool> verifyOTP(String phoneNumber, String code) async {
    final resp = await http.post(
      Uri.parse('$_base/api/v1/auth/otp/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber, 'code': code}),
    );
    return resp.statusCode == 200;
  }
}
