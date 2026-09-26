import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/button.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/text_field.dart';

/// The email + password form with login button.
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Email ────────────────────────────────────────
            FincorpTextField(
              label: 'Email',
              hintText: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email';
                return null;
              },
            ),

            const SizedBox(height: 18),

            // ── Password ─────────────────────────────────────
            FincorpTextField(
              label: 'Password',
              hintText: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: passwordController,
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),

            const SizedBox(height: 24),

            // ── Login button ──────────────────────────────────
            FincorpPrimaryButton(
              label: 'Login',
              onPressed: onLogin,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
