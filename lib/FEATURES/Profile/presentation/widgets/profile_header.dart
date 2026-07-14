import 'package:flutter/material.dart';
import '../../../../../CORE/Theme/app_color.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
