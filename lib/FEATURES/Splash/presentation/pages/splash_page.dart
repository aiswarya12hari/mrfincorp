import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';

import '../../../../CORE/Storage/shared_preference.dart';
import '../../../../CORE/Theme/app_color.dart';

import '../../../Login/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (AppPreferences.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.55, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon card ─────────────────────────────────
                Container(
                  width: dim.isTablet ? 140 : 120,
                  height: dim.isTablet ? 140 : 120,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withOpacity(0.35),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Image.asset(
                      'assets/icons/icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: dim.gap(0.035)),

                // ── App name ──────────────────────────────────
                Text(
                  'Mr Fincorp',
                  style: TextStyle(
                    fontSize: dim.sp(30),
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.2,
                  ),
                ),

                SizedBox(height: dim.gap(0.01)),

                // ── Tagline ───────────────────────────────────
                Text(
                  'Field Staff. Field Ready.',
                  style: TextStyle(
                    fontSize: dim.sp(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withOpacity(0.9),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


