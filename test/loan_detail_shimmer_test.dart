import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/loan_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/loan_detail_page.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/group_loan_detailpage.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/widgets/loan_shimmer.dart';
import 'package:mr_fincorp/FEATURES/Loans/provider/loan_detail_provider.dart';
import 'package:provider/provider.dart';

class MockLoanDetailProvider extends LoanDetailProvider {
  final bool _mockLoading;
  final LoanDetailModel? _mockDetail;

  MockLoanDetailProvider({bool isLoading = false, LoanDetailModel? detail})
      : _mockLoading = isLoading,
        _mockDetail = detail;

  @override
  bool get isLoading => _mockLoading;

  @override
  LoanDetailModel? get loanDetail => _mockDetail;

  @override
  Future<void> fetchLoanDetail(String loanId) async {
    // No-op for test
  }
}

void main() {
  testWidgets('LoanDetailPage displays LoanDetailShimmer when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LoanDetailProvider>(
            create: (_) => MockLoanDetailProvider(isLoading: true),
          ),
        ],
        child: const MaterialApp(
          home: LoanDetailPage(loanId: 'TEST-001'),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(LoanDetailShimmer), findsOneWidget);
  });

  testWidgets(
      'GroupLoanDetailPage displays GroupLoanDetailShimmer when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LoanDetailProvider>(
            create: (_) => MockLoanDetailProvider(isLoading: true),
          ),
        ],
        child: const MaterialApp(
          home: GroupLoanDetailPage(loanId: 'GRP-001'),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(GroupLoanDetailShimmer), findsOneWidget);
  });
}
