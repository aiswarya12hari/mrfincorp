import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Storage/shared_preference.dart';

import '../models/group_verify_request_model.dart';
import '../models/group_verify_response_model.dart';

class GroupLoanVerificationService {
  Future<GroupVerifyResponseModel> verifyMember({
    required String loanId,
    required GroupVerifyRequestModel data,
  }) async {
    final token = AppPreferences.getAccessToken();

    final response = await http.patch(
      Uri.parse(ApiConfig.verifyGroupLoan(loanId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return GroupVerifyResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}