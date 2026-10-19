import 'dart:convert';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../models/group_verify_request_model.dart';
import '../models/group_verify_response_model.dart';

class GroupLoanVerificationService {
  Future<GroupVerifyResponseModel> verifyMember({
    required String loanId,
    required GroupVerifyRequestModel data,
  }) async {
    final response = await ApiClient.patch(
      ApiConfig.verifyGroupLoan(loanId),
      data.toJson(),
    );

    if (response.statusCode == 200) {
      return GroupVerifyResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}
