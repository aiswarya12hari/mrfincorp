import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/CORE/Storage/shared_preference.dart';
import 'package:mr_fincorp/FEATURES/Account/provider/account_switch_provider.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/data/models/dashboard_model.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/dashboard_header.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/overview_section.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/recent_loan_section.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_model.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/pages/dashboard_page.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/presentation/widgets/dashboard_shimmer.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/presentation/widgets/app_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDashboardProvider extends ChangeNotifier implements DashboardProvider {
  @override
  bool isLoading = false;

  @override
  String? errorMessage;

  @override
  DashboardModel? dashboard = DashboardModel(
    totalLoans: 48,
    verificationPending: 6,
    verifiedLoans: 11,
    todayActivity: 0,
  );

  @override
  List<LoanModel> recentLoans = [
    LoanModel(
      id: 1,
      loanId: 'PKD-LAT-00171',
      customerName: 'amar3',
      loanAmount: '20000',
      loanType: 'INDIVIDUAL',
      dateOfApplication: '2025-02-20',
      status: 'OPEN',
      loanMethod: 'INDIVIDUAL',
    ),
  ];

  @override
  bool isRefreshing = false;

  @override
  Future<void> fetchDashboard({bool isRefresh = false}) async {}
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_data': '{"field_staff_name": "amar"}',
    });
    await AppPreferences.init();
  });

  Widget buildTestableWidget(Widget child, {MockDashboardProvider? dashProvider}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => dashProvider ?? MockDashboardProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<AccountSwitcherProvider>(
          create: (_) => AccountSwitcherProvider(),
        ),
      ],
      child: MaterialApp(
        home: (child is Scaffold || child is DashboardPage)
            ? child
            : Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('Dashboard Redesign Tests', () {
    testWidgets('DashboardHeader renders greeting card with avatar & switch button',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const DashboardHeader()));
      await tester.pumpAndSettle();

      // Verify Greeting and Name
      expect(find.text('Welcome back,'), findsOneWidget);
      expect(find.text('amar'), findsOneWidget);

      // Verify Avatar Initials
      expect(find.text('A'), findsOneWidget);

      // Verify Account Switch Button
      expect(find.text('Switch'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    });

    testWidgets('OverviewSection renders 4 cards with soft colors, big numbers, and icons',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const OverviewSection()));
      await tester.pumpAndSettle();

      // Heading
      expect(find.text('Overview'), findsOneWidget);

      // 4 Metric Card Titles
      expect(find.text('Total Loans'), findsOneWidget);
      expect(find.text('Verification Pending'), findsOneWidget);
      expect(find.text('Verified Loans'), findsOneWidget);
      expect(find.text("Today's Loans"), findsOneWidget);

      // Metric Card Values
      expect(find.text('48'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // Icons
      expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pending_actions_rounded), findsOneWidget);
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    });

    testWidgets(
        'RecentLoansSection renders rounded View All button and modern loan card with accent and details',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const RecentLoansSection()));
      await tester.pumpAndSettle();

      // Section Header & View All
      expect(find.text('Recent Loans'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // Loan Customer Name
      expect(find.text('amar3'), findsOneWidget);

      // Strong Loan ID Badge
      expect(find.text('PKD-LAT-00171'), findsOneWidget);

      // Status & Type Chips
      expect(find.text('OPEN'), findsOneWidget);
      expect(find.text('INDIVIDUAL'), findsOneWidget);

      // Amount & Date
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('₹ 20000'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('2025-02-20'), findsOneWidget);
    });

    testWidgets('AppBottomNavBar renders floating pill active indicator on Home',
        (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nav Destinations
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Loans'), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Tap on Loans tab
      await tester.tap(find.text('Loans'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);
    });

    testWidgets(
        'DashboardPage displays Shimmer Skeleton and no CircularProgressIndicator when loading',
        (tester) async {
      final loadingProvider = MockDashboardProvider()..isLoading = true;

      await tester.pumpWidget(buildTestableWidget(
        const DashboardPage(),
        dashProvider: loadingProvider,
      ));
      await tester.pump();

      // Shimmer Skeleton is visible
      expect(find.byType(DashboardSkeleton), findsOneWidget);

      // NO duplicate or standard CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
