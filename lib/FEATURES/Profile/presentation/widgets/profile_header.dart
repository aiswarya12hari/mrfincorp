import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: AppColors.textPrimary,
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.read<NavigationProvider>().changeTab(0);
          }
        },
      ),
      titleSpacing: 0,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
