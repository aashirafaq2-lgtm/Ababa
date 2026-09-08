import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class BiometricSettingsPage extends StatefulWidget {
  const BiometricSettingsPage({super.key});

  @override
  State<BiometricSettingsPage> createState() => _BiometricSettingsPageState();
}

class _BiometricSettingsPageState extends State<BiometricSettingsPage> {
  bool _isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account Security', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enhanced Login', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Protect your trade orders and wallet with biometric authentication.', style: AhmedBabaTokens.bodySmall),
            const SizedBox(height: 32),
            _buildSecurityToggle(
              title: 'Biometric Authentication',
              subtitle: 'Use FaceID or Fingerprint to sign in',
              icon: Icons.fingerprint_rounded,
              value: _isBiometricEnabled,
              onChanged: (v) => setState(() => _isBiometricEnabled = v),
            ),
            const Divider(height: 48),
            _buildSecurityTile(Icons.app_registration_rounded, 'Two-Factor Authentication (SMS)'),
            _buildSecurityTile(Icons.key_rounded, 'Change Trade Password'),
            _buildSecurityTile(Icons.devices_other_rounded, 'Registered Devices'),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityToggle({required String title, required String subtitle, required IconData icon, required bool value, required Function(bool) onChanged}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AhmedBabaTokens.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AhmedBabaTokens.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: AhmedBabaTokens.bodySmall),
            ],
          ),
        ),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: AhmedBabaTokens.primary),
      ],
    );
  }

  Widget _buildSecurityTile(IconData i, String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(i, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}
