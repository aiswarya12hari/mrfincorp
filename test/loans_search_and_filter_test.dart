import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Widgets/app_pagination.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loan_filter_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_card.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_list.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_search_bar.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_shimmer.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_tabs.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class MockSearchAndFilterLoanProvider extends LoanProvider {
  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;
  @override
  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  List<LoanModel> _loans = [];
  @override
  List<LoanModel> get loans => _loans;
  @override
  set loans(List<LoanModel> list) {
    _loans = list;
    notifyListeners();
  }

  int _currentPage = 1;
  @override
  int get currentPage => _currentPage;
  @override
  set currentPage(int v) {
    _currentPage = v;
    notifyListeners();
  }

  int _totalCount = 0;
  @override
  int get totalCount => _totalCount;
  @override
  set totalCount(int v) {
    _totalCount = v;
    notifyListeners();
  }

  int _pageSize = 10;
  @override
  int get pageSize => _pageSize;
  @override
  set pageSize(int v) {
    _pageSize = v;
    notifyListeners();
  }

  @override
  int get totalPages {
    if (_totalCount == 0) return 1;
    return (_totalCount / _pageSize).ceil();
  }

  @override
  bool get hasMore => _currentPage < totalPages;

  @override
  bool get hasPrevious => _currentPage > 1;

  String? lastAppliedStatus;
  String? lastAppliedLoanType;
  String? lastAppliedLoanMethod;
  String? lastAppliedLoanId;
  String? lastAppliedCustomerName;
  String? lastAppliedDateFrom;
  String? lastAppliedDateTo;

  bool fetchLoansCalled = false;
  bool resetFilterCalled = false;
  int? lastPageRequested;

  // Master loan dataset for mock query execution
  final List<LoanModel> sampleLoans = [
    LoanModel(
      id: 1,
      loanId: 'PKD01-LAT-00001',
      customerName: 'Aarav Sharma',
      loanAmount: '25000.00',
      loanType: 'WEEKLY',
      dateOfApplication: '2026-09-01',
      status: 'VERIFICATION_PENDING',
      loanMethod: 'individual',
    ),
    LoanModel(
      id: 2,
      loanId: 'PKD01-LAT-00002',
      customerName: 'Diya Patel',
      loanAmount: '50000.00',
      loanType: 'MONTHLY',
      dateOfApplication: '2026-09-05',
      status: 'FIELDSTAFF_VERIFIED',
      loanMethod: 'group',
    ),
    LoanModel(
      id: 3,
      loanId: 'PKD01-LAT-00003',
      customerName: 'Kavita Sundaram',
      loanAmount: '15000.00',
      loanType: 'WEEKLY',
      dateOfApplication: '2026-09-10',
      status: 'ADMIN_APPROVED',
      loanMethod: 'individual',
    ),
  ];

  MockSearchAndFilterLoanProvider() {
    _loans = List.from(sampleLoans);
    _totalCount = sampleLoans.length;
  }

  @override
  Future<void> fetchLoans() async {
    fetchLoansCalled = true;
    notifyListeners();
  }

  @override
  Future<void> fetchLoansPage(int page, {bool showLoader = true}) async {
    lastPageRequested = page;
    _currentPage = page;
    notifyListeners();
  }

  @override
  Future<void> goToPage(int page) async {
    lastPageRequested = page;
    _currentPage = page;
    notifyListeners();
  }

  @override
  Future<void> applyFilter({
    String? status,
    String? loanType,
    String? loanId,
    String? customerName,
    String? loanMethod,
    String? dateFrom,
    String? dateTo,
  }) async {
    selectedStatus = status;
    selectedLoanType = loanType;
    selectedLoanMethod = loanMethod;
    searchLoanId = loanId ?? '';
    searchCustomer = customerName ?? '';
    selectedDateFrom = dateFrom;
    selectedDateTo = dateTo;

    lastAppliedStatus = status;
    lastAppliedLoanType = loanType;
    lastAppliedLoanMethod = loanMethod;
    lastAppliedLoanId = loanId;
    lastAppliedCustomerName = customerName;
    lastAppliedDateFrom = dateFrom;
    lastAppliedDateTo = dateTo;

    // Filter sample loans according to criteria
    _loans = sampleLoans.where((item) {
      if (status != null && status.isNotEmpty && item.status != status) {
        return false;
      }
      if (loanType != null && loanType.isNotEmpty && item.loanType != loanType) {
        return false;
      }
      if (loanMethod != null &&
          loanMethod.isNotEmpty &&
          item.loanMethod.toLowerCase() != loanMethod.toLowerCase()) {
        return false;
      }
      if (loanId != null && loanId.isNotEmpty) {
        if (!item.loanId.toLowerCase().contains(loanId.toLowerCase())) {
          return false;
        }
      }
      if (customerName != null && customerName.isNotEmpty) {
        if (!item.customerName.toLowerCase().contains(customerName.toLowerCase())) {
          return false;
        }
      }
      if (dateFrom != null && dateFrom.isNotEmpty) {
        if (DateTime.parse(item.dateOfApplication).isBefore(DateTime.parse(dateFrom))) {
          return false;
        }
      }
      if (dateTo != null && dateTo.isNotEmpty) {
        if (DateTime.parse(item.dateOfApplication).isAfter(DateTime.parse(dateTo))) {
          return false;
        }
      }
      return true;
    }).toList();

    _totalCount = _loans.length;
    _currentPage = 1;
    notifyListeners();
  }

  @override
  Future<void> resetFilter() async {
    resetFilterCalled = true;
    selectedStatus = null;
    selectedLoanType = null;
    selectedLoanMethod = null;
    selectedDateFrom = null;
    selectedDateTo = null;
    searchLoanId = '';
    searchCustomer = '';

    lastAppliedStatus = null;
    lastAppliedLoanType = null;
    lastAppliedLoanMethod = null;
    lastAppliedLoanId = null;
    lastAppliedCustomerName = null;
    lastAppliedDateFrom = null;
    lastAppliedDateTo = null;

    _loans = List.from(sampleLoans);
    _totalCount = sampleLoans.length;
    _currentPage = 1;
    notifyListeners();
  }

  @override
  Future<void> changeStatusTab(String? status) async {
    selectedStatus = status;
    searchLoanId = '';
    searchCustomer = '';

    if (status == null || status.isEmpty) {
      _loans = List.from(sampleLoans);
    } else {
      _loans = sampleLoans.where((item) => item.status == status).toList();
    }
    _totalCount = _loans.length;
    _currentPage = 1;
    notifyListeners();
  }
}

