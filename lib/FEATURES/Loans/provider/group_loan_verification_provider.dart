import 'package:flutter/material.dart';

import '../data/models/group_verify_request_model.dart';
import '../data/models/group_verify_response_model.dart';
import '../data/services/group_loan_verification_service.dart';

class GroupLoanVerificationProvider extends ChangeNotifier {
  final GroupLoanVerificationService _service = GroupLoanVerificationService();

  bool isLoading = false;

  Future<GroupVerifyResponseModel> verifyMember({
    required String loanId,
    required GroupVerifyRequestModel data,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      return await _service.verifyMember(loanId: loanId, data: data);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}