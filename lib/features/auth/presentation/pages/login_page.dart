import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Register', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Sign in to Ababa', style: AhmedBabaTokens.displayLarge.copyWith(fontSize: 28, letterSpacing: -1)),
            const SizedBox(height: 12),
            Text('Access global suppliers and manage your trade orders seamlessly.', style: AhmedBabaTokens.bodySmall.copyWith(fontSize: 14)),
            const SizedBox(height: 48),
            
            _buildInputField(label: 'Account / Email', hint: 'Enter your trade identity'),
            const SizedBox(height: 24),
            _buildInputField(
              label: 'Password', 
              hint: 'Enter your password', 
              isPassword: true, 
              suffix: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20, color: Colors.grey),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            ),
            
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: Text('Forgot Password?', style: TextStyle(color: AhmedBabaTokens.secondary, fontSize: 13))),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AhmedBabaTokens.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  elevation: 0,
                ),
                child: const Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[200])),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('OR SIGN IN WITH', style: AhmedBabaTokens.labelSmall.copyWith(color: Colors.grey))),
                Expanded(child: Divider(color: Colors.grey[200])),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialBtn(Icons.g_mobiledata_rounded, Colors.red),
                const SizedBox(width: 24),
                _socialBtn(Icons.facebook_rounded, Colors.blue[800]!),
                const SizedBox(width: 24),
                _socialBtn(Icons.apple_rounded, Colors.black),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, bool isPassword = false, Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            suffixIcon: suffix,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AhmedBabaTokens.primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color color) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
