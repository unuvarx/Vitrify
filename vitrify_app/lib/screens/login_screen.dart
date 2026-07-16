import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isSignUpMode = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = 'E-posta ve şifre gerekli.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      if (_isSignUpMode) {
        await _authService.signUp(email, password);
      } else {
        await _authService.signIn(email, password);
      }

      final result = await _authService.loginToBackend();

      setState(() {
        _message = '${result['message']}\nKredi: ${result['credits']}';
      });
    } catch (e) {
      setState(() => _message = 'Hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              const Icon(
                Icons.auto_awesome,
                size: 64,
                color: AppColors.vitrifyMavisi,
              ),
              const SizedBox(height: 16),
              const Text(
                'Vitrify',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.safBeyaz,
                ),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'E-posta',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Şifre',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.safBeyaz,
                  ),
                )
                    : Text(_isSignUpMode ? 'Kayıt Ol' : 'Giriş Yap'),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => setState(() {
                  _isSignUpMode = !_isSignUpMode;
                  _message = null;
                }),
                child: Text(
                  _isSignUpMode
                      ? 'Zaten hesabın var mı? Giriş yap'
                      : 'Hesabın yok mu? Kayıt ol',
                  style: const TextStyle(color: AppColors.acikGri),
                ),
              ),

              if (_message != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.derinGri,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _message!,
                    style: const TextStyle(color: AppColors.safBeyaz),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}