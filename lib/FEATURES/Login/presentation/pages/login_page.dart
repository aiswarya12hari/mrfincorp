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
  final Widget? destinationPage;

  const LoginPage({super.key, this.destinationPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

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
            style: const TextStyle(fontWeight: FontWeight.w500),
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
          builder: (_) => widget.destinationPage ?? const BottomNavPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Invalid email or password',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final keyboardOpen = dim.bottomInset > 0;

    return Scaffold(
      backgroundColor: AppColors.dashboardBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dim.isTablet || dim.isDesktop ? 440 : double.infinity,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: dim.isTablet ? 32 : 20,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top spacer ───────────────────────
                  SizedBox(
                    height: keyboardOpen ? 8 : (dim.isTablet ? 40 : 28),
                  ),

                  // ── Header (logo card + title + subtitle) ──
                  const LoginHeader(),

                  const SizedBox(height: 24),

                  // ── Form: Email + Password + Login Button Card ──
                  Consumer<LoginProvider>(
                    builder: (context, provider, child) {
                      return LoginForm(
                        formKey: _formKey,
                        emailController: _emailCtrl,
                        passwordController: _passwordCtrl,
                        onLogin: _handleLogin,
                        isLoading: provider.isLoading,
                      );
                    },
                  ),

                  // ── Bottom spacer ────────────────────
                  SizedBox(
                    height: keyboardOpen ? 16 : 32,
                  ),

                  // ── Security Note & Version text ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: AppColors.gray400,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Secure Field Staff Portal',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          color: AppColors.gray400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: AppTextStyles.version(context),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}