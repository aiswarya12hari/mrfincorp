import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Storage/shared_preference.dart';

import '../models/loan_detail_model.dart';

class LoanDetailService {
  Future<LoanDetailModel> getLoanDetail(
      String loanId) async {
    final token =
        AppPreferences.getAccessToken();

    final response = await http.get(
      Uri.parse(
        ApiConfig.loanDetail(loanId),
      ),
      headers: {
        'Authorization':
            'Bearer $token',
        'Content-Type':
            'application/json',
      },
    );

    if (response.statusCode == 200) {
      debugPrint("LOAN DETAIL RESPONSE => ${response.body}");
      return LoanDetailModel.fromJson(
        jsonDecode(response.body),
        
      );
      
    }

    throw Exception(response.body);
  }
}