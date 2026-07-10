// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/CORE/Utils/responsive.dart';
// import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';

// import '../../../../CORE/Storage/shared_preference.dart';
// import '../../../../CORE/Theme/app_color.dart';

// import '../../../Login/presentation/pages/login_page.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLogin();
//   }

//   Future<void> _checkLogin() async {
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     if (AppPreferences.isLoggedIn()) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const BottomNavPage()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dim = Dimensions(context);

//     return Scaffold(
//       body: DecoratedBox(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppColors.primaryLight,
//               AppColors.primary,
//               AppColors.primaryDark,
//             ],
//             stops: [0.0, 0.55, 1.0],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // ── Icon card ─────────────────────────────────
//                 Container(
//                   width: dim.isTablet ? 140 : 120,
//                   height: dim.isTablet ? 140 : 120,
//                   decoration: BoxDecoration(
//                     color: AppColors.white.withOpacity(0.16),
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.primaryDark.withOpacity(0.35),
//                         blurRadius: 30,
//                         offset: const Offset(0, 12),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Image.asset(
//                       'assets/icons/icon.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: dim.gap(0.035)),

//                 // ── App name ──────────────────────────────────
//                 Text(
//                   'Mr Fincorp',
//                   style: TextStyle(
//                     fontSize: dim.sp(30),
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.white,
//                     letterSpacing: 0.2,
//                   ),
//                 ),

//                 SizedBox(height: dim.gap(0.01)),

//                 // ── Tagline ───────────────────────────────────
//                 Text(
//                   'Field Staff. Field Ready.',
//                   style: TextStyle(
//                     fontSize: dim.sp(14),
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.white.withOpacity(0.9),
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Utils/responsive.dart';
import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';

import '../../../../CORE/Network/api_client.dart';
import '../../../../CORE/Storage/shared_preference.dart';
import '../../../../CORE/Theme/app_color.dart';

import '../../../Login/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
      ),
    );

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        // Couldn't reach the server — don't punish the user for
        // being offline. Let them into the app with the stored
        // token; individual screens will retry/refresh once
        // connectivity is back.
        debugPrint('Splash: network error => BottomNavPage (offline entry)');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavPage()),
        );
        break;

      case SessionStatus.invalid:
        debugPrint('Splash: invalid session => clearing + LoginPage');
        await AppPreferences.clearAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        break;
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
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ── Subtle decorative background circles ─────────
            Positioned(
              top: -60,
              right: -60,
              child: _softCircle(220, AppColors.white.withOpacity(0.05)),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: _softCircle(260, AppColors.white.withOpacity(0.05)),
            ),

            SafeArea(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Icon card ─────────────────────
                              Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: Container(
                                    width: dim.isTablet ? 148 : 128,
                                    height: dim.isTablet ? 148 : 128,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.18),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryDark
                                              .withOpacity(0.4),
                                          blurRadius: 36,
                                          offset: const Offset(0, 16),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                        'assets/icons/icon.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: dim.gap(0.04)),

                              // ── App name ──────────────────────
                              Opacity(
                                opacity: _textOpacity.value,
                                child: SlideTransition(
                                  position: _textSlide,
                                  child: Text(
                                    'Mr Fincorp',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: dim.sp(30),
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: dim.gap(0.012)),

                              // ── Tagline ───────────────────────
                              Opacity(
                                opacity: _taglineOpacity.value,
                                child: Text(
                                  'Field Staff. Field Ready.',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: dim.sp(14),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white.withOpacity(0.85),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Bottom loader ───────────────────────
                      Opacity(
                        opacity: _loaderOpacity.value,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: dim.gap(0.05)),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white.withOpacity(0.85),
                                  ),
                                ),
                              ),
                              SizedBox(height: dim.gap(0.015)),
                              Text(
                                'Loading your workspace',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: dim.sp(11.5),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white.withOpacity(0.6),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}