import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';

import '../../../../CORE/Network/api_client.dart';
import '../../../../CORE/Storage/shared_preference.dart';

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
    // Starts counting immediately, runs in parallel with the
    // session check below — not a blocking sequential delay.
    final minDelay = Future.delayed(const Duration(seconds: 2));

    if (!AppPreferences.isLoggedIn()) {
      debugPrint('Splash: no stored token => LoginPage');
      await minDelay;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    SessionStatus status;
    try {
      status = await ApiClient.validateSession();
    } catch (e) {
      debugPrint('Splash: validateSession threw => $e');
      status = SessionStatus.invalid;
    }

    debugPrint('Splash: session status => $status');

    await minDelay;
    if (!mounted) return;

    switch (status) {
      case SessionStatus.valid:
        debugPrint('Splash: valid session => BottomNavPage');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavPage()),
        );
        break;

      case SessionStatus.networkError:
        debugPrint('Splash: network error => BottomNavPage (offline entry)');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavPage()),
        );
        break;

      case SessionStatus.invalid:
        debugPrint('Splash: invalid session => removing account');
        final activeId = AppPreferences.getActiveUserId();
        final nextAccount = activeId != null
            ? await AppPreferences.removeAccount(activeId)
            : null;
        if (activeId == null) await AppPreferences.clearAll();

        if (!mounted) return;

        if (nextAccount != null) {
          debugPrint('Splash: switched to another saved account');
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dim = Dimensions(context);
    final logoSize = dim.isTablet ? 148.0 : 120.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/icon.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
