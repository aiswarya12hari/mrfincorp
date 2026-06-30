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
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      );
}