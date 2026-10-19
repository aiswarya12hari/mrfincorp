import 'dart:convert';

import 'package:mr_fincorp/FEATURES/Loans/data/models/individual_verify_sucess.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../models/individual_loan_verification_model.dart';

class IndividualLoanVerificationService {
  Future<IndividualVerifyResponseModel> verifyLoan({
    required String loanId,
    required IndividualLoanVerificationModel data,
  }) async {
    final response = await ApiClient.patch(
      ApiConfig.verifyIndividualLoan(loanId),
      data.toJson(),
    );

    if (response.statusCode == 200) {
      return IndividualVerifyResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}
