import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../models/loan_detail_model.dart';

class LoanDetailService {
  Future<LoanDetailModel> getLoanDetail(String loanId) async {
    final response = await ApiClient.get(ApiConfig.loanDetail(loanId));

    if (response.statusCode == 200) {
      debugPrint("LOAN DETAIL RESPONSE => ${response.body}");
      return LoanDetailModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}
