import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class LocalizationSettingsPage extends StatefulWidget {
  const LocalizationSettingsPage({super.key});

  @override
  State<LocalizationSettingsPage> createState() => _LocalizationSettingsPageState();
}

class _LocalizationSettingsPageState extends State<LocalizationSettingsPage> {
  String _selectedCountry = 'Pakistan';
  String _selectedCurrency = 'USD - US Dollar';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Alibaba uses pure white for settings
      appBar: AppBar(
        title: const Text('Ship to & Currency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingGroup(
                title: 'Ship to Country/Region',
                icon: Icons.public,
                value: _selectedCountry,
                onTap: () => _showSelectionBottomSheet(
                  'Select Country', 
                  ['Pakistan', 'United Arab Emirates', 'United States', 'Saudi Arabia', 'United Kingdom'],
                  _selectedCountry,
                  (v) => setState(() => _selectedCountry = v),
                ),
              ),
              const Divider(height: 32),
              _buildSettingGroup(
                title: 'Currency',
                icon: Icons.monetization_on_outlined,
                value: _selectedCurrency,
                onTap: () => _showSelectionBottomSheet(
                  'Select Currency', 
                  ['USD - US Dollar', 'PKR - Pakistani Rupee', 'AED - UAE Dirham', 'CNY - Chinese Yuan'],
                  _selectedCurrency,
                  (v) => setState(() => _selectedCurrency = v),
                ),
              ),
              const Divider(height: 32),
              _buildSettingGroup(
                title: 'Language',
                icon: Icons.language,
                value: _selectedLanguage,
                onTap: () => _showSelectionBottomSheet(
                  'Select Language', 
                  ['English', 'Urdu', 'Chinese (Simplified)', 'Arabic'],
                  _selectedLanguage,
                  (v) => setState(() => _selectedLanguage = v),
                ),
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferences saved. App will reload to apply changes.')));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingGroup({required String title, required IconData icon, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showSelectionBottomSheet(String title, List<String> options, String currentValue, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final isSelected = options[index] == currentValue;
                  return ListTile(
                    title: Text(options[index], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFFFF6600) : Colors.black87)),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFF6600)) : null,
                    onTap: () {
                      onSelect(options[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
