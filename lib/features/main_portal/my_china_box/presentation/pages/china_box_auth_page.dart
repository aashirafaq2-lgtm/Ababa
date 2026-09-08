import 'package:flutter/material.dart';
import '../../data/repositories/api_china_box_repository.dart';
import 'china_box_dashboard_page.dart';

class ChinaBoxAuthPage extends StatefulWidget {
  const ChinaBoxAuthPage({super.key});

  @override
  State<ChinaBoxAuthPage> createState() => _ChinaBoxAuthPageState();
}

class _ChinaBoxAuthPageState extends State<ChinaBoxAuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'user@ababa.com');
  final _passwordController = TextEditingController(text: '123456');
  final _nameController = TextEditingController(text: 'Ahmed Al-Mansoor');
  final _phoneController = TextEditingController(text: '+964 770 123 4567');
  final _confirmController = TextEditingController(text: '123456');

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _repo = ApiChinaBoxRepository.instance;

  static const Color _orange = Color(0xFFFF6B00);
  static const Color _orangeLight = Color(0xFFFFF3EC);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() => _errorMessage = null));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_signInFormKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final ok = await _repo.authenticate(
      identity: _emailController.text.trim(),
      password: _passwordController.text,
      isSignUp: false,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      _navigateToDashboard();
    } else {
      setState(
          () => _errorMessage = 'Invalid email or password. Please try again.');
    }
  }

  Future<void> _signUp() async {
    if (!_signUpFormKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final ok = await _repo.authenticate(
      identity: _emailController.text.trim(),
      password: _passwordController.text,
      isSignUp: true,
      confirmPassword: _confirmController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      _navigateToDashboard();
    } else {
      setState(() =>
          _errorMessage = 'Registration failed. Please check your details.');
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChinaBoxDashboardPage(),
      ),
    );
  }

  void _showForgotPassword() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Forgot Password',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email address and we\'ll send you a reset link.',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email address',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: _orange, width: 2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.black54))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Reset link sent to your email'),
                backgroundColor: Colors.green,
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Send Reset Link',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildLogo(),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 28),
                    if (_errorMessage != null) _buildErrorBanner(),
                    _tabController.index == 0
                        ? _buildSignInForm()
                        : _buildSignUpForm(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.black87, size: 24),
          ),
          TextButton(
            onPressed: () {
              _tabController.index = 1;
              setState(() {});
            },
            child: const Text('Register',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _orangeLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Image.asset(
              'assets/branding/ababa_gold_emblem.png',
              width: 44,
              height: 44,
              errorBuilder: (_, __, ___) => const Text('A',
                  style: TextStyle(
                      color: _orange,
                      fontSize: 36,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('My China Box',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text(
          'Access and manage your warehouse and shipments from China',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
              height: 1.4),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        labelColor: _orange,
        unselectedLabelColor: Colors.black54,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        dividerColor: Colors.transparent,
        onTap: (_) => setState(() {}),
        tabs: const [
          Tab(text: 'Sign In'),
          Tab(text: 'Sign Up'),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFAAAA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Account / Email'),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Email is required' : null,
          ),
          const SizedBox(height: 18),
          _fieldLabel('Password'),
          _buildTextField(
            controller: _passwordController,
            hint: 'Enter your password',
            obscure: _obscurePassword,
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black45,
                  size: 20),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Password is required' : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPassword,
              child: const Text('Forgot Password?',
                  style: TextStyle(color: _orange, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          _buildPrimaryButton(
            label: 'Sign In',
            onPressed: _isLoading ? null : _signIn,
          ),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildSocialButtons(),
          const SizedBox(height: 20),
          _buildSwitchPrompt(
            text: "Don't have an account? ",
            actionText: 'Sign Up',
            onTap: () {
              _tabController.animateTo(1);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Full Name'),
          _buildTextField(
            controller: _nameController,
            hint: 'Enter your full name',
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 18),
          _fieldLabel('Email Address'),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _fieldLabel('Phone Number'),
          _buildTextField(
            controller: _phoneController,
            hint: 'e.g. +964 7xx xxx xxxx',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          _fieldLabel('Password'),
          _buildTextField(
            controller: _passwordController,
            hint: 'Create a strong password',
            obscure: _obscurePassword,
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black45,
                  size: 20),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _fieldLabel('Confirm Password'),
          _buildTextField(
            controller: _confirmController,
            hint: 'Re-enter your password',
            obscure: _obscureConfirm,
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black45,
                  size: 20),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 28),
          _buildPrimaryButton(
            label: 'Create Account',
            onPressed: _isLoading ? null : _signUp,
          ),
          const SizedBox(height: 20),
          _buildSwitchPrompt(
            text: 'Already have an account? ',
            actionText: 'Sign In',
            onTap: () {
              _tabController.animateTo(0);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
      {required String label, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _orange.withOpacity(0.6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR SIGN IN WITH',
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ),
        const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialBtn(icon: Icons.g_mobiledata_rounded, color: Colors.red),
        const SizedBox(width: 16),
        _socialBtn(icon: Icons.facebook_rounded, color: const Color(0xFF1877F2)),
        const SizedBox(width: 16),
        _socialBtn(icon: Icons.apple_rounded, color: Colors.black87),
      ],
    );
  }

  Widget _socialBtn({required IconData icon, required Color color}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildSwitchPrompt(
      {required String text,
      required String actionText,
      required VoidCallback onTap}) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: onTap,
                child: Text(actionText,
                    style: const TextStyle(
                        color: _orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
