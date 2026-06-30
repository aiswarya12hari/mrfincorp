import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mr_fincorp/FEATURES/Loans/data/models/individual_verify_sucess.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Storage/shared_preference.dart';

import '../models/individual_loan_verification_model.dart';

class IndividualLoanVerificationService {
  Future<IndividualVerifyResponseModel> verifyLoan({
    required String loanId,
    required IndividualLoanVerificationModel data,
  }) async {
    final token = AppPreferences.getAccessToken();

    final response = await http.patch(
      Uri.parse(ApiConfig.verifyIndividualLoan(loanId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return IndividualVerifyResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}
