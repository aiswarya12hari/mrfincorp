import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

import 'package:mr_fincorp/FEATURES/Collections/presentation/pages/collection_page.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/pages/dashboard_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loans_page.dart';
import 'package:mr_fincorp/FEATURES/Profile/presentation/pages/profile_page.dart';
import '../widgets/app_bottom_navbar.dart';

class BottomNavPage extends StatefulWidget {
  final int initialIndex;

  const BottomNavPage({super.key, this.initialIndex = 0});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  int _lastIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    LoansPage(),
    CollectionsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.initialIndex;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    final curve = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _fadeAnim = Tween<double>(begin: 0.4, end: 1.0).animate(curve);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.015),
      end: Offset.zero,
    ).animate(curve);

    _animController.value = 1.0;

    // Seed the shared provider with whatever tab this page was opened on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().changeTab(widget.initialIndex);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();

    if (nav.currentIndex != _lastIndex) {
      _lastIndex = nav.currentIndex;
      _animController.forward(from: 0.0);
    }

    return PopScope(
      canPop: nav.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && nav.currentIndex != 0) {
          // Not on Home => first back press returns to Home instead of exiting.
          context.read<NavigationProvider>().changeTab(0);
        }
      },
      child: Scaffold(
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: IndexedStack(
              index: nav.currentIndex,
              children: _pages,
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: nav.currentIndex,
          onTap: (index) => context.read<NavigationProvider>().changeTab(index),
        ),
      ),
    );
  }
}
