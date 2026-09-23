import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../widgets/app_alert.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppAlert.show(context, l10n.loginEmailPasswordRequired);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUpMode) {
        await _authService.signUp(email, password);
      } else {
        await _authService.signIn(email, password);
      }
      // Firebase girişi tamamlanır tamamlanmaz AuthGate (main.dart) devreye
      // girer: backend kullanıcı kaydını/kredisini o taraf tamamlar, burada
      // ayrıca çağırmaya gerek yok — zaten AuthGate MainScreen'i göstermeden
      // önce bunu bekliyor.
    } catch (e) {
      if (!mounted) return;
      AppAlert.show(context, _messageFor(e, l10n));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Kullanıcının düzeltebileceği hatalar (yanlış şifre, kullanımda olan
  // email vb.) için özel mesaj döner; geri kalan her şey için genel mesaj.
  String _messageFor(Object e, AppLocalizations l10n) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-credential':
          return l10n.loginWrongCredentials;
        case 'email-already-in-use':
          return l10n.loginEmailInUse;
        case 'weak-password':
          return l10n.loginWeakPassword;
        case 'invalid-email':
          return l10n.loginInvalidEmail;
      }
    }
    return l10n.genericErrorMessage;
  }

  Future<void> _forgotPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AppAlert.show(context, l10n.loginEnterEmailFirst);
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      AppAlert.show(context, l10n.loginPasswordResetSent);
    } catch (_) {
      if (!mounted) return;
      AppAlert.show(context, l10n.genericErrorMessage);
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle();
      // Firebase girişi tamamlanır tamamlanmaz AuthGate devreye girer.
    } catch (e) {
      if (!mounted) return;
      AppAlert.show(context, l10n.genericErrorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithApple() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithApple();
      // Firebase girişi tamamlanır tamamlanmaz AuthGate devreye girer.
    } catch (e) {
      if (!mounted) return;
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        return; // kullanıcı iptal etti, mesaj gösterme
      }
      AppAlert.show(context, l10n.genericErrorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Marka logosu: sistem fontundaki Icons.auto_awesome glyph'i
              // bazı cihazlarda (ör. iPad) eksik/kırpılmış render edildiği
              // için, her cihazda piksel piksel aynı görünen kendi ikon
              // görselimizi kullanıyoruz.
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 88,
                  height: 88,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Vitrify',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.safBeyaz(context),
                ),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: l10n.loginEmailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: l10n.loginPasswordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : _forgotPassword,
                  child: Text(
                    l10n.loginForgotPassword,
                    style: TextStyle(color: AppColors.acikGri(context)),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.safBeyaz(context),
                  ),
                )
                    : Text(_isSignUpMode
                        ? l10n.loginSignUpButton
                        : l10n.loginSignInButton),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _isSignUpMode = !_isSignUpMode),
                child: Text(
                  _isSignUpMode
                      ? l10n.loginSwitchToSignIn
                      : l10n.loginSwitchToSignUp,
                  style: TextStyle(color: AppColors.acikGri(context)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.acikGri(context))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      l10n.loginOrDivider,
                      style: TextStyle(color: AppColors.acikGri(context)),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.acikGri(context))),
                ],
              ),
              const SizedBox(height: 24),

              OutlinedButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.safBeyaz(context),
                  side: BorderSide(color: AppColors.acikGri(context)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.loginGoogleSignIn),
              ),

              if (Platform.isIOS) ...[
                const SizedBox(height: 12),
                SignInWithAppleButton(
                  onPressed: _isLoading ? () {} : _signInWithApple,
                  style: SignInWithAppleButtonStyle.black,
                  borderRadius: BorderRadius.circular(12),
                  height: 52,
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
