import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loans_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_card.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_search_bar.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_tabs.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class MockLoanProvider extends LoanProvider {
  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  List<LoanModel> get loans => [
        LoanModel(
          id: 1,
          loanId: 'PKD01-LAT-00001',
          customerName: 'John',
          loanAmount: '25000.00',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
      ];

  @override
  int get currentPage => 1;

  @override
  int get totalPages => 1;

  @override
  bool get hasMore => false;

  String? _status;
  @override
  String? get selectedStatus => _status;

  @override
  Future<void> fetchLoans({int page = 1, bool isRefresh = false}) async {}

  @override
  Future<void> changeStatusTab(String? status) async {
    _status = status;
    notifyListeners();
  }

  @override
  Future<void> resetFilter() async {
    _status = null;
    notifyListeners();
  }
}

void main() {
  Widget buildTestableWidget(Widget child, {MockLoanProvider? provider}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoanProvider>(
          create: (_) => provider ?? MockLoanProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  group('LoansPage Redesign Tests', () {
    testWidgets('Header displays bold Loans title, rounded back & filter buttons',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoansPage()));
      await tester.pumpAndSettle();

      // Title
      expect(find.text('Loans'), findsOneWidget);

      // Back and Filter icons
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    });

    testWidgets('Status tabs render All, Pending, Verified and handle selection',
        (tester) async {
      final provider = MockLoanProvider();
      await tester.pumpWidget(buildTestableWidget(
        const LoanStatusTabs(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Verified'), findsOneWidget);

      // Tap Pending tab
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      expect(provider.selectedStatus, 'VERIFICATION_PENDING');

      // Tap All tab
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(provider.selectedStatus, isNull);
    });

    testWidgets('Search bar renders with placeholder and search icon',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoanSearchBar()));
      await tester.pumpAndSettle();

      expect(find.text('Search by Loan ID or Customer name...'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('LoanCard UI is rendered intact without breaking layout',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoansPage()));
      await tester.pumpAndSettle();

      // Verify LoanCard is present and displays customer, loanId, amount
      expect(find.byType(LoanCard), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('PKD01-LAT-00001'), findsOneWidget);
      expect(find.text('₹ 25000.00'), findsOneWidget);
      expect(find.text('VERIFICATION PENDING'), findsOneWidget);
    });
  });
}
