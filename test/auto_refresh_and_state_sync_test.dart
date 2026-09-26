import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collected_collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/Widgets/collection_tab_toggle.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/pages/collection_page.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collected_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/provider/dashboard_provider.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loans_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_tabs.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_provider.dart';
import 'package:mr_fincorp/FEATURES/Navigation/navigation_provider.dart';
import 'package:mr_fincorp/main.dart';
import 'package:provider/provider.dart';

class TestableLoanProvider extends LoanProvider {
  int fetchLoansCallCount = 0;
  int fetchLoansPageCallCount = 0;

  @override
  Future<void> fetchLoans() async {
    fetchLoansCallCount++;
    currentPage = 1;
    loans.clear();
    await fetchLoansPage(1, showLoader: true);
  }

  @override
  Future<void> fetchLoansPage(int page, {bool showLoader = true}) async {
    fetchLoansPageCallCount++;
    currentPage = page;
    if (showLoader) {
      isLoading = true;
      notifyListeners();
    }

    // Mock API result according to selectedStatus
    if (selectedStatus == 'VERIFICATION_PENDING') {
      loans = [
        LoanModel(
          id: 1,
          loanId: 'LOAN-PENDING-1',
          customerName: 'Alice',
          loanAmount: '10000',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
      ];
      totalCount = 1;
    } else if (selectedStatus == 'FIELDSTAFF_VERIFIED') {
      loans = [
        LoanModel(
          id: 2,
          loanId: 'LOAN-VERIFIED-1',
          customerName: 'Bob',
          loanAmount: '20000',
          loanType: 'WEEKLY',
          dateOfApplication: '2026-09-02',
          status: 'FIELDSTAFF_VERIFIED',
          loanMethod: 'INDIVIDUAL',
        ),
      ];
      totalCount = 1;
    } else {
      loans = [
        LoanModel(
          id: 1,
          loanId: 'LOAN-PENDING-1',
          customerName: 'Alice',
          loanAmount: '10000',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
        LoanModel(
          id: 2,
          loanId: 'LOAN-VERIFIED-1',
          customerName: 'Bob',
          loanAmount: '20000',
          loanType: 'WEEKLY',
          dateOfApplication: '2026-09-02',
          status: 'FIELDSTAFF_VERIFIED',
          loanMethod: 'INDIVIDUAL',
        ),
      ];
      totalCount = 2;
    }

    isLoading = false;
    notifyListeners();
  }
}

class TestableCollectionListProvider extends CollectionListProvider {
  int fetchCallCount = 0;

  @override
  Future<void> fetchCollections() async {
    fetchCallCount++;
    currentPage = 1;
    collections.clear();
    await fetchCollectionsPage(1, showLoader: true);
  }

  @override
  Future<void> fetchCollectionsPage(int page, {bool showLoader = true}) async {
    currentPage = page;
    if (showLoader) {
      isLoading = true;
      notifyListeners();
    }
    collections = [
      const CollectionModel(
        slNo: 1,
        assignmentId: 101,
        loanId: 'LOAN-COL-1',
        loanMethod: 'INDIVIDUAL',
        customerName: 'Charlie',
        loanType: 'DAILY',
        branchName: 'Main',
        principalPending: 5000,
        duePending: 2,
        isCollected: false,
        collectedAmount: 0,
        collectionDate: null,
        paymentMethod: 'CASH',
        feedback: '',
        createdAt: '2026-09-01',
        loanStatus: 'ACTIVE',
      ),
    ];
    totalCount = collections.length;
    isLoading = false;
    notifyListeners();
  }
}

class TestableCollectedListProvider extends CollectedListProvider {
  int fetchCallCount = 0;

  @override
  Future<void> fetchCollected() async {
    fetchCallCount++;
    currentPage = 1;
    collectedItems.clear();
    await fetchCollectedPage(1, showLoader: true);
  }

  @override
  Future<void> fetchCollectedPage(int page, {bool showLoader = true}) async {
    currentPage = page;
    if (showLoader) {
      isLoading = true;
      notifyListeners();
    }
    collectedItems = [
      const CollectedCollectionModel(
        id: 201,
        loanId: 'LOAN-COL-2',
        customerName: 'Dave',
        area: 'Main',
        loanType: 'WEEKLY',
        loanStatus: 'ACTIVE',
        principalPending: 0,
        duesPending: 0,
        dueDate: '2026-09-10',
        installmentAmount: 1000,
        isCollected: true,
        collectedAmount: 1000,
        paymentMethod: 'CASH',
        feedback: '',
        collectionDate: '2026-09-10',
        collectedDate: '2026-09-10',
      ),
    ];
    totalCount = collectedItems.length;
    isLoading = false;
    notifyListeners();
  }
}

class TestableDashboardProvider extends DashboardProvider {
  int fetchCallCount = 0;

  @override
  Future<void> fetchDashboard({bool isRefresh = false}) async {
    fetchCallCount++;
    notifyListeners();
  }
}

void main() {
  group('Auto-refresh and State Synchronization Tests', () {
    test('LoanProvider onLoanVerified removes from Pending and updates counts immediately', () {
      final provider = LoanProvider();
      provider.selectedStatus = 'VERIFICATION_PENDING';
      provider.loans = [
        LoanModel(
          id: 1,
          loanId: 'L-001',
          customerName: 'John',
          loanAmount: '10000',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
        LoanModel(
          id: 2,
          loanId: 'L-002',
          customerName: 'Alice',
          loanAmount: '15000',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
      ];
      provider.totalCount = 2;

      // Verify loan L-001
      provider.onLoanVerified(loanId: 'L-001', status: 'FIELDSTAFF_VERIFIED');

      // Immediately removed from Pending list
      expect(provider.loans.length, 1);
      expect(provider.loans.first.loanId, 'L-002');
      expect(provider.totalCount, 1);
    });

    test('LoanProvider onLoanVerified updates status in All list immediately', () {
      final provider = LoanProvider();
      provider.selectedStatus = null; // All tab
      provider.loans = [
        LoanModel(
          id: 1,
          loanId: 'L-001',
          customerName: 'John',
          loanAmount: '10000',
          loanType: 'DAILY',
          dateOfApplication: '2026-09-01',
          status: 'VERIFICATION_PENDING',
          loanMethod: 'INDIVIDUAL',
        ),
      ];
      provider.totalCount = 1;

      // Verify loan L-001
      provider.onLoanVerified(loanId: 'L-001', status: 'FIELDSTAFF_VERIFIED');

      expect(provider.loans.length, 1);
      expect(provider.loans.first.status, 'FIELDSTAFF_VERIFIED');
    });

    test('LoanProvider onLoanVerified adds or updates in Verified tab immediately', () {
      final provider = LoanProvider();
      provider.selectedStatus = 'FIELDSTAFF_VERIFIED';
      provider.loans = [];
      provider.totalCount = 0;

      final verifiedLoan = LoanModel(
        id: 1,
        loanId: 'L-001',
        customerName: 'John',
        loanAmount: '10000',
        loanType: 'DAILY',
        dateOfApplication: '2026-09-01',
        status: 'FIELDSTAFF_VERIFIED',
        loanMethod: 'INDIVIDUAL',
      );

      provider.onLoanVerified(
        loanId: 'L-001',
        status: 'FIELDSTAFF_VERIFIED',
        updatedLoan: verifiedLoan,
      );

      expect(provider.loans.length, 1);
      expect(provider.loans.first.loanId, 'L-001');
      expect(provider.totalCount, 1);
    });

    test('CollectionListProvider onCollectionSubmitted immediately removes item from outstanding list', () {
      final provider = CollectionListProvider();
      provider.collections = [
        const CollectionModel(
          slNo: 1,
          assignmentId: 101,
          loanId: 'COL-001',
          loanMethod: 'INDIVIDUAL',
          customerName: 'Charlie',
          loanType: 'DAILY',
          branchName: 'Main',
          principalPending: 5000,
          duePending: 2,
          isCollected: false,
          collectedAmount: 0,
          collectionDate: null,
          paymentMethod: 'CASH',
          feedback: '',
          createdAt: '2026-09-01',
          loanStatus: 'ACTIVE',
        ),
        const CollectionModel(
          slNo: 2,
          assignmentId: 102,
          loanId: 'COL-002',
          loanMethod: 'INDIVIDUAL',
          customerName: 'David',
          loanType: 'DAILY',
          branchName: 'Main',
          principalPending: 6000,
          duePending: 1,
          isCollected: false,
          collectedAmount: 0,
          collectionDate: null,
          paymentMethod: 'CASH',
          feedback: '',
          createdAt: '2026-09-01',
          loanStatus: 'ACTIVE',
        ),
      ];
      provider.totalCount = 2;

      provider.onCollectionSubmitted(101);

      expect(provider.collections.length, 1);
      expect(provider.collections.first.assignmentId, 102);
      expect(provider.totalCount, 1);
    });

    testWidgets('Switching between All, Pending, and Verified tabs fetches fresh data without stale results', (tester) async {
      final loanProvider = TestableLoanProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LoanProvider>.value(value: loanProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(body: LoanStatusTabs()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Pending tab
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();

      expect(loanProvider.selectedStatus, 'VERIFICATION_PENDING');
      expect(loanProvider.loans.length, 1);
      expect(loanProvider.loans.first.loanId, 'LOAN-PENDING-1');

      // Tap Verified tab
      await tester.tap(find.text('Verified'));
      await tester.pumpAndSettle();

      expect(loanProvider.selectedStatus, 'FIELDSTAFF_VERIFIED');
      expect(loanProvider.loans.length, 1);
      expect(loanProvider.loans.first.loanId, 'LOAN-VERIFIED-1');

      // Tap All tab
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(loanProvider.selectedStatus, isNull);
      expect(loanProvider.loans.length, 2);
    });

    testWidgets('NavigationProvider tab switch and re-tap triggers auto-refresh on LoansPage', (tester) async {
      final loanProvider = TestableLoanProvider();
      final navProvider = NavigationProvider();
      final dashProvider = TestableDashboardProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LoanProvider>.value(value: loanProvider),
            ChangeNotifierProvider<NavigationProvider>.value(value: navProvider),
            ChangeNotifierProvider<DashboardProvider>.value(value: dashProvider),
          ],
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: const Scaffold(body: LoansPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialFetchCount = loanProvider.fetchLoansCallCount;
      expect(initialFetchCount, greaterThanOrEqualTo(1));

      // Switch to tab 1 (Loans tab) via NavigationProvider
      navProvider.changeTab(1);
      await tester.pumpAndSettle();

      // Re-tapping Loans tab triggers refresh
      expect(loanProvider.fetchLoansCallCount, greaterThan(initialFetchCount));
    });

    testWidgets('CollectionsPage switches between Outstanding and Collected tabs with fresh provider calls', (tester) async {
      final colProvider = TestableCollectionListProvider();
      final collectedProvider = TestableCollectedListProvider();
      final navProvider = NavigationProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CollectionListProvider>.value(value: colProvider),
            ChangeNotifierProvider<CollectedListProvider>.value(value: collectedProvider),
            ChangeNotifierProvider<NavigationProvider>.value(value: navProvider),
          ],
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: const CollectionsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(colProvider.fetchCallCount, greaterThanOrEqualTo(1));

      // Switch to Collected tab
      await tester.tap(find.text('Collected'));
      await tester.pumpAndSettle();

      expect(collectedProvider.fetchCallCount, greaterThanOrEqualTo(1));
      expect(find.text('Dave'), findsOneWidget);

      // Switch back to Outstanding tab
      await tester.tap(find.text('Outstanding'));
      await tester.pumpAndSettle();

      expect(colProvider.fetchCallCount, greaterThanOrEqualTo(2));
      expect(find.text('Charlie'), findsOneWidget);
    });
  });
}
