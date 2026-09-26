import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final size = dim.isTablet ? 96.0 : 84.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Card — clean with soft subtle shadow and refined rounded corners
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset('assets/icons/icon.png', fit: BoxFit.contain),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Field Staff Login',
          style: AppTextStyles.headline(context).copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: AppColors.gray800,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 6),

        Text(
          'Welcome back! Please login to continue',
          style: AppTextStyles.subheading(context).copyWith(
            fontSize: 13.5,
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
