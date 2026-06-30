import 'package:flutter/material.dart';

import '../data/models/loan_detail_model.dart';
import '../data/services/loan_detail_service.dart';

class LoanDetailProvider
    extends ChangeNotifier {
  final LoanDetailService _service =
      LoanDetailService();

  bool isLoading = false;

  LoanDetailModel? loanDetail;

  Future<void> fetchLoanDetail(
      String loanId) async {
    try {
      isLoading = true;
      notifyListeners();

      loanDetail =
          await _service.getLoanDetail(
        loanId,
      );
    } catch (e) {
      debugPrint(
        'DETAIL ERROR => $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}