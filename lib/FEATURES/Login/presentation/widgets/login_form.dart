// // import 'package:flutter/material.dart';
// // import 'package:mr_fincorp/CORE/Theme/app_color.dart';
// // import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
// // import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/button.dart';
// // import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/text_field.dart';

// // /// The email + password form card sitting in the white card area.
// // class LoginForm extends StatelessWidget {
// //   final GlobalKey<FormState> formKey;
// //   final TextEditingController emailController;
// //   final TextEditingController passwordController;
// //   final bool rememberMe;
// //   final ValueChanged<bool?> onRememberChanged;
// //   final VoidCallback onForgotPassword;
// //   final VoidCallback onLogin;
// //   final bool isLoading;

// //   const LoginForm({
// //     super.key,
// //     required this.formKey,
// //     required this.emailController,
// //     required this.passwordController,
// //     required this.rememberMe,
// //     required this.onRememberChanged,
// //     required this.onForgotPassword,
// //     required this.onLogin,
// //     this.isLoading = false,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final mq = MediaQuery.of(context);

// //     return Form(
// //       key: formKey,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // ── Email ────────────────────────────────────────
// //           FincorpTextField(
// //             label: 'Email',
// //             hintText: 'you@example.com',
// //             icon: Icons.email_outlined,
// //             controller: emailController,
// //             keyboardType: TextInputType.emailAddress,
// //             validator: (v) {
// //               if (v == null || v.trim().isEmpty) return 'Email is required';
// //               final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
// //               if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email';
// //               return null;
// //             },
// //           ),

// //           SizedBox(height: mq.size.height * 0.022),

// //           // ── Password ─────────────────────────────────────
// //           FincorpTextField(
// //             label: 'Password',
// //             hintText: '••••••••',
// //             icon: Icons.lock_outline,
// //             controller: passwordController,
// //             isPassword: true,
// //             validator: (v) {
// //               if (v == null || v.isEmpty) return 'Password is required';
// //               if (v.length < 6) return 'Minimum 6 characters';
// //               return null;
// //             },
// //           ),

// //           SizedBox(height: mq.size.height * 0.018),

// //           // ── Remember me + Forgot password ────────────────
// //           Row(
// //             children: [
// //               SizedBox(
// //                 width: 20,
// //                 height: 20,
// //                 child: Checkbox(
// //                   value: rememberMe,
// //                   onChanged: onRememberChanged,
// //                   activeColor: AppColors.primary,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                   side: const BorderSide(color: AppColors.gray400),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Text('Remember me', style: AppTextStyles.bodySmall(context)),
// //               const Spacer(),
// //               GestureDetector(
// //                 onTap: onForgotPassword,
// //                 child: Text(
// //                   'Forgot Password?',
// //                   style: AppTextStyles.link(context),
// //                 ),
// //               ),
// //             ],
// //           ),

// //           SizedBox(height: mq.size.height * 0.032),

// //           // ── Login button ──────────────────────────────────
// //           FincorpPrimaryButton(
// //             label: 'Login',
// //             onPressed: onLogin,
// //             isLoading: isLoading,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/CORE/Theme/app_color.dart';
// import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
// import 'package:mr_fincorp/CORE/Utils/responsive.dart';
// import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/button.dart';
// import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/text_field.dart';

// /// The email + password form card sitting in the white card area.
// class LoginForm extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final bool rememberMe;
//   final ValueChanged<bool?> onRememberChanged;
//   final VoidCallback onForgotPassword;
//   final VoidCallback onLogin;
//   final bool isLoading;

//   const LoginForm({
//     super.key,
//     required this.formKey,
//     required this.emailController,
//     required this.passwordController,
//     required this.rememberMe,
//     required this.onRememberChanged,
//     required this.onForgotPassword,
//     required this.onLogin,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dim = Dimensions(context);

//     return Form(
//       key: formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Email ────────────────────────────────────────
//           FincorpTextField(
//             label: 'Email',
//             hintText: 'you@example.com',
//             icon: Icons.email_outlined,
//             controller: emailController,
//             keyboardType: TextInputType.emailAddress,
//             validator: (v) {
//               if (v == null || v.trim().isEmpty) return 'Email is required';
//               final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//               if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email';
//               return null;
//             },
//           ),

//           // Clearer, consistent gap between Email and Password fields.
//           SizedBox(height: dim.gap(0.028)),

//           // ── Password ─────────────────────────────────────
//           FincorpTextField(
//             label: 'Password',
//             hintText: '••••••••',
//             icon: Icons.lock_outline,
//             controller: passwordController,
//             isPassword: true,
//             validator: (v) {
//               if (v == null || v.isEmpty) return 'Password is required';
//               if (v.length < 6) return 'Minimum 6 characters';
//               return null;
//             },
//           ),

//           SizedBox(height: dim.gap(0.02)),

//           // ── Remember me + Forgot password ────────────────
//           Row(
//             children: [
//               SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: Checkbox(
//                   value: rememberMe,
//                   onChanged: onRememberChanged,
//                   activeColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   side: const BorderSide(color: AppColors.gray400),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text('Remember me', style: AppTextStyles.bodySmall(context)),
//               const Spacer(),
//               GestureDetector(
//                 onTap: onForgotPassword,
//                 child: Text(
//                   'Forgot Password?',
//                   style: AppTextStyles.link(context),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: dim.gap(0.036)),

//           // ── Login button ──────────────────────────────────
//           FincorpPrimaryButton(
//             label: 'Login',
//             onPressed: onLogin,
//             isLoading: isLoading,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/button.dart';
import 'package:mr_fincorp/FEATURES/Login/presentation/widgets/text_field.dart';

/// The email + password form card sitting in the white card area.
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Email ────────────────────────────────────────
          FincorpTextField(
            label: 'Email',
            hintText: 'you@example.com',
            icon: Icons.email_outlined,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email';
              return null;
            },
          ),

          SizedBox(height: dim.gap(0.034)), // wider gap between Email and Password blocks

          // ── Password ─────────────────────────────────────
          FincorpTextField(
            label: 'Password',
            hintText: '••••••••',
            icon: Icons.lock_outline,
            controller: passwordController,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),

          SizedBox(height: dim.gap(0.02)),

          // ── Remember me + Forgot password ────────────────
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: rememberMe,
                  onChanged: onRememberChanged,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: AppColors.gray400),
                ),
              ),
              const SizedBox(width: 8),
              Text('Remember me', style: AppTextStyles.bodySmall(context)),
              const Spacer(),
              GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.link(context),
                ),
              ),
            ],
          ),

          SizedBox(height: dim.gap(0.036)),

          // ── Login button ──────────────────────────────────
          FincorpPrimaryButton(
            label: 'Login',
            onPressed: onLogin,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}