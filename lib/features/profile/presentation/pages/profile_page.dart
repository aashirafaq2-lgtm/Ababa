import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController(text: 'Ahmad Ali');
  final _emailController = TextEditingController(text: 'ahmad@email.com');
  final _phoneController = TextEditingController(text: '+92 300 1234567');

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'label': 'Office',
      'address': 'Plot 45, Block B, Gulberg III, Lahore, Pakistan',
      'isDefault': true,
    },
    {
      'label': 'Warehouse',
      'address': 'Industrial Zone, Ferozepur Road, Lahore',
      'isDefault': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Save', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAvatarSection(),
            _buildPersonalInfoSection(),
            _buildAddressSection(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AhmedBabaTokens.primary.withOpacity(0.1),
              child: Text('AA', style: TextStyle(color: AhmedBabaTokens.primary, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Positioned(
              right: 0, bottom: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AhmedBabaTokens.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildInput('Full Name', _nameController, Icons.person_outline),
          _buildInput('Email Address', _emailController, Icons.email_outlined),
          _buildInput('Phone Number', _phoneController, Icons.phone_outlined),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AhmedBabaTokens.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AhmedBabaTokens.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipping Addresses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              GestureDetector(
                onTap: _addNewAddress,
                child: Text('+ Add New', style: TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._savedAddresses.map((addr) => _buildAddressCard(addr)),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> addr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: addr['isDefault'] ? AhmedBabaTokens.primary : AhmedBabaTokens.border),
        borderRadius: BorderRadius.circular(10),
        color: addr['isDefault'] ? AhmedBabaTokens.primary.withOpacity(0.03) : Colors.white,
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: addr['isDefault'] ? AhmedBabaTokens.primary : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(addr['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (addr['isDefault']) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AhmedBabaTokens.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Default', style: TextStyle(color: AhmedBabaTokens.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(addr['address'], style: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 18), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _addNewAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('New Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Street Address', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Country', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: AhmedBabaTokens.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('SAVE ADDRESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!'), backgroundColor: Colors.green),
    );
  }
}
