import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/network/china_box_api_client.dart';
import 'package:ahmed_baba/core/services/auth_token_service.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';

class CustomerAccountProfilePage extends StatefulWidget {
  const CustomerAccountProfilePage({super.key});

  @override
  State<CustomerAccountProfilePage> createState() =>
      _CustomerAccountProfilePageState();
}

class _CustomerAccountProfilePageState extends State<CustomerAccountProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _deletePasswordController = TextEditingController();

  String _boxCode = '';
  String _identity = '';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final res = await ChinaBoxApiClient.instance.dio.get('/auth/china-box/me');
      final data = res.data;
      if (mounted) {
        setState(() {
          _nameController.text = data['fullName'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _emailController.text = data['email'] ?? '';
          _boxCode = data['boxCode'] ?? '';
          _identity = data['identity'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback from cache
      final name = await AuthTokenService.instance.getFullName();
      final box = await AuthTokenService.instance.getBoxCode();
      final id = await AuthTokenService.instance.getIdentity();
      if (mounted) {
        setState(() {
          _nameController.text = name ?? 'Valued Customer';
          _boxCode = box ?? 'AB-8800';
          _identity = id ?? '';
          _phoneController.text = _identity;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;

    try {
      await ChinaBoxApiClient.instance.dio.put('/auth/china-box/profile', data: {
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      });
      // Update local storage
      await AuthTokenService.instance.saveSession(
        token: (await AuthTokenService.instance.getToken()) ?? '',
        userId: (await AuthTokenService.instance.getUserId()) ?? '',
        identity: _identity,
        fullName: _nameController.text.trim(),
        boxCode: _boxCode,
        role: (await AuthTokenService.instance.getRole()) ?? 'CUSTOMER',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'تم حفظ البيانات بنجاح' : 'Profile updated successfully'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'حدث خطأ أثناء الحفظ' : 'Failed to update profile'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showChangePasswordDialog() {
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;
    _currentPasswordController.clear();
    _newPasswordController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAr ? 'تغيير كلمة المرور' : 'Change Password',
            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الحالية' : 'Current Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الجديدة' : 'New Password',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00)),
            onPressed: () async {
              final cur = _currentPasswordController.text;
              final nw = _newPasswordController.text;
              if (cur.isEmpty || nw.length < 6) return;
              try {
                await ChinaBoxApiClient.instance.dio.post('/auth/china-box/change-password', data: {
                  'currentPassword': cur,
                  'newPassword': nw,
                });
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isAr ? 'تم تغيير كلمة المرور' : 'Password changed successfully'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isAr ? 'كلمة المرور الحالية غير صحيحة' : 'Incorrect current password'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            child: Text(isAr ? 'تحديث' : 'Update', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;
    _deletePasswordController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(isAr ? 'حذف الحساب نهائياً' : 'Delete Account',
                style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr
                  ? 'هل أنت متأكد من رغبتك في حذف حسابك؟ هذا الإجراء نهائي وسيتم حذف جميع البيانات والطلبات.'
                  : 'Are you sure you want to permanently delete your account? All your shipments, box codes, and order history will be deleted.',
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deletePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'أدخل كلمة المرور للتأكيد' : 'Confirm Password',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final pwd = _deletePasswordController.text;
              if (pwd.isEmpty) return;
              try {
                await ChinaBoxApiClient.instance.dio.delete('/auth/china-box/account', data: {'password': pwd});
                await AuthTokenService.instance.clearSession();
                if (mounted) {
                  Navigator.pop(ctx);
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isAr ? 'فشل حذف الحساب. تأكد من كلمة المرور' : 'Failed to delete. Incorrect password'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(isAr ? 'حذف الحساب' : 'Delete Account', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;

    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isAr ? 'حسابي والملف الشخصي' : 'My Account & Profile',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    // Avatar & Box Code Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x25FF6B00),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.person_rounded, size: 44, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _nameController.text.isNotEmpty ? _nameController.text : 'Customer',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3EC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFFD4B2)),
                            ),
                            child: Text(
                              '${isAr ? 'رمز الصندوق: ' : 'Box Code: '}$_boxCode',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFF6B00),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Profile Details Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'المعلومات الشخصية' : 'Personal Information',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: isAr ? 'الاسم الكامل' : 'Full Name',
                              prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFFF6B00), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: isAr ? 'رقم الهاتف' : 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFFFF6B00), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: isAr ? 'البريد الإلكتروني' : 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFFF6B00), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B00),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(
                                      isAr ? 'حفظ التعديلات' : 'Save Changes',
                                      style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Security & Actions Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.lock_reset_rounded, color: Color(0xFF2563EB), size: 20),
                            ),
                            title: Text(isAr ? 'تغيير كلمة المرور' : 'Change Password',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700)),
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                            onTap: _showChangePasswordDialog,
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.logout_rounded, color: Color(0xFFE11D48), size: 20),
                            ),
                            title: Text(isAr ? 'تسجيل الخروج' : 'Log Out',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700)),
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                            onTap: () async {
                              await AuthTokenService.instance.clearSession();
                              if (mounted) Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Apple App Store Required: Account Deletion Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showDeleteAccountDialog,
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 18),
                        label: Text(
                          isAr ? 'حذف الحساب نهائياً (Apple Requirement)' : 'Delete Account (App Store Compliant)',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.withOpacity(0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
