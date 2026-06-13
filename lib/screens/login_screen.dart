import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 24, vertical: 32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: EdgeInsets.all(isWide ? 40 : 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2C33),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A884),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.chat, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isSignUp ? 'إنشاء حساب' : 'تسجيل الدخول',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF)),
                    ),
                    const SizedBox(height: 24),

                    if (_isSignUp) TextFormField(
                      controller: _nameCtrl,
                      textDirection: TextDirection.rtl,
                      decoration: _input('الاسم', Icons.person),
                      style: const TextStyle(color: Color(0xFFE9EDEF)),
                      validator: (v) => _isSignUp && (v == null || v.isEmpty) ? 'أدخل اسمك' : null,
                    ),
                    if (_isSignUp) const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailCtrl,
                      textDirection: TextDirection.ltr,
                      decoration: _input('البريد الإلكتروني', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color(0xFFE9EDEF)),
                      validator: (v) => v == null || v.isEmpty ? 'أدخل البريد الإلكتروني' : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _passCtrl,
                      textDirection: TextDirection.ltr,
                      decoration: _input('كلمة المرور', Icons.lock, suffix: IconButton(
                        icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF8696A0)),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      )),
                      obscureText: _obscurePass,
                      style: const TextStyle(color: Color(0xFFE9EDEF)),
                      validator: (v) => v == null || v.isEmpty ? 'أدخل كلمة المرور' : null,
                    ),
                    const SizedBox(height: 24),

                    if (auth.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(auth.error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                      ),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A884),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: const Color(0xFF00A884).withOpacity(0.5),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(_isSignUp ? 'إنشاء حساب' : 'تسجيل الدخول', style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp ? 'عندي حساب؟ سجل دخول' : 'ماعنديش حساب؟ إنشاء جديد',
                        style: const TextStyle(color: Color(0xFF00A884)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF8696A0)),
      prefixIcon: Icon(icon, color: const Color(0xFF8696A0), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF2A3942),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00A884))),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (_isSignUp) {
      context.read<AuthProvider>().register(email, password, _nameCtrl.text.trim());
    } else {
      context.read<AuthProvider>().login(email, password);
    }
  }
}