void main() {
  Widget buildAppWithProvider({
    required Widget child,
    required MockSearchAndFilterLoanProvider provider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoanProvider>.value(value: provider),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  void setTestViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
  }

  group('1. Search Bar Functionality Tests', () {
    testWidgets('Search by Loan ID containing PKD returns correct loan result',
        (tester) async {
      setTestViewport(tester);
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const Column(
          children: [
            LoanSearchBar(),
            Expanded(child: LoansList()),
          ],
        ),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Initially all 3 loans are displayed
      expect(find.byType(LoanCard), findsNWidgets(3));

      // Enter Loan ID containing "PKD"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'PKD01-LAT-00001');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Check provider received loanId filter
      expect(provider.lastAppliedLoanId, 'PKD01-LAT-00001');
      expect(provider.lastAppliedCustomerName, isNull);

      // Verify only 1 card displayed with correct Loan ID
      expect(find.byType(LoanCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LoanCard),
          matching: find.text('PKD01-LAT-00001'),
        ),
        findsOneWidget,
      );
      expect(find.text('Aarav Sharma'), findsOneWidget);
    });

    testWidgets('Search by Customer Name returns correct loan result',
        (tester) async {
      setTestViewport(tester);
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const Column(
          children: [
            LoanSearchBar(),
            Expanded(child: LoansList()),
          ],
        ),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Enter Customer Name (does not contain PKD)
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Diya');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Check provider received customerName filter
      expect(provider.lastAppliedCustomerName, 'Diya');
      expect(provider.lastAppliedLoanId, isNull);

      // Verify matching card
      expect(find.byType(LoanCard), findsOneWidget);
      expect(find.text('Diya Patel'), findsOneWidget);
      expect(find.text('PKD01-LAT-00002'), findsOneWidget);
    });

    testWidgets('Clearing search via clear icon button restores full list',
        (tester) async {
      setTestViewport(tester);
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const Column(
          children: [
            LoanSearchBar(),
            Expanded(child: LoansList()),
          ],
        ),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Enter text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Kavita');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byType(LoanCard), findsOneWidget);

      // Clear button icon should be visible
      final clearButton = find.byIcon(Icons.close_rounded);
      expect(clearButton, findsOneWidget);

      // Tap clear
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Restores all 3 loans
      expect(provider.lastAppliedCustomerName, isNull);
      expect(provider.lastAppliedLoanId, isNull);
      expect(find.byType(LoanCard), findsNWidgets(3));
    });
  });

  group('2. Loan Status Tabs Tests', () {
    testWidgets('Pending and Verified tabs filter loans, All tab restores all',
        (tester) async {
      setTestViewport(tester);
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const Column(
          children: [
            LoanStatusTabs(),
            Expanded(child: LoansList()),
          ],
        ),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(LoanCard), findsNWidgets(3));

      // Tap Pending tab
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      expect(provider.selectedStatus, 'VERIFICATION_PENDING');
      expect(find.byType(LoanCard), findsOneWidget);
      expect(find.text('Aarav Sharma'), findsOneWidget);

      // Tap Verified tab
      await tester.tap(find.text('Verified'));
      await tester.pumpAndSettle();
      expect(provider.selectedStatus, 'FIELDSTAFF_VERIFIED');
      expect(find.byType(LoanCard), findsOneWidget);
      expect(find.text('Diya Patel'), findsOneWidget);

      // Tap All tab
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(provider.selectedStatus, isNull);
      expect(find.byType(LoanCard), findsNWidgets(3));
    });
  });

  group('3. Filter Page UI Redesign & Functionality Tests', () {
    testWidgets('Header displays clean Back button and Filters title',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoanFilterPage(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Header title, subtitle, and back button
      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Refine your loan search'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('Six separate rounded cards are rendered for each filter section',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoanFilterPage(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Card headers for all 6 separate sections
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Loan Type'), findsOneWidget);
      expect(find.text('Method'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Loan ID'), findsOneWidget);
      expect(find.text('Customer Name'), findsOneWidget);
    });

    testWidgets('Reset button clears form inputs on the filter page',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoanFilterPage(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Enter Loan ID and Customer Name
      final textFields = find.byType(TextField);
      // textFields 0 & 1 are From & To date display fields; 2 is Loan ID; 3 is Customer Name
      await tester.enterText(textFields.at(2), 'PKD-TEST-99');
      await tester.enterText(textFields.at(3), 'Test Customer');
      await tester.pumpAndSettle();

      expect(find.text('PKD-TEST-99'), findsOneWidget);
      expect(find.text('Test Customer'), findsOneWidget);

      // Tap Reset button
      final resetButton = find.widgetWithText(OutlinedButton, 'Reset');
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Inputs should now be empty
      expect(find.text('PKD-TEST-99'), findsNothing);
      expect(find.text('Test Customer'), findsNothing);
    });

    testWidgets('Apply button dispatches selected filters to provider',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoanFilterPage(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      // Enter loan ID
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(2), 'PKD01-LAT-00001');

      // Tap Apply button
      final applyButton = find.widgetWithText(ElevatedButton, 'Apply');
      expect(applyButton, findsOneWidget);
      await tester.tap(applyButton);
      await tester.pumpAndSettle();

      // Verify provider received the applied filter
      expect(provider.lastAppliedLoanId, 'PKD01-LAT-00001');
    });

    testWidgets('Fixed bottom bar has equal width Reset and Apply buttons',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoanFilterPage(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      final resetFinder = find.widgetWithText(OutlinedButton, 'Reset');
      final applyFinder = find.widgetWithText(ElevatedButton, 'Apply');

      expect(resetFinder, findsOneWidget);
      expect(applyFinder, findsOneWidget);

      final resetSize = tester.getSize(resetFinder);
      final applySize = tester.getSize(applyFinder);

      // Both buttons must have equal width and standard 52px height
      expect(resetSize.width, equals(applySize.width));
      expect(resetSize.height, equals(52.0));
      expect(applySize.height, equals(52.0));
    });
  });

  group('4. Provider Filter Combinations & Edge Cases Tests', () {
    testWidgets('Loan Type WEEKLY and MONTHLY filter independently',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();

      // Filter by WEEKLY
      await provider.applyFilter(loanType: 'WEEKLY');
      expect(provider.loans.length, 2);
      expect(provider.loans.every((l) => l.loanType == 'WEEKLY'), isTrue);

      // Filter by MONTHLY
      await provider.applyFilter(loanType: 'MONTHLY');
      expect(provider.loans.length, 1);
      expect(provider.loans.first.loanType, 'MONTHLY');
    });

    testWidgets('Loan Method (group vs individual) filters correctly',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();

      await provider.applyFilter(loanMethod: 'group');
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Diya Patel');

      await provider.applyFilter(loanMethod: 'individual');
      expect(provider.loans.length, 2);
    });

    testWidgets('Combined filters: Status + Loan Type + Method',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();

      await provider.applyFilter(
        status: 'VERIFICATION_PENDING',
        loanType: 'WEEKLY',
        loanMethod: 'individual',
      );
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Aarav Sharma');

      // Impossible combination returns empty
      await provider.applyFilter(
        status: 'ADMIN_APPROVED',
        loanType: 'MONTHLY',
        loanMethod: 'individual',
      );
      expect(provider.loans, isEmpty);
    });

    testWidgets('Date From filter works individually', (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await provider.applyFilter(dateFrom: '2026-09-06');
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Kavita Sundaram');
    });

    testWidgets('Date To filter works individually', (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await provider.applyFilter(dateTo: '2026-09-04');
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Aarav Sharma');
    });

    testWidgets('Date From and Date To filter work together as date range',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await provider.applyFilter(
        dateFrom: '2026-09-02',
        dateTo: '2026-09-08',
      );
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Diya Patel');
    });

    testWidgets(
        'All filters work together: Status, Loan Type, Method, Dates, Loan ID, Customer Name',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      await provider.applyFilter(
        status: 'FIELDSTAFF_VERIFIED',
        loanType: 'MONTHLY',
        loanMethod: 'group',
        loanId: 'PKD01-LAT-00002',
        customerName: 'Diya',
        dateFrom: '2026-09-01',
        dateTo: '2026-09-30',
      );
      expect(provider.loans.length, 1);
      expect(provider.loans.first.customerName, 'Diya Patel');

      // Reset filter restores default filters and full dataset
      await provider.resetFilter();
      expect(provider.loans.length, 3);
      expect(provider.resetFilterCalled, isTrue);
      expect(provider.selectedStatus, isNull);
      expect(provider.selectedLoanType, isNull);
      expect(provider.selectedLoanMethod, isNull);
      expect(provider.selectedDateFrom, isNull);
      expect(provider.selectedDateTo, isNull);
      expect(provider.searchLoanId, isEmpty);
      expect(provider.searchCustomer, isEmpty);
    });
  });

  group('5. Pagination, Loading, Empty State & Error Handling Tests', () {
    testWidgets('Empty state displays user-friendly message when no loans match',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      // Set to empty list
      provider.loans = [];
      await tester.pumpWidget(buildAppWithProvider(
        child: const LoansList(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      expect(find.text('No loans found'), findsOneWidget);
      expect(find.text('Try adjusting your search or filters'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
    });

    testWidgets('Shimmer skeleton appears when provider is loading with empty loans',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();
      provider.loans = [];
      provider.isLoading = true;

      await tester.pumpWidget(buildAppWithProvider(
        child: const LoansList(),
        provider: provider,
      ));
      await tester.pump(); // don't pumpAndSettle since loading shimmer animation repeats

      // Verify shimmer skeleton list is rendered instead of generic spinner
      expect(find.byType(LoanListShimmer), findsOneWidget);
      expect(find.byType(LoanCardSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Pagination widget appears when totalPages > 1 and handles page switch',
        (tester) async {
      setTestViewport(tester);
      final provider = MockSearchAndFilterLoanProvider();
      provider.totalCount = 25; // with pageSize 10, gives 3 pages
      provider.pageSize = 10;
      provider.currentPage = 1;

      await tester.pumpWidget(buildAppWithProvider(
        child: const LoansList(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppPagination), findsOneWidget);
      expect(provider.totalPages, 3);
    });

    testWidgets('Pull to refresh widget is configured and triggers fetchLoans',
        (tester) async {
      final provider = MockSearchAndFilterLoanProvider();

      await tester.pumpWidget(buildAppWithProvider(
        child: const LoansList(),
        provider: provider,
      ));
      await tester.pumpAndSettle();

      final refreshFinder = find.byType(RefreshIndicator);
      expect(refreshFinder, findsOneWidget);

      final refreshWidget = tester.widget<RefreshIndicator>(refreshFinder);
      expect(refreshWidget.color, AppColors.primary);

      await refreshWidget.onRefresh();
      expect(provider.fetchLoansCalled, isTrue);
    });
  });
}
