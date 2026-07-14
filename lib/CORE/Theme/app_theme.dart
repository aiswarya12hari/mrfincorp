import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.gray100,
        ),
        scaffoldBackgroundColor: AppColors.gray100,
        // Aligned with AppTextStyles.fontFamily so text without an
        // explicit style (SnackBars, default widget labels, etc.)
        // doesn't render in a different typeface.
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      );
}