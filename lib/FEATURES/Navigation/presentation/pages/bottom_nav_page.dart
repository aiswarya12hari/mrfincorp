// import 'package:flutter/material.dart';

// import 'package:mr_fincorp/FEATURES/Collections/presentation/pages/collection_page.dart';
// import 'package:mr_fincorp/FEATURES/Dashboard/presentation/pages/dashboard_page.dart';
// import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loans_page.dart';
// import 'package:mr_fincorp/FEATURES/Profile/presentation/pages/profile_page.dart';

// import '../widgets/app_bottom_navbar.dart';

// class BottomNavPage extends StatefulWidget {
//   final int initialIndex;

//   const BottomNavPage({super.key, this.initialIndex = 0});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   late int _selectedIndex;

//   @override
//   void initState() {
//     super.initState();

//     _selectedIndex = widget.initialIndex;
//   }

//   final List<Widget> _pages = const [
//     DashboardPage(),
//     LoansPage(),
//     CollectionsPage(),
//     ProfilePage(),
//   ];

//   void _changeTab(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],

//       bottomNavigationBar: AppBottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _changeTab,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// import 'package:mr_fincorp/FEATURES/Collections/presentation/pages/collection_page.dart';
// import 'package:mr_fincorp/FEATURES/Dashboard/presentation/pages/dashboard_page.dart';
// import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loans_page.dart';
// import 'package:mr_fincorp/FEATURES/Profile/presentation/pages/profile_page.dart';

// import '../widgets/app_bottom_navbar.dart';

// class BottomNavPage extends StatefulWidget {
//   final int initialIndex;

//   const BottomNavPage({super.key, this.initialIndex = 0});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   late int _selectedIndex;

//   @override
//   void initState() {
//     super.initState();

//     _selectedIndex = widget.initialIndex;
//   }

//   final List<Widget> _pages = const [
//     DashboardPage(),
//     LoansPage(),
//     CollectionsPage(),
//     ProfilePage(),
//   ];

//   void _changeTab(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),

//       bottomNavigationBar: AppBottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _changeTab,
//       ),
//     );
//   }
// }

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

class _BottomNavPageState extends State<BottomNavPage> {
  @override
  void initState() {
    super.initState();
    // Seed the shared provider with whatever tab this page was opened on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().changeTab(widget.initialIndex);
    });
  }

  final List<Widget> _pages = const [
    DashboardPage(),
    LoansPage(),
    CollectionsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();

    return PopScope(
      canPop: nav.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && nav.currentIndex != 0) {
          // Not on Home => first back press returns to Home instead of exiting.
          context.read<NavigationProvider>().changeTab(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(index: nav.currentIndex, children: _pages),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: nav.currentIndex,
          onTap: (index) => context.read<NavigationProvider>().changeTab(index),
        ),
      ),
    );
  }
}
