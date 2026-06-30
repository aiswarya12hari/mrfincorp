import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/individual_verify_sucess.dart';

import '../data/models/individual_loan_verification_model.dart';
import '../data/services/individual_loan_verification_service.dart';

class IndividualLoanVerificationProvider
    extends ChangeNotifier {
  final IndividualLoanVerificationService
      _service =
      IndividualLoanVerificationService();

  bool isLoading = false;

  Future<IndividualVerifyResponseModel> verifyLoan({
    required String loanId,
    required IndividualLoanVerificationModel
        data,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      return await _service.verifyLoan(
        loanId: loanId,
        data: data,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}