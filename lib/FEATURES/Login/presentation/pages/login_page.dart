import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:provider/provider.dart';

import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Login/provider/login_provider.dart';

import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

import '../../../Navigation/presentation/pages/bottom_nav_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  // UI State
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<LoginProvider>();

    final success = await provider.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final user = provider.loginData?.user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome ${user?.fieldStaffName ?? ''}',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNavPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Invalid email or password',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    debugPrint('Forgot Password Clicked');
  }

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final keyboardOpen = dim.bottomInset > 0;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dim.isTablet || dim.isDesktop ? 480 : double.infinity,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Lets the whole page scroll as a safety net on short
                  // screens or when the keyboard opens, instead of
                  // overflowing. On normal screens the ConstrainedBox
                  // below matches the viewport height exactly, so the
                  // spacers do their job of pushing the header down and
                  // the version text to the bottom — same effect as
                  // Flexible spacers, just with overflow protection.
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: dim.pagePaddingH),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Top spacer ───────────────────────
                        // Pushes the header down from the very top
                        // edge instead of it hugging the status bar.
                        SizedBox(height: keyboardOpen ? dim.gap(0.02) : dim.gap(0.09)),

                        // ── Header (logo + title) ────────────
                        const LoginHeader(),

                        SizedBox(height: dim.gap(0.035)),

                        // ── Form: fields + remember/forgot + button ─
                        Consumer<LoginProvider>(
                          builder: (context, provider, child) {
                            return LoginForm(
                              formKey: _formKey,
                              emailController: _emailCtrl,
                              passwordController: _passwordCtrl,
                              rememberMe: _rememberMe,
                              onRememberChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              onForgotPassword: _handleForgotPassword,
                              onLogin: _handleLogin,
                              isLoading: provider.isLoading,
                            );
                          },
                        ),

                        // ── Bottom spacer ────────────────────
                        // Pushes the version text toward the bottom
                        // of the screen, leaving the form sitting in
                        // the lower-middle area like the Figma.
                        SizedBox(height: keyboardOpen ? dim.gap(0.04) : dim.gap(0.14)),

                        // ── Version text ──────────────────────
                        Center(
                          child: Text(
                            'Version 1.0.0',
                            style: AppTextStyles.version(context),
                          ),
                        ),

                        SizedBox(height: dim.gap(0.015)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}